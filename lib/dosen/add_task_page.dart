import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

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
  String? _bidangKompetensi;
  String _bobotTugas = '1 Jam';
  String? _filePath;

  List<dynamic> _jenisTugasOptions = [];
  List<dynamic> _bidangKompetensiOptions = [];

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://192.168.194.83:8000/api'));

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
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
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
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  Future<void> _addTask(Map<String, dynamic> taskData) async {
    try {
      FormData formData = FormData.fromMap(taskData);
      if (_filePath != null) {
        formData.files.add(
          MapEntry(
            "file",
            await MultipartFile.fromFile(_filePath!, filename: basename(_filePath!)),
          ),
        );
      }
      final response = await _dio.post('/tugas_dosen/create_data', data: formData);
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
    } on DioError catch (e) {
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
    }
  }

  void _saveTask() async {
    final Map<String, dynamic> taskData = {
      'user_id': 1, // Replace with actual user ID
      'tugas_nama': _namaTugasController.text,
      'tugas_No': 'unique_task_id', // Replace with actual logic to generate unique ID
      'jenis_id': _jenisTugas,
      'tugas_tipe': _tipeTugas,
      'tugas_deskripsi': _deskripsiTugasController.text,
      'tugas_kuota': 1, // Replace with actual data
      'tugas_jam_kompen': int.parse(_bobotTugas.split(' ')[0]), // Extract the numerical value
      'tugas_tenggat': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'kompetensi_id': _bidangKompetensi,
    };

    await _addTask(taskData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suka Kompen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Nama Tugas
              TextField(
                controller: _namaTugasController,
                decoration: InputDecoration(
                  labelText: "Nama Tugas",
                  hintText: "Membuat PPT",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Input Deskripsi Tugas
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

              // Upload File
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
                      child: Center(child: Text(_filePath != null ? basename(_filePath!) : "file")),
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

              // Tipe dan Jenis Tugas
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

              // Kompetensi dan Bobot Tugas
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _bidangKompetensi,
                      decoration: InputDecoration(
                        labelText: "Bidang Kompetensi",
                        border: OutlineInputBorder(),
                      ),
                      items: _bidangKompetensiOptions.map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value['kompetensi_id'].toString(),
                          child: Text(value['kompetensi_nama']),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _bidangKompetensi = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
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
                ],
              ),
              SizedBox(height: 16),

              // Tenggat Tugas
              TextFormField(
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
              SizedBox(height: 16),

              // Tombol Simpan dan Batal
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
    );
  }
}
