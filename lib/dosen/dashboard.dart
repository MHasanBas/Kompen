import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/task.dart';
import 'lihat_tugas.dart';
import 'task_approval_page.dart';
import 'notifikasi.dart';
import 'package:kompen/dosen/Profile_Page.dart';
import 'cek_tugas.dart';

class HomeScreen extends StatelessWidget {
  final List<Task> tasks = [
    Task(
      title: 'Membuat PPT',
      description: 'Membuat Power Point presentasi mata kuliah',
    ),
    Task(
      title: 'Rekap Nilai',
      description:
          'Merekap nilai mahasiswa seluruh tingkat 3 menggunakan excel',
    ),
  ];

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
        backgroundColor: Colors.white,
        toolbarHeight: 90,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: const Color(0xFF191970),
                        child: const Icon(
                          Icons.person,
                          size: 40.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Faiz Abiyu',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            '21237880012',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LihatTugasPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF191970),
                            ),
                            child:Text('Lihat Tugas', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Status section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Alpa Mahasiswa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF191970),
                      side: const BorderSide(color: Color(0xFF191970)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.school),
                    label: const Text('Mahasiswa Kompen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF191970),
                      side: const BorderSide(color: Color(0xFF191970)),
                    ),
                  ),
                ],
              ),
            ),
            // Request Tasks section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Request Tugas',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Task cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.cloud_off,
                        size: 40.0,
                      ),
                      title: Text(
                        tasks[index].title,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Text(tasks[index].description),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Action when task is clicked
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[600],
                        ),
                        child: Text('Cek Request', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                      ),
                    ),
                  ),
                );
              },
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
                      MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.access_time,
                    color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskApprovalPage()));
                },
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const NotifikasiPage()), // Open NotifikasiPage
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const ProfilePage()), // Open ProfilePage
                  // );
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
            // Action when FAB is pressed
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
