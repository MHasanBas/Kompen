import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';


final Dio dio = Dio();

String url_domain = "http://192.168.18.30:8000";
String url_detail_data = url_domain + "/api/tugas/show";
String url_apply_data = url_domain + "/api/apply";

class TaskDetailScreen extends StatefulWidget {
  final int taskId;

  const TaskDetailScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
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
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await dio.get(
        url_detail_data,
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
        throw Exception('Gagal memuat detail tugas');
      }
    } catch (e) {
      print("Error fetching task detail: $e");
      setState(() {
        isLoading = false;
      });
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil melakukan apply!')),
        );
      } else {
        throw Exception('Gagal melakukan apply');
      }
    } catch (e) {
      print("Error applying for task: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
                          const Icon(
                            Icons.task,
                            size: 80,
                            color: Colors.blueAccent,
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
                            taskDetail["tugas_tipe"] ?? "Tipe tidak tersedia",
                            style: const TextStyle(
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
                            taskDetail["tugas_deskripsi"] ?? "Deskripsi tidak tersedia",
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
                                    taskDetail["tugas_alpha"] ?? "Alpha tidak tersedia",
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
                    onPressed: applyForTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      minimumSize: const Size(double.infinity, 50),
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
        color: Colors.indigo[900],
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {},
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {},
        child: const Icon(
          Icons.add,
          size: 50,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
