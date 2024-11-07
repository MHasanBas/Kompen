import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'akumulasi_page.dart'; // Impor AkumulasiPage
import 'kompen_card.dart';
import 'history_screen.dart';
import 'tasks_screen.dart';
import 'notification_screen.dart';
import 'ProfilePage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Suka Kompen.',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w900,
              color: Color(0xFF191970), // Dark Blue Color
            ),
          ),
        ),
        toolbarHeight: 89.0,
        automaticallyImplyLeading: false, // Remove back button
      ),

      // Mengubah warna background Scaffold menjadi #F9F9F9
      backgroundColor: const Color(0xFFF9F9F9),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF001C72), // Dark Blue Color from Figma
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  // Profile Icon
                  const CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person, // Placeholder icon for profile
                      size: 40.0,
                      color: Color(0xFF001C72), // Match icon color to the card
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hasan", // User name from the Figma
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "2241760069", // NIM
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Button "Yuk Kompen" doesn't navigate anymore
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TasksScreen()),
                      );
                      // Action can be left empty or define another action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                    ),
                    child: const Text(
                      "Yuk Kompen!",
                      style: TextStyle(
                        color: Color(0xFF001C72), // Dark Blue Color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Akumulasi Kompen Section now navigates to AkumulasiPage
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AkumulasiPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9), // Updated background color
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time, // Clock Icon
                          color: Color(0xFF191970),
                          size: 30.0,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "1000 Jam",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF191970), // Text color
                              ),
                            ),
                            Text(
                              "Alpha",
                              style: TextStyle(
                                color: Color(0xFF191970),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: const [
                            Text(
                              "+2 Jam",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4), // Added space
                            Text(
                              "Alpha",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: const [
                            Text(
                              "-5 Jam",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4), // Added space
                            Text(
                              "Alpha",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Rekomendasi Kompen Section
            Text(
              "Rekomendasi Kompen",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191970), // Dark Blue Color
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Kompen Cards with task description
            KompenCard(
              title: "Arsip Absensi",
              hours: "-14 Jam",
              description: "Menunjukkan status absensi dan jam kehadiran.",
              icon: Icons.archive, // Ikon untuk arsip absensi
            ),

            KompenCard(
              title: "Rekap Nilai",
              hours: "-10 Jam",
              description: "Melihat rekap hasil penilaian dari setiap tugas.",
              icon: Icons.assessment, // Ikon untuk rekap nilai
            ),
          ],
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
                            ProfilePage()), // Sesuaikan dengan nama kelas yang benar
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
