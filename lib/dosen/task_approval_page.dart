import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Dio dio = Dio();

String url_domain = "http://192.168.194.83:8000";
String url_approval_data = url_domain + "/api/apply_mahasiswa";
String url_acc_data = url_domain + "/api/acc";
String url_decline_data = url_domain + "/api/decline";

class TaskApprovalPage extends StatefulWidget {
  @override
  _TaskApprovalPageState createState() => _TaskApprovalPageState();
}

class _TaskApprovalPageState extends State<TaskApprovalPage> {
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

  // Fetch tasks from the API
  Future<void> fetchTasks() async {
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await dio.post(
        url_approval_data, 
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          tasks = List<Map<String, dynamic>>.from(response.data);
        });
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  Future<void> updateStatus(int applyId, bool isApproved) async {
    try {
      String? authToken = await getAuthToken();

      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final String url = isApproved ? url_acc_data : url_decline_data;

      final response = await dio.post(
          url,
          data: {'apply_id': applyId},
          options: Options(
            headers: {'Authorization': 'Bearer $authToken'},
          ),
        );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Application ${isApproved ? 'approved' : 'rejected'} successfully!')),
        );
        fetchTasks();
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      print('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update status')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Task Approval",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[900],
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final tugas = task['tugas'];
          final apply = task['apply'][0];

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: Icon(Icons.assignment, size: 50),
              title: Text(tugas != null && tugas['tugas_nama'] != null ? tugas['tugas_nama'] : 'Nama Tugas Tidak Ditemukan'),
              subtitle: Text(
                '${tugas != null && tugas['nama'] != null ? tugas['nama'] : 'Unknown user'} - '
                'Status: ${apply != null && apply['apply_status'] != null ? apply['apply_status'] : 'Pending'}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      updateStatus(apply['apply_id'], false); // Decline task (false)
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      updateStatus(apply['apply_id'], true); // Approve task (true)
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            // Navigate to Add Task page
          },
          child: Icon(
            Icons.add,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.indigo[900],
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to Home page
                },
              ),
              IconButton(
                icon: Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to Task Approval page
                },
              ),
              SizedBox(width: 50),
              IconButton(
                icon: Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to Notifications page
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to Profile page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
