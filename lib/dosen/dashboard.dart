import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lihat_tugas.dart';
import 'task_approval_page.dart';
import 'notifikasi.dart';
import 'cek_tugas.dart';
import 'ProfilePage.dart';
import 'add_task_page.dart';
import 'alpha_mahasiswa_page.dart';
import 'KompenMahasiswaPage.dart';
import 'qr_code_page.dart';

const String urlDomain = "kompen.kufoto.my.id";
const String urlDashboard = "https://$urlDomain/api/dashboarddsn";
const String urlApprovalData = "https://$urlDomain/api/apply_mahasiswa";
const String urlAccData = "https://$urlDomain/api/acc";
const String urlDeclineData = "https://$urlDomain/api/decline";

final Dio dio = Dio();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Loading...";
  String userNidn = "Loading...";
  List<dynamic> applyTugas = [];

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await dio.post(
        urlDashboard,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          userName = data['user']?['dosen_nama'] ?? "Nama tidak tersedia";
          userNidn = data['user']?['nidn'] ?? "NIDN tidak tersedia";
          applyTugas = data['data'] ?? [];
        });
      } else {
        throw Exception('Gagal memuat tugas');
      }
    } catch (e) {
      setState(() {
        userName = "Error: $e";
        userNidn = "Error: $e";
        applyTugas = [];
      });
      print('Error: $e');
    }
  }

  Future<void> updateStatus(int applyId, bool isApproved) async {
    try {
      String? authToken = await getAuthToken();

      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final String url = isApproved ? urlAccData : urlDeclineData;

      final response = await dio.post(
        url,
        data: {'apply_id': applyId},
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Aplikasi ${isApproved ? 'disetujui' : 'ditolak'} dengan sukses!',
            ),
          ),
        );
        fetchData();
      } else {
        throw Exception('Gagal memperbarui status');
      }
    } catch (e) {
      print('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status')),
      );
    }
  }

 String formatName(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length > 2) {
      return '${nameParts[0]}  ${nameParts[1]} ..';
    }
    return name;
  }

  String formatNidn(String nidn) {
    if (nidn.length > 15) {
      return '${nidn.substring(0, 15)}...';
    }
    return nidn;
  }

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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 90,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                                formatName(userName),
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                formatNidn(userNidn),
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 13.0,
                                    color: Color.fromARGB(255, 87, 86, 86),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LihatTugasPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF191970),
                              ),
                              child: const Text(
                                'Lihat Tugas',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // QR code scanner button
                    Column(
                      children: [
                        const SizedBox(height: 32), // Add more space above the button
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0), // Move button to the right
                          child: IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            iconSize: 70.0,
                            color: const Color(0xFF191970),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QRCodePage()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AlphaMahasiswaPage()),
                      );
                    },
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Alpa Mahasiswa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF191970),
                      side: const BorderSide(color: Color(0xFF191970)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KompenMahasiswaPage()),
                      );
                    },
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
            applyTugas.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada yang apply',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: applyTugas.length,
                      itemBuilder: (context, index) {
                        final task = applyTugas[index];
                        final tugas = task['tugas'];
                        final mahasiswa = task['mahasiswa'];

                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: const Icon(Icons.assignment, size: 50),
                            title: Text(
                              tugas != null &&
                                      tugas.containsKey('tugas_nama') &&
                                      tugas['tugas_nama'] != null
                                  ? tugas['tugas_nama']
                                  : 'Raw Data: ${task.toString()}',
                            ),
                            subtitle: Text(
                              'Mahasiswa: ${mahasiswa != null ? mahasiswa['mahasiswa_nama'] : 'Unknown'}\n'
                              'NIM: ${mahasiswa != null ? mahasiswa['nim'] : 'Unknown'}\n'
                              'Status: ${task['approval']?['status'] ?? 'Pending'}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.red),
                                  onPressed: () {
                                    updateStatus(task['apply_id'], false);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check,
                                      color: Colors.green),
                                  onPressed: () {
                                    updateStatus(task['apply_id'], true);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      // Bottom Navigation Bar
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
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.access_time,
                    color: Colors.white, size: 30),
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
                    MaterialPageRoute(
                        builder: (context) => const NotifikasiPage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Profilescreen()),
                  );
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