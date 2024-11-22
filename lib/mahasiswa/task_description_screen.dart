// import 'package:flutter/material.dart';

// class TaskDescriptionScreen extends StatelessWidget {
//   final String title;
//   final String description;

//   TaskDescriptionScreen({required this.title, required this.description});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Suka Kompen."),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Card Section
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Column(
//                         children: [
//                           Text(
//                             title,
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             "Offline",
//                             style: TextStyle(color: Colors.red),
//                           ),
//                           SizedBox(height: 8),
//                           Image.asset(
//                             'assets/images/task_image.png',
//                             width: 100,
//                             height: 100,
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             "By Bu Titis",
//                             style: TextStyle(fontStyle: FontStyle.italic),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             description,
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Divider(),
//                     ListTile(
//                       leading: Icon(Icons.access_time, color: Colors.grey),
//                       title: Text("16:00 PM"),
//                       subtitle: Text("9/14/2025"),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.arrow_downward, color: Colors.red),
//                           SizedBox(width: 4),
//                           Text("- 4 Jam"),
//                           Text(" Alpha", style: TextStyle(color: Colors.red)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),

//             // Request Button Section
//             ElevatedButton(
//               onPressed: () {
//                 // Aksi untuk request pekerjaan
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
//                 backgroundColor: Colors.yellow.shade700,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 "Request Pekerjaan",
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         notchMargin: 8,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.home),
//                 onPressed: () {
//                   // Aksi untuk navigasi ke Home
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.access_time),
//                 onPressed: () {
//                   // Aksi untuk navigasi ke halaman riwayat
//                 },
//               ),
//               SizedBox(width: 48), // Spacing for FAB
//               IconButton(
//                 icon: Icon(Icons.mail),
//                 onPressed: () {
//                   // Aksi untuk navigasi ke halaman pesan
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.account_circle),
//                 onPressed: () {
//                   // Aksi untuk navigasi ke halaman profil
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Aksi untuk tambah tugas baru
//         },
//         child: Icon(Icons.add),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }
