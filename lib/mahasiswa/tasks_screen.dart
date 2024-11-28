import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'task_detail_screen.dart';

final Dio dio = Dio(); // Inisialisasi Dio untuk HTTP request

// URL API
final String baseUrl = "http://192.168.194.83:8000/api/tugas";

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> tasks = []; // Menyimpan daftar tugas

  @override
  void initState() {
    super.initState();
    fetchTasks(); // Ambil data dari API saat pertama kali dimuat
  }

  // Fungsi untuk mengambil data tugas dari API
  Future<void> fetchTasks() async {
    try {
      final response = await dio.post(
        baseUrl,
        data: {}, // Jika tidak membutuhkan data tambahan, kirim objek kosong
        options: Options(
          headers: {
            'Content-Type': 'application/json', // Pastikan tipe konten sesuai
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          tasks = data.map((task) {
            return {
              "taskId": task["tugas_id"],
              "title": task["tugas_nama"] ?? "Judul tidak tersedia",
              "description": task["tugas_deskripsi"] ?? "Deskripsi tidak tersedia",
              "deadline": task["tugas_tenggat"],
            };
          }).toList();
        });
      } else {
        throw Exception('Gagal memuat data tugas. Kode status: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tugas"),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loader saat data belum tersedia
          : Container(
              color: Colors.grey[100],
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        tasks[index]["title"],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tasks[index]["description"],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Tenggat: ${tasks[index]["deadline"]}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.redAccent,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      leading: Icon(
                        Icons.task,
                        size: 40,
                        color: Colors.blueAccent,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(
                              taskId: tasks[index]["taskId"], // Mengirimkan taskId
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
