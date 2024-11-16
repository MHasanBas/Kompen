import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_tugas.dart';
import 'package:kompen/dosen/ProfilePage.dart';

class DetailTugasPage extends StatelessWidget {
  final Map<String, dynamic> tugas;

  const DetailTugasPage({Key? key, required this.tugas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          'Suka Kompen.',
          style: GoogleFonts.poppins(
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF191970),
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 80.0,
        elevation: 1,
        iconTheme: IconThemeData(color: const Color(0xFF191970)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Tugas Saya',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      tugas['title'] ?? 'Membuat PPT',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      tugas['status'] ?? 'Online',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 16),
                    Icon(
                      Icons.assignment,
                      size: 100, // Ukuran besar ikon
                      color: Colors.blueGrey[700], // Warna ikon
                    ),
                    SizedBox(height: 16),
                    Text(
                      tugas['description'] ?? 'Membuat Presentasi (PPT) untuk mata kuliah ...., dengan materi ....',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.blueGrey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                       ElevatedButton(
  onPressed: () {
    // Aksi untuk edit tugas, arahkan ke halaman edit_tugas.dart
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(), // Ganti EditTugasPage dengan widget dari halaman edit_tugas.dart
      ),
    );
  },
  child: Text(
    'Edit Tugas',
    style: GoogleFonts.poppins(fontSize: 14, color: Colors.white,),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF6200EE),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  ),
),

                        ElevatedButton(
                          onPressed: () {
                            // Aksi untuk hapus tugas
                          },
                          child: Text(
                            'Hapus Tugas',
                            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        color: Colors.indigo[900],
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigasi ke home
                },
              ),
              IconButton(
                icon: Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigasi ke halaman waktu
                },
              ),
              SizedBox(width: 50), // Space for the FAB
              IconButton(
                icon: Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigasi ke halaman pesan
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Profilescreen()));
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi untuk FAB
        },
        child: Icon(
          Icons.add,
          size: 50,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
