import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard.dart';
import 'notifikasi.dart';
import 'task_approval_page.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

final Dio dio = Dio();

String url_domain = "http://192.168.194.83:8000";
String url_detail_data = "$url_domain/api/detail_cek";
String url_download = "$url_domain/api/download";

class CekTugasPage extends StatefulWidget {
  final int tugasId;
  final int approvalId;
  final int progressId;

  const CekTugasPage({
    Key? key,
    required this.tugasId,
    required this.approvalId,
    required this.progressId,
  }) : super(key: key);

  @override
  _CekTugasPageState createState() => _CekTugasPageState();
}

class _CekTugasPageState extends State<CekTugasPage> {
  late Map<String, dynamic> taskDetail;
  bool isLoading = true;

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  void initState() {
    super.initState();
    fetchTaskDetail();
  }

  Future<void> fetchTaskDetail() async {
    String? authToken = await getAuthToken();
    if (authToken == null) {
      throw Exception('Token tidak ditemukan');
    }

    try {
      final response = await dio.post(
        url_detail_data,
        data: {
          'tugas_id': widget.tugasId,
          'progress_id': widget.progressId,
        },
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );

      setState(() {
        taskDetail = response.data;
        isLoading = false;
      });
    } catch (error) {
      throw Exception('Gagal memuat detail tugas: $error');
    }
  }

  Future<void> approveTask(bool isApproved) async {
    String? authToken = await getAuthToken();
    if (authToken == null) {
      throw Exception('Token tidak ditemukan');
    }

    final endpoint = isApproved ? '/api/terima' : '/api/tolak';

    try {
      final response = await dio.post(
        "$url_domain$endpoint",
        data: {'approval_id': widget.approvalId},
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isApproved ? 'Tugas Diterima' : 'Tugas Ditolak'),
            content: Text(response.data.toString()),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      throw Exception('Gagal mengubah status tugas: $error');
    }
  }

  void testPathProvider() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      print('Application Documents Directory: ${directory.path}');
    } catch (e) {
      print('Error Path Provider: $e');
    }
  }

  Future<void> downloadFile() async {
    String? authToken = await getAuthToken();
    if (authToken == null) {
      showErrorDialog('Token tidak ditemukan');
      return;
    }

    try {
      final response = await dio.post(
        url_download,
        queryParameters: {'progress_id': widget.progressId},
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      String fileName = taskDetail["file_mahasiswa"] ?? "unduhan_tugas";
      Directory directory = await getApplicationDocumentsDirectory();
      String savePath = "${directory.path}/$fileName";

      // Tulis file ke sistem
      await File(savePath).writeAsBytes(response.data);

      // Tampilkan dialog sukses
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Download Sukses'),
            content: Text('File berhasil diunduh: $savePath'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  OpenFile.open(savePath);
                },
                child: const Text('Buka File'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      showErrorDialog('Gagal mengunduh file: $error');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Received tugasId: ${widget.tugasId}, approvalId: ${widget.approvalId}, progressId: ${widget.progressId}');
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
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskDetail["tugas_nama"] ?? "Judul tidak tersedia",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.asset('/images/task_image.png', height: 100),
                          const SizedBox(height: 10),
                          Text(
                            taskDetail["mahasiswa_nama"] ?? "Nama mahasiswa tidak tersedia",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            taskDetail["tugas_deskripsi"] ?? "Deskripsi tidak tersedia",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Lampiran Tugas:',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.insert_drive_file, color: Colors.redAccent),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      downloadFile();
                                    },
                                    child: Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          taskDetail["file_mahasiswa"] ?? "File tidak tersedia",
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(fontSize: 14),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () => approveTask(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Terima Tugas',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => approveTask(false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Tolak Tugas',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        color: Colors.indigo[900],
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskApprovalPage()));
                },
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotifikasiPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {},
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
        child: IconButton(
          icon: const Icon(Icons.add, size: 40, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
