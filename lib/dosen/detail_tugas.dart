import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'edit_tugas.dart';

final dio = Dio();

String url_domain = "https://kompen.kufoto.my.id";
String url_detail_data = url_domain + "/api/tugas_dosen/detail_data";
String url_delete_data = url_domain + "/api/tugas_dosen/delete_data";

class DetailTugasPage extends StatefulWidget {
  final String tugasId;

  const DetailTugasPage({Key? key, required this.tugasId}) : super(key: key);

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
      Response response = await dio.post(
        url_detail_data,
        data: {"tugas_id": tugasId},
      );

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil detail tugas: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteData(String tugasId) async {
    // Show confirmation dialog before deleting
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Konfirmasi Hapus Tugas',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[900],
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus tugas ini?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.blueGrey[700],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF6200EE),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        Response response = await dio.post(
          url_delete_data,
          data: {"tugas_id": tugasId},
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tugas berhasil dihapus')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus tugas')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan saat menghapus tugas')),
        );
      }
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
        iconTheme: const IconThemeData(color: Color(0xFF191970)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
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
                          const SizedBox(height: 4),
                          Text(
                            tugas?['tugas_tipe'] ?? 'Status tidak tersedia',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              Image.asset(
                                'assets/description.png',
                                height: 250,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                tugas?['tugas_deskripsi'] ??
                                    'Deskripsi tidak tersedia',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.blueGrey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (tugas != null &&
                                          tugas!['tugas_id'] != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditTugasPage(
                                              tugasId: widget.tugasId,
                                              existingTugas: tugas,
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'ID tugas tidak ditemukan')),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6200EE),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                    ),
                                    child: Text(
                                      'Edit Tugas',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (tugas != null &&
                                          tugas!['tugas_id'] != null) {
                                        deleteData(widget.tugasId);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'ID tugas tidak ditemukan')),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                    ),
                                    child: Text(
                                      'Hapus Tugas',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: Colors.white),
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
                ],
              ),
            ),
    );
  }
}