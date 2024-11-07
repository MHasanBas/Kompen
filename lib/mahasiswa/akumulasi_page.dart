import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'ProfilePage.dart';
import 'notification_screen.dart';
import 'history_screen.dart';
import 'tasks_screen.dart';

class AkumulasiPage extends StatelessWidget {
  const AkumulasiPage({super.key});

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
              color: Color(0xFF191970),
            ),
          ),
        ),
        toolbarHeight: 89.0,
        automaticallyImplyLeading: false, // Hilangkan tombol kembali
      ),

      // Mengubah warna background Scaffold menjadi #F9F9F9
      backgroundColor: const Color(0xFFF9F9F9),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container utama yang mencakup ikon jam dan semester
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white, // Warna background header
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  // Baris pertama: Jam, Arrow Up, Arrow Down
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTimeInfo(Icons.access_time, "1000 Jam", "Alpha"),
                      _buildTimeInfoWithLabel(
                          Icons.arrow_upward, "+ 2 Jam", "Alpha",
                          color: Colors.green),
                      _buildTimeInfoWithLabel(
                          Icons.arrow_downward, "- 5 Jam", "Alpha",
                          color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                      color: Colors
                          .grey), // Divider garis antara header dan list semester

                  // Bagian tabel akumulasi per semester dengan garis pemisah antar semester
                  _buildSemesterRow("Semester 1", "16 Jam"),
                  const Divider(color: Colors.grey),
                  _buildSemesterRow("Semester 2", "12 Jam"),
                  const Divider(color: Colors.grey),
                  _buildSemesterRow("Semester 3", "12 Jam"),
                  const Divider(color: Colors.grey),
                  _buildSemesterRow("Semester 4", "12 Jam"),
                  const Divider(color: Colors.grey),
                  _buildSemesterRow("Semester 5", "12 Jam"),
                  const Divider(color: Colors.grey),
                  _buildSemesterRow("Semester 6", "12 Jam"),
                  const Divider(color: Colors.grey),
                  _buildSemesterRow("Semester 7", "12 Jam"),
                  const Divider(color: Colors.grey),
                  _buildSemesterRow("Semester 8", "12 Jam"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Bagian total akumulasi
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total Alpha = 100 Jam",
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),

      // Navigasi bawah mirip seperti HomePage
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


  // Fungsi untuk membuat tampilan dengan jam dan tulisan alpha di bawahnya
  Widget _buildTimeInfo(IconData icon, String time, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF191970), size: 24),
            const SizedBox(width: 8),
            Text(
              time,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF191970),
          ),
        ),
      ],
    );
  }

  // Fungsi untuk membuat icon dengan jam dan label "Alpha" di bawahnya
  Widget _buildTimeInfoWithLabel(IconData icon, String time, String label,
      {Color color = Colors.black}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              time,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: color),
        ),
      ],
    );
  }

  // Fungsi untuk membuat baris semester dengan garis pembatas
  Widget _buildSemesterRow(String semester, String hours) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 12.0), // Menambah jarak vertikal
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0), // Menambah padding kiri pada semester
            child: Text(semester, style: GoogleFonts.poppins(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: 8.0), // Menambah padding kanan pada jam
            child: Text(hours, style: GoogleFonts.poppins(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
