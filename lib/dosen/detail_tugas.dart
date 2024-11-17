import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'edit_tugas.dart';
import 'package:kompen/dosen/ProfilePage.dart';

final dio = Dio();

var all_data = [];

final TextEditingController usernameController = TextEditingController();
final TextEditingController namaController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

String url_domain = "http://192.168.18.30:8000";
String url_detail_data = url_domain + "/api/tugas/detail_data";

class DetailTugasPage extends StatefulWidget {
  final String tugasId; // ID tugas untuk diambil dari API

  const DetailTugasPage({Key? key, required this.tugasId, required Map<String, dynamic> tugas}) : super(key: key);

  @override
  _DetailTugasPage createState() => _DetailTugasPage();
}

class _DetailTugasPage extends State<DetailTugasPage> {
  Map<String, dynamic>? tugas;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTugas(widget.tugasId);
  }

  Future<void> fetchTugas(String tugasId) async {
    try {
      print("Fetching tugas with ID: $tugasId");

      Response response = await dio.post(
        url_detail_data,
        data: {"tugas_id": tugasId},
      );

      print("Response status code: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        setState(() {
          tugas = response.data;
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        throw Exception('Tugas tidak ditemukan');
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching tugas: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil detail tugas: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

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
                      tugas?['tugas_nama'] ?? 'Judul Tugas',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      tugas?['tugas_tipe'] ?? 'Status tidak tersedia',
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
                      tugas?['tugas_deskripsi'] ?? 'Deskripsi tidak tersedia',
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
                                builder: (context) =>
                                    AddTaskPage(), // Ganti EditTugasPage dengan widget dari halaman edit_tugas.dart
                              ),
                            );
                          },
                          child: Text(
                            'Edit Tugas',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6200EE),
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Aksi untuk hapus tugas
                          },
                          child: Text(
                            'Hapus Tugas',
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profilescreen()
                    )
                  );
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
