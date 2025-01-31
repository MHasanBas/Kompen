import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tasks_screen.dart';
import 'ProfilePage.dart';
import 'notification_screen.dart';
import 'history_screen.dart';
import 'home_page.dart';

final Dio dio = Dio();

String url_domain = "https://kompen.kufoto.my.id";
String url_apply_data = url_domain + "/api/apply";

class TaskDetailScreen extends StatefulWidget {
  final int taskId;

  const TaskDetailScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Map<String, dynamic> taskDetail = {};

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
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await dio.post(
        'https://kompen.kufoto.my.id/api/tugas/detail_data',
        queryParameters: {
          'tugas_id': widget.taskId, 
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          taskDetail = response.data;
          isLoading = false;
        });
      } else {
        String errorMessage = response.data['message'] ?? 'Gagal memuat detail tugas';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print("Error fetching task detail: $e");
      setState(() {
        isLoading = false;
      });

      String errorMessage = "Terjadi kesalahan, silakan coba lagi.";
      if (e is DioError) {
        if (e.response != null && e.response!.data != null) {
          errorMessage = e.response!.data['message'] ?? 'Gagal memuat data.';
        } else {
          errorMessage = 'Tidak ada respons dari server';
        }
      }
      
      _showCustomDialog(
        title: "Gagal Memuat Tugas",
        message: errorMessage,
        icon: Icons.error,
        color: Colors.red,
      );
    }
  }

  Future<void> applyForTask() async {
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await dio.post(
        url_apply_data,
        data: {
          'tugas_id': widget.taskId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 201) {
        _showCustomDialog(
          title: "Berhasil!",
          message: "Anda berhasil apply tugas ini.",
          icon: Icons.check_circle,
          color: Colors.green,
          navigateBack: true,
        );
      } else {
        String errorMessage = response.data['message'] ?? 'Gagal melakukan apply';
        throw Exception(errorMessage);
      }
    } catch (e) {
      String errorMessage = "Terjadi kesalahan, silakan coba lagi.";
      if (e is DioException) {
        // Handle DioError specifically and show the error message from the response
        if (e.response != null && e.response!.data != null) {
          errorMessage = e.response!.data['message'] ?? 'Gagal memuat data.';
        }
      }

      _showCustomDialog(
        title: "Gagal!",
        message: errorMessage,
        icon: Icons.error,
        color: Colors.red,
      );
    }
  }

  void _showCustomDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
    bool navigateBack = false,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              SizedBox(height: 10),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (navigateBack) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Navigates back to previous screen
                } else {
                  Navigator.of(context).pop(); // Just close the dialog
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.help_outline,
                  size: 80,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Konfirmasi Apply",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Apakah Anda yakin ingin apply untuk tugas ini?",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Color.fromARGB(255, 4, 1, 133), // Set your desired color here
                        ),
                      ),

      
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 11, 75, 128),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        applyForTask();
                      },
                    child: const Text(
                        'Lanjutkan',
                        style: TextStyle(
                          color: Color.fromARGB(255, 252, 254, 255), // Set your desired color here
                        ),
                      ),

                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
            Navigator.pop(context);
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
          ? Center(child: CircularProgressIndicator())
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
                  Image.asset(
                    'assets/description.png', // Path gambar di project Anda
                    height: 200,
                  ),
                          const SizedBox(height: 16),
                          Text(
                            taskDetail["tugas_nama"] ?? "Judul tidak tersedia",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                         const SizedBox(height: 4),
                          Text(
                            taskDetail["tugas_tipe"] ?? "Tipe tidak tersedia", // Menampilkan teks sesuai dengan tugas tipe
                            style: TextStyle(
                              fontSize: 14,
                              color: taskDetail["tugas_tipe"] == "online" 
                                  ? Colors.green  // Jika "online", warna hijau
                                  : Colors.red,   // Jika "offline", warna merah
                            ),
                          ),

                          SizedBox(height: 8),
                          Text(
                            "By " + (taskDetail["pembuat_tugas"] ?? "Unknown"),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            taskDetail["tugas_deskripsi"] ?? "Deskripsi tidak tersedia",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                           const SizedBox(height: 16),
                          // New Competencies Section
                          if (taskDetail["kompetensi"] != null && 
                              taskDetail["kompetensi"] is List && 
                              taskDetail["kompetensi"].isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kompetensi yang Dibutuhkan:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo[900],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (taskDetail["kompetensi"] as List)
                                      .map((competency) => Chip(
                                            label: Text(competency),
                                            backgroundColor: Colors.blue[50],
                                            labelStyle: TextStyle(
                                              color: Colors.indigo[900],
                                              fontSize: 12,
                                            ),
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time, color: Colors.black54),
                                  const SizedBox(width: 8),
                                  Text(
                                    taskDetail["tugas_tenggat"] ?? "Tenggat tidak tersedia",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              
                              Row(
                                children: [
                                  const Icon(Icons.arrow_downward, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Text(
                                    "-" + taskDetail["tugas_jam_kompen"].toString() + " Jam",
                                    style: const TextStyle(fontSize: 14, color: Colors.red),
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
                    onPressed: showConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Apply Pekerjaan',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage()), // Sesuaikan dengan nama kelas yang benar
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


  