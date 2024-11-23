import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_tugas.dart';
import 'ProfilePage.dart';
import 'task_approval_page.dart';
import 'notifikasi.dart';
import 'add_task_page.dart';

class LihatTugasPage extends StatefulWidget {
  const LihatTugasPage({Key? key}) : super(key: key);

  @override
  State<LihatTugasPage> createState() => _LihatTugasPageState();
}

class _LihatTugasPageState extends State<LihatTugasPage> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.194.83:8000/api", // Ganti dengan URL backend Laravel Anda
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  List<dynamic> _tugasList = [];
  bool _isLoading = true;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  // Ambil user_id dari SharedPreferences
  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('user_id') ?? ''; // Ambil user_id yang disimpan
    });
    if (_userId.isNotEmpty) {
      _fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID not found")),
      );
    }
  }

  // Fungsi untuk mengambil data tugas
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _dio.post("/tugas", data: {"user_id": _userId});
      setState(() {
        _tugasList = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching tasks: $e")),
      );
    }
  }

  // Fungsi untuk menambah tugas
  Future<void> _addTugas() async {
    try {
      // Misalnya Anda menambah tugas baru dengan data tertentu
      final response = await _dio.post("/tugas", data: {
        "user_id": _userId,
        "tugas_nama": "Tugas Baru",
        "tugas_deskripsi": "Deskripsi Tugas Baru",
        // Data lainnya sesuai kebutuhan
      });

      if (response.statusCode == 200) {
        // Refresh data setelah berhasil menambah tugas
        _fetchData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add task")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding task: $e")),
      );
    }
  }

  // Fungsi untuk menghapus tugas
  Future<void> _deleteTugas(String tugasId) async {
    try {
      final response = await _dio.delete("/tugas/$tugasId");

      if (response.statusCode == 200) {
        // Refresh data setelah berhasil menghapus tugas
        _fetchData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete task")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting task: $e")),
      );
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
                      ? const Center(child: Text("No tasks available"))
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
                                          color: Colors.blueAccent
                                              .withOpacity(0.2),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              tugas['tugas_deskripsi'] ??
                                                  'Deskripsi tidak tersedia',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Offline',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Text(
                                                  '-${tugas['durasi'] ?? '0'} Jam',
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
                  Navigator.pop(context); // Navigate back to HomePage
                },
              ),
              IconButton(
                icon: const Icon(Icons.access_time,
                    color: Colors.white, size: 30),
                onPressed: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => TaskApprovalPage()));
                },
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const NotifikasiPage()), // Open NotifikasiPage
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
