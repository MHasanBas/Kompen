import 'package:flutter/material.dart';
import 'notification_detail_screen.dart'; 
import 'upload_proof_screen.dart'; 
import 'print_letter_screen.dart'; 
import 'tasks_screen.dart'; 
import 'history_screen.dart';
import 'home_page.dart';
import 'ProfilePage.dart';


class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Suka Kompen.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[900],
                  fontSize: 24,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.grey),
              onPressed: () {
                // Tambahkan aksi untuk filter
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notifikasi",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadProofScreen(),
                        ),
                      );
                    },
                    child: NotificationCard(
                      name: "Septian Enggar S.",
                      message: "Permintaan Kompen diterima.",
                      backgroundColor: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationDetailScreen(
                            title: "Permintaan Kompen merekap absensi diterima",
                            message: "Mohon segera dikerjakan.",
                          ),
                        ),
                      );
                    },
                    child: NotificationCard(
                      name: "Titis Octary S.",
                      message:
                          "Permintaan Kompen merekap absensi ditolak!\n cari pekerjaan lain.",
                      backgroundColor: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrintLetterScreen(),
                        ),
                      );
                    },
                    child: NotificationCard(
                      name: "Eka Larasati A.",
                      message: "Pekerjaan telah selesai. Terima Kasih.",
                      backgroundColor: Colors.green[200],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationDetailScreen(
                            title: "tugas Kompen merekap nilai ditolak",
                            message: "Notifikasi dari Farid Angga P , tugas kurang sesuai.",
                          ),
                        ),
                      );
                    },
                    child: NotificationCard(
                      name: "Farid Angga P.",
                      message: "Permintaan Kompen merekap nilai ditolak!",
                      backgroundColor: Colors.red[200],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.indigo[900], // Ubah warna bottom bar menjadi biru tua
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
             IconButton(
  icon: Icon(Icons.home, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // Sesuaikan dengan nama kelas 'HomePage'
    );
  },
),

              IconButton(
                icon: Icon(Icons.access_time, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  // Arahkan ke halaman Histori
              Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => HistoryScreen()), // Sesuaikan dengan nama kelas yang benar
);

                },
              ),
              SizedBox(width: 50), // Beri ruang lebih untuk tombol +
              IconButton(
  icon: Icon(Icons.mail, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationScreen()), // Sesuaikan dengan nama kelas 'NotificationScreen'
    );
  },
),

              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  // Aksi ke halaman profil
                     Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>ProfilePage()), // Sesuaikan dengan nama kelas 'NotificationScreen'
                  );
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
          backgroundColor: Colors.transparent, // Jadikan background transparan agar tidak bertumpuk
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

class NotificationCard extends StatelessWidget {
  final String name;
  final String message;
  final Color? backgroundColor;

  NotificationCard({
    required this.name,
    required this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[300],
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
