import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kompen/mahasiswa/cetak/cetaksurat.dart';
import 'package:kompen/mahasiswa/models/task.dart';
import 'notification_screen.dart';
import 'tasks_screen.dart';
import 'home_page.dart';
import 'ProfilePage.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SukaKompen(),
      routes: {
        '/cetak': (context) => CetakScreen(),
      },
    );
  }
}

class SukaKompen extends StatelessWidget {
  final List<Task> tasks = [
    Task(
      title: 'Membuat PPT',
      description: 'Tugas Berhasil dikerjakan!',
      tugas:
          'Membuat Presentasi (PPT) untuk mata kuliah ...., dengan materi ....',
      status: true,
      date: '02-09-2024',
      time: 10,
      type: 'Dosen',
      nama: 'Septian Enggar S. S.Pd., M.T.',
      jenis: 'online',
    ),
    Task(
      title: 'Arsip Absensi',
      description: 'Tugas Berhasil dikerjakan!',
      tugas:
          'Mengarsip kertas absensi dalam satu semester semua kelas dan prodi di satu jurusan di ruang admin secara lantai 6 gedung sipil offline',
      status: true,
      date: '21-08-2024',
      time: 5,
      type: 'Admin',
      nama: 'Titis Octary S.',
      jenis: 'Offline',
    ),
    Task(
      title: 'Update Database',
      description: 'Tugas Gagal dikerjakan!',
      tugas: 'Update database mahasiswa/dosen/dll di ruang admin',
      status: false,
      date: '19-01-2024',
      time: 0,
      type: 'Dosen',
      nama: 'Septian Enggar S. S.Pd., M.T.',
      jenis: 'Offline',
    ),
    Task(
      title: 'Input Nilai',
      description: 'Tugas Gagal dikerjakan!',
      tugas: 'Menginput nilai dari kertas ke dalam excel sebanyak 5 kelas',
      status: false,
      date: '21-08-2023',
      time: 0,
      type: 'Dosen',
      nama: 'Septian Enggar S. S.Pd., M.T.',
      jenis: 'Online',
    ),
    Task(
      title: 'Membeli Sandal JTI',
      description: 'Tugas Gagal dikerjakan!',
      tugas:
          'Membeli sandal untuk fasilitas umum mushola di jurusan teknologi informasi gedung sipil lantai 6',
      status: false,
      date: '02-03-2023',
      time: 0,
      type: 'Membeli Sandal JTI',
      nama: 'Lailatul Qodriyah',
      jenis: 'Offline',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Suka Kompen.',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF191970),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        leadingWidth: 482.0,
        toolbarHeight: 89.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Card(
                color: Colors.white,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/cetak',
                      arguments: task,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: GoogleFonts.exo(
                                textStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${task.type} | ${task.nama}',
                                  style: GoogleFonts.exo(
                                    textStyle: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  task.description,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Alpa Berkurang ${task.time} jam',
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Icon(
                              task.status ? Icons.check_circle : Icons.cancel,
                              color: task.status ? Colors.green : Colors.red,
                              size: 30,
                            ),
                            SizedBox(height: 35.0),
                            Text(
                              '${task.jenis} | ${task.date}',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        color: Colors.indigo[900], // Dark blue bottom bar
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to home
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage()), // Ganti 'HomePage()' sesuai dengan class dari home_page.dart
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.access_time,
                    color: Colors.white,
                    size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  // Arahkan ke halaman Histori
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HistoryScreen()), // Sesuaikan dengan nama kelas yang benar
                  );
                },
              ),
              SizedBox(width: 50), // Beri ruang lebih untuk tombol +
              IconButton(
                icon: Icon(Icons.mail,
                    color: Colors.white,
                    size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotificationScreen()), // Sesuaikan dengan nama kelas 'NotificationScreen'
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage()), // Sesuaikan dengan nama kelas 'NotificationScreen'
                  );
                  // Navigate to profile page
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 90, // Ukuran lingkaran FAB lebih besar
        height: 90, // Tinggi lingkaran FAB lebih besar
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Bentuk lingkaran penuh
          color: Colors.blueAccent, // Warna biru lebih cerah
        ),
        child: FloatingActionButton(
          elevation: 0, // Hapus elevation agar rata dengan lingkaran
          backgroundColor: Colors
              .transparent, // Jadikan background transparan agar tidak bertumpuk
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TasksScreen()),
            );
          },
          child: Icon(
            Icons.add,
            size: 50, // Ukuran icon + lebih besar dari icon biasa
            color: Colors.white, // Warna putih agar kontras
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
