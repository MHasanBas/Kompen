import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Untuk format tanggal


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddTaskPage(),
    );
  }
}

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _namaTugasController = TextEditingController();
  final TextEditingController _deskripsiTugasController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _jenisTugas = 'Offline';
  String _bidangKompetensi = 'Teknis';
  String _bobotTugas = '5 Jam';

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suka Kompen."),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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

              // Bagian Unggah File (Mock, tidak memiliki fungsi unggah)
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
                      child: Center(child: Text("file")),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      // Tangani unggah file di sini
                    },
                  ),
                ],
              ),
              Text(
                ".pdf .doc .xls .xlsx .pptx",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),

              // Dropdown Jenis Tugas
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _jenisTugas,
                      decoration: InputDecoration(
                        labelText: "Jenis Tugas",
                        border: OutlineInputBorder(),
                      ),
                      items: <String>['Offline', 'Online']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _jenisTugas = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),

                  // Dropdown Bidang Kompetensi
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _bidangKompetensi,
                      decoration: InputDecoration(
                        labelText: "Bidang Kompetensi",
                        border: OutlineInputBorder(),
                      ),
                      items: <String>['Teknis', 'Non-Teknis']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _bidangKompetensi = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Dropdown Bobot Tugas
              DropdownButtonFormField<String>(
                value: _bobotTugas,
                decoration: InputDecoration(
                  labelText: "Bobot Tugas",
                  border: OutlineInputBorder(),
                ),
                items: <String>['1 Jam', '3 Jam', '5 Jam']
                    .map((String value) {
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
              SizedBox(height: 16),

              // Date Picker Tenggat Tugas
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Tenggat Tugas",
                        border: OutlineInputBorder(),
                        // hintText: DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Tombol Simpan & Batal
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Simpan tugas logic
                        print('Tugas disimpan: ${_namaTugasController.text}');
                      },
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
                        // Batalkan tugas logic
                        Navigator.pop(context); // Kembali ke halaman sebelumnya
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            // Fungsi untuk menambah tugas (jika diperlukan)
          },
          child: Icon(
            Icons.add,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.indigo[900],
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => HomePage()), // Ganti dengan halaman yang sesuai
                  // );
                },
              ),
              IconButton(
                icon: Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => HistoryScreen()), // Ganti dengan halaman yang sesuai
                  // );
                },
              ),
              SizedBox(width: 50), // Ruang kosong untuk tombol mengapung
              IconButton(
                icon: Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => NotificationScreen()), // Ganti dengan halaman yang sesuai
                  // );
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ProfilePage()), // Ganti dengan halaman yang sesuai
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}