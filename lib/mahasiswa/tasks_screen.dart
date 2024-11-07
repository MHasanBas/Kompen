import 'package:flutter/material.dart';
import 'task_detail_screen.dart';

class TasksScreen extends StatelessWidget {
  final List<Map<String, String>> tasks = const [
    {
      "title": "Membuat PPT",
      "description": "Membuat Presentasi (PPT) untuk mata kuliah.",
    },
    {
      "title": "Rekap Nilai",
      "description": "Merekap nilai mahasiswa.",
    },
    {
      "title": "Arsip Absensi",
      "description": "Mengarsip kertas absensi semua kelas.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tugas"),
        centerTitle: true, // Center title for better aesthetics
      ),
      body: Container(
        color: Colors.grey[100], // Light grey background for contrast
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4, // Add elevation for shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16), // Add padding for ListTile
                title: Text(
                  tasks[index]["title"]!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  tasks[index]["description"]!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700], // Slightly darker grey for description
                  ),
                ),
                leading: Icon(
                  Icons.task, // Add an icon for visual appeal
                  size: 40,
                  color: Colors.blueAccent, // Custom color for the icon
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailScreen(
                        title: tasks[index]["title"]!,
                        description: tasks[index]["description"]!,
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
