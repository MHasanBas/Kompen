// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'Profile_Page.dart'; // Impor ProfilePage
// import 'kompen_card.dart';
// import 'notifikasi.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'Suka Kompen.',
//           style: GoogleFonts.poppins(
//             textStyle: const TextStyle(
//               fontSize: 24.0,
//               fontWeight: FontWeight.w900,
//               color: Color(0xFF191970), // Dark Blue Color
//             ),
//           ),
//         ),
//         toolbarHeight: 89.0,
//         automaticallyImplyLeading: false, // Remove back button
//       ),

//       // Mengubah warna background Scaffold menjadi #F9F9F9
//       backgroundColor: const Color(0xFFF9F9F9),

//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // User Profile Card
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF001C72), // Dark Blue Color from Figma
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               child: Row(
//                 children: [
//                   // Profile Icon
//                   const CircleAvatar(
//                     radius: 30.0,
//                     backgroundColor: Colors.white,
//                     child: Icon(
//                       Icons.person, // Placeholder icon for profile
//                       size: 40.0,
//                       color: Color(0xFF001C72), // Match icon color to the card
//                     ),
//                   ),
//                   const SizedBox(width: 16.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Hasan", // User name from the Figma
//                         style: GoogleFonts.poppins(
//                           textStyle: const TextStyle(
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Text(
//                         "2241760069", // NIM
//                         style: GoogleFonts.poppins(
//                           textStyle: const TextStyle(
//                             fontSize: 16.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   // Button "Yuk Kompen" doesn't navigate anymore
//                   ElevatedButton(
//                     onPressed: () {
//                       // Action can be left empty or define another action
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 10.0),
//                     ),
//                     child: const Text(
//                       "Yuk Kompen!",
//                       style: TextStyle(
//                         color: Color(0xFF001C72), // Dark Blue Color
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Akumulasi Kompen Section now navigates to AkumulasiPage
//             GestureDetector(
//               onTap: () {
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF9F9F9), // Updated background color
//                   borderRadius: BorderRadius.circular(12.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       blurRadius: 10.0,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.access_time, // Clock Icon
//                           color: Color(0xFF191970),
//                           size: 30.0,
//                         ),
//                         SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "1000 Jam",
//                               style: TextStyle(
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF191970), // Text color
//                               ),
//                             ),
//                             Text(
//                               "Alpha",
//                               style: TextStyle(
//                                 color: Color(0xFF191970),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Column(
//                           children: [
//                             Text(
//                               "+2 Jam",
//                               style: TextStyle(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 4), // Added space
//                             Text(
//                               "Alpha",
//                               style: TextStyle(
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(width: 10),
//                         Column(
//                           children: [
//                             Text(
//                               "-5 Jam",
//                               style: TextStyle(
//                                 color: Colors.red,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 4), // Added space
//                             Text(
//                               "Alpha",
//                               style: TextStyle(
//                                 color: Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Rekomendasi Kompen Section
//             Text(
//               "Rekomendasi Kompen",
//               style: GoogleFonts.poppins(
//                 textStyle: const TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF191970), // Dark Blue Color
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Kompen Cards with task description
//             const KompenCard(
//               title: "Arsip Absensi",
//               hours: "-14 Jam",
//               description: "Menunjukkan status absensi dan jam kehadiran.",
//               icon: Icons.archive, // Ikon untuk arsip absensi
//             ),

//             const KompenCard(
//               title: "Rekap Nilai",
//               hours: "-10 Jam",
//               description: "Melihat rekap hasil penilaian dari setiap tugas.",
//               icon: Icons.assessment, // Ikon untuk rekap nilai
//             ),
//           ],
//         ),
//       ),

//       // Bottom navigation bar
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 5,
//         color: Colors.indigo[900], // Dark blue bottom bar
//         child: SizedBox(
//           height: 70,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.home, color: Colors.white, size: 30),
//                 onPressed: () {
//                   // Stay on HomePage
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.access_time,
//                     color: Colors.white, size: 30),
//                 onPressed: () {
//                   // Navigate to time page
//                 },
//               ),
//               const SizedBox(width: 50), // Space for the FAB
//               IconButton(
//                 icon: const Icon(Icons.mail, color: Colors.white, size: 30),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             NotifikasiPage()), //page cek tugas
//                   );
//                 },
//               ),

//               IconButton(
//                 icon: const Icon(Icons.person, color: Colors.white, size: 30),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const ProfilePage()),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),

//       // Floating action button
//       floatingActionButton: Container(
//         width: 90, // Bigger size for the FAB
//         height: 90,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.blueAccent, // Bright blue color
//         ),
//         child: FloatingActionButton(
//           elevation: 0, // No shadow
//           backgroundColor: Colors.transparent, // Transparent to avoid stacking
//           onPressed: () {
//             // Action when FAB is pressed
//           },
//           child: const Icon(
//             Icons.add,
//             size: 50, // Larger "+" icon
//             color: Colors.white, // White color for contrast
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }
