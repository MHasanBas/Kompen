import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'task_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Dio dio = Dio(); 

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> tasks = [];
  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await dio.post(
        'https://kompen.kufoto.my.id/api/tugas',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          tasks = data.map((task) {
            return {
              "taskId": int.tryParse(task["tugas_id"].toString()),
              "title": task["tugas_nama"] ?? "Judul tidak tersedia",
              "description": task["tugas_deskripsi"] ?? "Deskripsi tidak tersedia",
              "deadline": task["tugas_tenggat"] ?? "Tidak ada tenggat",
              "creator": task["pembuat_tugas"] ?? "Unknown",
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
          ? Center(child: CircularProgressIndicator())
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
                          SizedBox(height: 4),
                          Text(
                            "Pembuat: ${tasks[index]["creator"]}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      leading: Image.asset(
                        'assets/task.jpg',
                        width: 40,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(
                              taskId: tasks[index]["taskId"],
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
