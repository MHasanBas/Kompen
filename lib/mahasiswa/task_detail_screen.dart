import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class TaskDetailScreen extends StatefulWidget {
  final int taskId; // Parameter tugas ID yang diterima dari halaman sebelumnya

  const TaskDetailScreen({Key? key, required this.taskId}) : super(key: key); // Konstruktor dengan parameter tugas ID

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Map<String, dynamic> taskDetail; // Variabel untuk menyimpan detail tugas
  bool isLoading = true; // Indikator loading saat data belum diambil

  final Dio dio = Dio(); // Inisialisasi Dio untuk melakukan request HTTP

  @override
  void initState() {
    super.initState();
    fetchTaskDetail(); // Mengambil detail tugas saat halaman pertama kali dimuat
  }

  // Fungsi untuk mengambil detail tugas berdasarkan taskId
  Future<void> fetchTaskDetail() async {
    try {
      final response = await dio.get(
        'http://192.168.122.83:8000/api/tugas/show', // URL API endpoint
        queryParameters: {
          'tugas_id': widget.taskId, // Mengirimkan tugas_id dalam query parameter
        },
      );

      // Cek jika status code response adalah 200 (OK)
      if (response.statusCode == 200) {
        setState(() {
          taskDetail = response.data; // Menyimpan data tugas ke dalam taskDetail
          isLoading = false; // Mengubah status loading menjadi false setelah data berhasil diterima
        });
      } else {
        throw Exception('Gagal memuat detail tugas');
      }
    } catch (e) {
      print("Error fetching task detail: $e"); // Menangkap error jika request gagal
      setState(() {
        isLoading = false; // Menghentikan loading meskipun terjadi error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.indigo[900]),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suka Kompen.',
              style: TextStyle(
                color: Colors.indigo[900],
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Menampilkan loading indicator jika data belum tersedia
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.task,
                            size: 80,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            taskDetail["tugas_nama"] ?? "Judul tidak tersedia", // Menampilkan nama tugas
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Offline',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'By Bu Titis',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            taskDetail["tugas_deskripsi"] ?? "Deskripsi tidak tersedia", // Menampilkan deskripsi tugas
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.access_time, color: Colors.black54),
                                  SizedBox(width: 8),
                                  Text(
                                    '16:00 PM\n9/14/2025',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.arrow_downward, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(
                                    '- 4 Jam\nAlpha',
                                    style: TextStyle(fontSize: 14, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Action saat tombol "Request Pekerjaan" ditekan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700], // Warna tombol
                      minimumSize: const Size(double.infinity, 50), // Ukuran tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Request Pekerjaan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
       bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.indigo[900], // Dark blue bottom bar
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to home screen
                },
              ),
              IconButton(
                icon: const Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to time screen
                },
              ),
              const SizedBox(width: 50), // Space for the FAB
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to messages screen
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to profile screen
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 90, // Larger size for the FAB
        height: 90,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent, // Brighter blue for the FAB
        ),
        child: FloatingActionButton(
          elevation: 0, // Remove elevation to flatten the FAB
          backgroundColor: Colors.transparent, // Transparent background
          onPressed: () {
            // Action for the FAB button, navigating to task screen
          },
          child: const Icon(
            Icons.add,
            size: 50, // Larger size for the plus icon
            color: Colors.white, // White color for the plus icon
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
