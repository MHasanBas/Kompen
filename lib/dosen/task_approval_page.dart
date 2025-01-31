import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_task_page.dart';
import 'dashboard.dart';
import 'notifikasi.dart';
import 'ProfilePage.dart';
import '../about_page.dart';

final Dio dio = Dio();

String urlDomain = "https://kompen.kufoto.my.id";
String urlApprovalData = "$urlDomain/api/apply_mahasiswa";
String urlAccData = "$urlDomain/api/acc";
String urlDeclineData = "$urlDomain/api/decline";

class TaskApprovalPage extends StatefulWidget {
  @override
  _TaskApprovalPageState createState() => _TaskApprovalPageState();
}

class _TaskApprovalPageState extends State<TaskApprovalPage> {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });

    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await dio.post(
        urlApprovalData,
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      print('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['data'] is List) {
          setState(() {
            tasks = List<Map<String, dynamic>>.from(response.data['data']);
          });
        } else {
          setState(() {
            tasks = [];
          });
        }
      } else {
        throw Exception('Respons API tidak valid');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil data tugas')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
              'Application ${isApproved ? 'approved' : 'rejected'} successfully!',
            ),
          ),
        );
        fetchTasks();
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      print('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        toolbarHeight: 89.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Color(0xFF191970),
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
            tooltip: 'Info Pengembang',
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Approval Page',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : tasks.isEmpty
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
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final tugas = task['tugas'];
                          final mahasiswa = task['mahasiswa'];

                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: Image.asset(
                                'assets/task.jpg',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                tugas['tugas_nama'] ?? 'Nama Tugas Tidak Ditemukan',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mahasiswa: ${mahasiswa['mahasiswa_nama'] ?? 'Nama Tidak Ditemukan'}',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  Text(
                                    'NIM: ${mahasiswa['nim'] ?? 'NIM Tidak Ditemukan'}',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      updateStatus(task['apply_id'], false);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
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

