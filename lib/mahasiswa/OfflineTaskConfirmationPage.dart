// import 'package:flutter/material.dart';

// class OfflineTaskConfirmationPage extends StatelessWidget {
//   final String title;
//   final String description;

//   OfflineTaskConfirmationPage({required this.title, required this.description});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Suka Kompen.'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16.0),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           title, // Judul tugas
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Spacer(),
//                         Text(
//                           'Offline',
//                           style: TextStyle(
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Center(
//                       child: Image.asset(
//                         'assets/offline_image.png', // Ganti dengan path gambar yang sesuai
//                         height: 150,
//                         width: 150,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'By Bu Titis',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       description, // Deskripsi tugas
//                       style: TextStyle(fontSize: 14, color: Colors.black54),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.access_time),
//                     SizedBox(width: 8),
//                     Text(
//                       '16:00 PM',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       '9/14/2025',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.arrow_downward, color: Colors.red),
//                     SizedBox(width: 8),
//                     Text(
//                       '- 4 Jam',
//                       style: TextStyle(fontSize: 16, color: Colors.red),
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       'Alpha',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Fungsi saat tombol di-klik, misalnya konfirmasi
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Tugas offline berhasil dikonfirmasi!")),
//                   );
//                   Navigator.pop(context); // Kembali ke halaman sebelumnya
//                 },
//                 child: Text('Konfirmasi Tugas Offline'),
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.lightBlue,
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   textStyle: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.access_time),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_circle_outline),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.mail),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: '',
//           ),
//         ],
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.black54,
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//       ),
//     );
//   }
// }
