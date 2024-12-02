import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_tugas.dart';
import 'ProfilePage.dart';
import 'task_approval_page.dart';
import 'notifikasi.dart';
import 'add_task_page.dart';
import 'dashboard.dart';

class LihatTugasPage extends StatefulWidget {
  const LihatTugasPage({Key? key}) : super(key: key);

  @override
  State<LihatTugasPage> createState() => _LihatTugasPageState();
}

class _LihatTugasPageState extends State<LihatTugasPage> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.236.129:8000/api", // Ganti dengan URL backend Laravel Anda
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  List<dynamic> _tugasList = [];
  bool _isLoading = true;

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  void initState() {
    super.initState();
    _getUserIdAndToken();
  }

  Future<void> _getUserIdAndToken() async {
    String? authToken = await getAuthToken();
    if (authToken == null) {
      throw Exception('Token tidak ditemukan');
    }

    if (authToken.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $authToken';
      _fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User Token not found")),
      );
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _dio.post("/tugas_dosen");
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        setState(() {
          _tugasList = response.data['data'];
        });
      } else {
        setState(() {
          _tugasList = []; // Jika gagal, tetap kosong
        });
      }
    } catch (e) {
      setState(() {
        _tugasList = []; // Tangani error dengan mengosongkan daftar
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suka Kompen.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tugas Saya',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _tugasList.isEmpty
                      ? const Center(
                          child: Text(
                            "Belum ada tugas yang di-upload",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: _tugasList.length,
                          itemBuilder: (context, index) {
                            final tugas = _tugasList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailTugasPage(
                                      tugasId: tugas['tugas_id'].toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.assignment,
                                          size: 40,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tugas['tugas_nama'] ?? 'Tugas',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Dosen | ${tugas['pengajar'] ?? 'Unknown'}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              tugas['tugas_deskripsi'] ?? 'Deskripsi tidak tersedia',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  tugas['tugas_tipe'] == 'online' ? 'Online' : 'Offline',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: tugas['tugas_tipe'] == 'online'
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ),
                                                Text(
                                                  '-${tugas['tugas_jam_kompen'] ?? '0'} Jam',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TaskApprovalPage()));
                },
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotifikasiPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage()));
        },
        child: const Icon(Icons.add, size: 40),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
