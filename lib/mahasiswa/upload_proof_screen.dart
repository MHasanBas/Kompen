import 'package:flutter/material.dart';
import 'package:kompen/mahasiswa/tasks_screen.dart'; // Tambahkan ini untuk import TasksScreen

class UploadProofScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suka Kompen."),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Membuat PPT",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Online",
                            style: TextStyle(color: Colors.green),
                          ),
                          SizedBox(height: 8),
                          Icon(
                            Icons.task,
                            size: 100,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "By Septain Enggar",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Mengarsip kertas absensi dalam satu semester semua kelas dan prodi di satu jurusan di ruang admin secara lantai 6 gedung sipil offline",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.assignment, color: Colors.blue),
                      title: Text("Tugas PPT.pptx"),
                      trailing: Icon(Icons.download),
                      onTap: () {
                        // Aksi download file
                      },
                    ),
                    Divider(),
                    SizedBox(height: 8),
                    Text(
                      "Upload Bukti Pekerjaan",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nama File Tugas',
                        hintText: 'Contoh: PPT_Presentasi',
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Aksi untuk mengupload bukti tugas
                      },
                      icon: Icon(Icons.upload_file),
                      label: Text("Upload File"),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.grey),
                            SizedBox(width: 4),
                            Text("16:00 PM"),
                            SizedBox(width: 8),
                            Text("9/14/2025"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.arrow_downward, color: Colors.red),
                            SizedBox(width: 4),
                            Text("- 4 Jam"),
                            Text(" Alpha", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          SizedBox(height: 16),
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green, // Mengatur warna latar belakang tombol
    foregroundColor: Colors.white, // Mengatur warna teks tombol
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  onPressed: () {
    // Aksi untuk mengirim tugas
  },
  child: Text(
    "Kirim Pekerjaan",
    style: TextStyle(fontSize: 18),
  ),
),
SizedBox(height: 24),

          ],
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
                  // Aksi untuk navigasi ke Home
                },
              ),
              IconButton(
                icon: Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {
                  // Aksi untuk navigasi ke halaman riwayat
                },
              ),
              SizedBox(width: 50),
              IconButton(
                icon: Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  // Aksi untuk navigasi ke halaman pesan
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  // Aksi untuk navigasi ke halaman profil
                },
              ),
            ],
          ),
        ),
      ),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TasksScreen()), // Navigasi ke halaman tugas
            );
          },
          child: Icon(
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
