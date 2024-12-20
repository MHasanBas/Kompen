import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path_helper;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lihat_tugas.dart';
import 'dashboard.dart';
import 'notifikasi.dart';
import 'task_approval_page.dart';
import 'ProfilePage.dart';
import '../about_page.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _namaTugasController = TextEditingController();
  final TextEditingController _deskripsiTugasController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String _tipeTugas = 'Online';
  String? _jenisTugas;
  List<String> _selectedBidangKompetensi = [];
  String _bobotTugas = '1 Jam';
  String? _filePath;

  List<dynamic> _jenisTugasOptions = [];
  List<dynamic> _bidangKompetensiOptions = [];

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('Auth Token: $token');  // Debug the token value
    return token;
  }

  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://kompen.kufoto.my.id/api'));

  @override
  void initState() {
    super.initState();
    _fetchOptions();
  }

  Future<void> _fetchOptions() async {
    try {
      final jenisTugasResponse = await _dio.get('/jenis_tugas');
      final bidangKompetensiResponse = await _dio.get('/bidang_kompetensi');

      setState(() {
        _jenisTugasOptions = jenisTugasResponse.data;
        _bidangKompetensiOptions = bidangKompetensiResponse.data;
      });
    } on DioError catch (e) {
      _showErrorAlert('Gagal memuat pilihan: ${e.response?.data}');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
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
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'pptx'],
    );
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  Future<void> _addTask(Map<String, dynamic> taskData, BuildContext context) async {
  try {
    FormData formData = FormData.fromMap(taskData);
    
    if (_filePath != null) {
      formData.files.add(
        MapEntry(
          "file_tugas",
          await MultipartFile.fromFile(_filePath!, filename: path_helper.basename(_filePath!)),
        ),
      );
    }

    Dio dio = Dio();
    String? authToken = await getAuthToken();
    if (authToken == null) {
      throw Exception('Token tidak ditemukan');
    }

    dio.options.headers['Authorization'] = 'Bearer $authToken';

    final response = await dio.post('https://kompen.kufoto.my.id/api/tugas_dosen/create_data', data: formData);

    if (response.statusCode == 200) {
      _showSuccessAlert(context);
    } else {
      _showErrorAlert('Gagal menambahkan tugas: ${response.data['message'] ?? 'Terjadi kesalahan'}');
    }
  } on DioError catch (e) {
    print('Error: ${e.response?.statusCode} ${e.response?.data}');
    
    String errorMessage = 'Terjadi kesalahan';
    if (e.response != null) {
      errorMessage = e.response?.data['message'] ?? 'Tidak ada pesan kesalahan';
    } else {
      errorMessage = e.message ?? 'Kesalahan tidak terduga';
    }

    _showErrorAlert('Gagal menambahkan tugas: $errorMessage');
  } catch (e) {
    print('Unexpected Error: $e');
    _showErrorAlert('Gagal menambahkan tugas: Terjadi kesalahan tak terduga');
  }
}

  void _showSuccessAlert(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Berhasil",
      desc: "Tugas berhasil ditambahkan",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => LihatTugasPage())
            );
          },
          width: 120,
        )
      ],
    ).show();
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

  void _saveTask() {
    if (_namaTugasController.text.isEmpty) {
      _showErrorAlert('Nama Tugas harus diisi');
      return;
    }

    if (_jenisTugas == null) {
      _showErrorAlert('Jenis Tugas harus dipilih');
      return;
    }

    if (_selectedBidangKompetensi.isEmpty) {
      _showErrorAlert('Bidang Kompetensi harus dipilih');
      return;
    }

    final Map<String, dynamic> taskData = {
      'user_id': 1, // Replace with actual user ID
      'tugas_nama': _namaTugasController.text,
      'tugas_No': DateTime.now().millisecondsSinceEpoch.toString(),
      'jenis_id': _jenisTugas,
      'tugas_tipe': _tipeTugas,
      'tugas_deskripsi': _deskripsiTugasController.text,
      'tugas_kuota': 1,
      'tugas_jam_kompen': int.parse(_bobotTugas.split(' ')[0]),
      'tugas_tenggat': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'kompetensi_id[]': _selectedBidangKompetensi,  // Kirim sebagai array
    };

    _addTask(taskData, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Suka Kompen.',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w900,
              color: Color(0xFF191970),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 90,
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Color(0xFF191970),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
            tooltip: 'Info Pengembang',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _namaTugasController,
                decoration: InputDecoration(
                  labelText: "Nama Tugas",
                  hintText: "Membuat PPT",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _deskripsiTugasController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Deskripsi Tugas",
                  hintText: "Membuat Presentasi (PPT) untuk mata kuliah ...",
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
                      child: Center(child: Text(_filePath != null ? path_helper.basename(_filePath!) : "Pilih file")),
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
                      items: <String>['Online', 'Offline'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
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
                      items: _jenisTugasOptions.map<DropdownMenuItem<String>>((dynamic value) {
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

             Text("Bidang Kompetensi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Wrap(
                spacing: 8.0, // Horizontal space between checkboxes
                runSpacing: 8.0, // Vertical space between rows
                children: _bidangKompetensiOptions.map((dynamic value) {
                  return Container(
                    width: (MediaQuery.of(context).size.width - 40) / 2, // Set the width for two columns
                    child: CheckboxListTile(
                      title: Text(value['kompetensi_nama'], style: TextStyle(fontSize: 14)), // Smaller text size
                      value: _selectedBidangKompetensi.contains(value['kompetensi_id'].toString()),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedBidangKompetensi.add(value['kompetensi_id'].toString());
                          } else {
                            _selectedBidangKompetensi.remove(value['kompetensi_id'].toString());
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
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _bobotTugas,
                      decoration: InputDecoration(
                        labelText: "Bobot Tugas",
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(10, (index) => '${index + 1} Jam').map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _bobotTugas = newValue!;
                        });
                      },
                    ),
                  ),
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

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      child: Text("Simpan Tugas"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Batal"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        color: Colors.indigo[900],
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TaskApprovalPage()));
                },
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotifikasiPage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Profilescreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 90,
        height: 90,

        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskPage()),
            );
          },
          child: const Icon(
            Icons.add,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

 