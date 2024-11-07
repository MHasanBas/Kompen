import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notifikasi.dart'; //import file cek_tugas

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Card with full width
            Container(
              width: double.infinity, // Set to full width
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF001C72),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 100.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 130.0,
                      color: Color(0xFF001C72),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Hasan",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "2241760069",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Info Section with Logout Button
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  _buildInfoRow("Septian Enggar"),
                  _buildSeparator(),
                  _buildInfoRow("19297323687"),
                  _buildSeparator(),
                  _buildInfoRow("Teknologi Informasi"),
                  _buildSeparator(),
                  _buildInfoRow("085876345109",
                      trailing: const Icon(Icons.edit)),
                  _buildSeparator(),
                  // Logout Button
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Anda yakin ingin log out?',
                                    style: TextStyle(fontSize: 18.0),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF001C72),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushReplacementNamed('/login');
                                        },
                                        child: const Text('YA'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Tidak'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "LogOut",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      // Bottom navbar
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
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.access_time,
                    color: Colors.white, size: 30),
                onPressed: () {},
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotifikasiPage()), //page cek tugas
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {},
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
          onPressed: () {},
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

  Widget _buildInfoRow(String text, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 16.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return const Divider(
      color: Colors.grey,
      height: 1,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    );
  }
}
