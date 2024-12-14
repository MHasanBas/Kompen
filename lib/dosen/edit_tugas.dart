import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path_helper;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';
import 'lihat_tugas.dart';

class EditTugasPage extends StatefulWidget {
  final String? tugasId;
  final Map<String, dynamic>? existingTugas;

  const EditTugasPage({Key? key, this.tugasId, this.existingTugas}) : super(key: key);

  @override
  _EditTugasPageState createState() => _EditTugasPageState();
}

class _EditTugasPageState extends State<EditTugasPage> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://kompen.kufoto.my.id/api'));

  final TextEditingController _namaTugasController = TextEditingController();
  final TextEditingController _deskripsiTugasController = TextEditingController();
  final TextEditingController _kuotaController = TextEditingController();
  final TextEditingController _jamKompenController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  
  String? _tipeTugas;
  String? _jenisTugas;
  List<String> _selectedKompetensi = [];

  List<dynamic> _jenisTugasList = [];
  List<dynamic> _kompetensiList = [];

  bool _isLoading = true;
  String? _filePath;
  String _bobotTugas = '1 Jam';

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      // Fetch Jenis Tugas
      final jenisTugasResponse = await _dio.get('/jenis_tugas');
      // Fetch Bidang Kompetensi
      final kompetensiResponse = await _dio.get('/bidang_kompetensi');

      setState(() {
        _jenisTugasList = jenisTugasResponse.data;
        _kompetensiList = kompetensiResponse.data;

        // If editing existing tugas, populate fields
        if (widget.existingTugas != null) {
          _namaTugasController.text = widget.existingTugas!['tugas_nama'] ?? '';
          _deskripsiTugasController.text = widget.existingTugas!['tugas_deskripsi'] ?? '';
          _tipeTugas = widget.existingTugas!['tugas_tipe']?.toLowerCase();
          _jenisTugas = widget.existingTugas!['jenis_id']?.toString();
          _kuotaController.text = widget.existingTugas!['tugas_kuota']?.toString() ?? '1';
          _jamKompenController.text = widget.existingTugas!['tugas_jam_kompen']?.toString() ?? '1';
          
          // Populate selected kompetensi
          _selectedKompetensi = (widget.existingTugas!['kompetensi_list'] as List? ?? [])
              .map<String>((k) => k['kompetensi_id'].toString())
              .toList();

          // Set selected date if available
          if (widget.existingTugas!['tugas_tenggat'] != null) {
            _selectedDate = DateTime.parse(widget.existingTugas!['tugas_tenggat']);
          }
        }

        _isLoading = false;
      });
    } catch (e) {
      _showErrorAlert('Gagal memuat data awal: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  void _showErrorAlert(String message) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Error",
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  void _showSuccessAlert(BuildContext context) {
  Alert(
    context: context,
    type: AlertType.success,
    title: "Berhasil",
    desc: "Tugas berhasil diperbarui",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context); // Close the alert dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LihatTugasPage()), // Navigate to LihatTugasPage
          );
        },
        width: 120,
      )
    ],
  ).show();
}



  Future<void> _updateTugas() async {
    if (_validateForm()) {
      try {
        FormData formData = FormData.fromMap({
          'tugas_id': widget.tugasId,
          'user_id': 1, // Replace with actual user ID
          'tugas_nama': _namaTugasController.text,
          'jenis_id': _jenisTugas,
          'tugas_tipe': _tipeTugas,
          'tugas_deskripsi': _deskripsiTugasController.text,
          'tugas_kuota': int.parse(_kuotaController.text),
          'tugas_jam_kompen': int.parse(_jamKompenController.text),
          'tugas_tenggat': DateFormat('yyyy-MM-dd').format(_selectedDate),
          'kompetensi_id[]': _selectedKompetensi,
        });

        // Tambahkan file jika dipilih
        if (_filePath != null) {
          formData.files.add(MapEntry(
            'file_tugas', 
            MultipartFile.fromFileSync(_filePath!, filename: path_helper.basename(_filePath!))
          ));
        }

        final response = await _dio.post(
          '/tugas_dosen/update_data',
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
          ),
        );

        if (response.data['status'] == true) {
          _showSuccessAlert(context);
        } else {
          _showErrorAlert(response.data['message'] ?? 'Gagal memperbarui tugas');
        }
      } on DioError catch (e) {
        String errorMessage = e.response?.data['message'] ?? 'Terjadi kesalahan';
        _showErrorAlert(errorMessage);
      }
    }
  }

  bool _validateForm() {
    if (_namaTugasController.text.isEmpty) {
      _showErrorAlert('Nama Tugas harus diisi');
      return false;
    }
    if (_jenisTugas == null) {
      _showErrorAlert('Jenis Tugas harus dipilih');
      return false;
    }
    if (_tipeTugas == null) {
      _showErrorAlert('Tipe Tugas harus dipilih');
      return false;
    }
    if (_selectedKompetensi.isEmpty) {
      _showErrorAlert('Minimal satu kompetensi harus dipilih');
      return false;
    }
    if (_kuotaController.text.isEmpty) {
      _showErrorAlert('Kuota harus diisi');
      return false;
    }
    if (_jamKompenController.text.isEmpty) {
      _showErrorAlert('Jam Kompen harus diisi');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Tugas",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _namaTugasController,
                decoration: InputDecoration(
                  labelText: "Nama Tugas",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _deskripsiTugasController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Deskripsi Tugas",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              Text("Upload File"),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text(_filePath != null 
                        ? path_helper.basename(_filePath!) 
                        : "Pilih file")),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: _pickFile,
                  ),
                ],
              ),
              Text(".pdf .doc .xls .xlsx .pptx", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _tipeTugas,
                      decoration: InputDecoration(
                        labelText: "Tipe Tugas",
                        border: OutlineInputBorder(),
                      ),
                      items: <String>['online', 'offline'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.capitalize()),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _tipeTugas = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _jenisTugas,
                      decoration: InputDecoration(
                        labelText: "Jenis Tugas",
                        border: OutlineInputBorder(),
                      ),
                      items: _jenisTugasList.map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value['jenis_id'].toString(),
                          child: Text(value['jenis_nama']),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _jenisTugas = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _kuotaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Kuota Peserta",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _jamKompenController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Jam Kompen",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Text("Bidang Kompetensi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _kompetensiList.map((dynamic value) {
                  return Container(
                    width: (MediaQuery.of(context).size.width - 40) / 2,
                    child: CheckboxListTile(
                      title: Text(value['kompetensi_nama'], style: TextStyle(fontSize: 14)),
                      value: _selectedKompetensi.contains(value['kompetensi_id'].toString()),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedKompetensi.add(value['kompetensi_id'].toString());
                          } else {
                            _selectedKompetensi.remove(value['kompetensi_id'].toString());
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                 
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Tenggat Tugas",
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: DateFormat('yyyy-MM-dd').format(_selectedDate),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Center(
                child: ElevatedButton(
                  onPressed: _updateTugas,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, 
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Update Tugas',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _namaTugasController.dispose();
    _deskripsiTugasController.dispose();
    _kuotaController.dispose();
    _jamKompenController.dispose();
    super.dispose();
  }
}

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}