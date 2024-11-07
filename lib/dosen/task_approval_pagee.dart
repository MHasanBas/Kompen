// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: TaskApprovalPage(),
//     );
//   }
// }

// class TaskApprovalPage extends StatelessWidget {
//   final List<Map<String, String>> tasks = [
//     {"name": "Faiz Abiyu", "task": "Membuat PPT", "status": "Online"},
//     {"name": "Fahmi Mardiansyah", "task": "Membuat PPT", "status": "Online"},
//     {"name": "Hasan Basri", "task": "Membuat PPT", "status": "Online"},
//     {"name": "Naswya Syafinka", "task": "Membuat PPT", "status": "Online"},
//   ];

//   void _rejectTask(int index) {
//     // Logika untuk menolak tugas
//     // Misalnya, menghapus dari daftar atau memperbarui status
//     print('Tugas ditolak: ${tasks[index]['task']} oleh ${tasks[index]['name']}');
//   }

//   void _approveTask(int index) {
//     // Logika untuk menyetujui tugas
//     // Misalnya, menghapus dari daftar atau memperbarui status
//     print('Tugas disetujui: ${tasks[index]['task']} oleh ${tasks[index]['name']}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Suka Kompen."),
//       ),
//       body: ListView.builder(
//         itemCount: tasks.length,
//         itemBuilder: (context, index) {
//           final task = tasks[index];
//           return Card(
//             margin: EdgeInsets.all(10),
//             child: ListTile(
//               contentPadding: EdgeInsets.all(10),
//               leading: Image.asset('assets/task_image.png', width: 50, height: 50),
//               title: Text(task['task']!),
//               subtitle: Text('${task['name']} - ${task['status']}'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.close, color: Colors.red),
//                     onPressed: () {
//                       _rejectTask(index);
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.check, color: Colors.green),
//                     onPressed: () {
//                       _approveTask(index);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         width: 90,
//         height: 90,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.blueAccent,
//         ),
//         child: FloatingActionButton(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AddTaskPage()), // Ganti dengan halaman yang sesuai
//             );
//           },
//           child: Icon(
//             Icons.add,
//             size: 50,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         notchMargin: 8,
//         color: Colors.indigo[900],
//         child: Container(
//           height: 70,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.home, color: Colors.white, size: 30),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomePage()), // Ganti dengan halaman yang sesuai
//                   );
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.access_time, color: Colors.white, size: 30),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => HistoryScreen()), // Ganti dengan halaman yang sesuai
//                   );
//                 },
//               ),
//               SizedBox(width: 50), // Ruang kosong untuk tombol mengapung
//               IconButton(
//                 icon: Icon(Icons.mail, color: Colors.white, size: 30),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => NotificationScreen()), // Ganti dengan halaman yang sesuai
//                   );
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.person, color: Colors.white, size: 30),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ProfilePage()), // Ganti dengan halaman yang sesuai
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Pastikan Anda memiliki kelas AddTaskPage, HomePage, HistoryScreen, NotificationScreen, dan ProfilePage di file yang sama atau di file terpisah.
