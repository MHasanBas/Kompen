import 'package:flutter/material.dart';
import 'package:kompen/dosen/ProfilePage.dart';
import 'detail_tugas.dart';
import 'dashboard.dart';
import 'notifikasi.dart';
import 'task_approval_page.dart'; // Import sesuai dengan nama file TaskApprovalPage
import 'add_task_page.dart';

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
        title: const Text('Suka Kompen.'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 10, 54, 105),
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
            const SizedBox(height: 16),
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
                          builder: (context) => DetailTugasPage(tugas: tugas, tugasId: '1',),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.assignment,
                              size: 50,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 16),
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
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tugas['description'],
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tugas['status'],
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        tugas['deadline'],
                                        style: const TextStyle(color: Colors.red),
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        color: const Color(0xFF191970),
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
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskApprovalPage()),
                  );
                },
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotifikasiPage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Profilescreen()));
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
