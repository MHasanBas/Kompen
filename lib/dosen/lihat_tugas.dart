import 'package:flutter/material.dart';
import 'detail_tugas.dart';

class LihatTugasPage extends StatelessWidget {
  final List<Map<String, dynamic>> tugasList = [
    {
      "title": "Membuat PPT",
      "dosen": "Septian Enggar",
      "description": "Membuat PPT dengan materi pemrograman dasar untuk tingkat 1",
      "status": "Offline",
      "deadline": "-10 Jam",
    },
    {
      "title": "Input Nilai",
      "dosen": "Septian Enggar",
      "description": "Menginput nilai kuis ke excel untuk mahasiswa tingkat 2",
      "status": "Offline",
      "deadline": "-10 Jam",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suka Kompen.'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.blue.shade800,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tugas Saya',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tugasList.length,
                itemBuilder: (context, index) {
                  final tugas = tugasList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailTugasPage(tugas: tugas),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.assignment,
                              size: 50,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tugas['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  Text(
                                    'Dosen | ${tugas['dosen']}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    tugas['description'],
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tugas['status'],
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        tugas['deadline'],
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi untuk tombol scan QR
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.qr_code_scanner, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  // Navigasi ke HomeScreen
                },
              ),
              IconButton(
                icon: Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigasi ke HistoryScreen
                },
              ),
              SizedBox(width: 50),
              IconButton(
                icon: Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigasi ke TaskApprovalPage
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigasi ke ProfilePage
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
