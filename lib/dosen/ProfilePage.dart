import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kompen/dosen/add_task_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dashboard.dart';
import 'task_approval_page.dart';
import 'notifikasi.dart';
import 'package:kompen/login_page.dart';
import '../about_page.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  _ProfilescreenState createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  String userName = "Loading...";
  String userNidn = "Loading...";
  String userPhone = "Loading...";
  String userEmail = "Loading...";
  String userImageUrl = "Loading...";
  final Dio _dio = Dio();

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchProfileData() async {
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await _dio.post(
        'https://kompen.kufoto.my.id/api/profiledsn', // Ganti dengan endpoint API Anda
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          // Adjusting the fields based on your controller's response format
          if (data != null && data['data'] != null) {
            var dosenData = data['data'];
            userName = dosenData['dosen_nama'] ?? "Nama tidak tersedia";
            userNidn = dosenData['nidn'] ?? "NIDN tidak tersedia";
            userPhone = dosenData['dosen_no_telp'] ?? "Telepon tidak tersedia";
            userEmail = dosenData['dosen_email'] ?? "Email tidak tersedia";
          }
          userImageUrl = data['image_url'] ?? "Default image URL";
        });
      } else {
        setState(() {
          userName = "Gagal memuat data";
          userNidn = "Gagal memuat data";
          userPhone = "Gagal memuat data";
          userEmail = "Gagal memuat data";
        });
      }
    } catch (e) {
      setState(() {
        userName = "Error: $e";
        userNidn = "Error: $e";
        userPhone = "Error: $e";
        userEmail = "Error: $e";
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfileData();
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
            Icons.info_outline, // Info icon for developer info
            color: Color(0xFF191970), // Dark blue icon color
            size: 30, // Adjust icon size for better visibility
          ),
          onPressed: () {
            // Navigate to the About Page when the icon is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          },
          tooltip: 'Info Pengembang', // Tooltip text on hover
        ),
      ],
    ),
    backgroundColor: const Color(0xFFF9F9F9), // Background color for the body
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF001C72),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60.0, // Adjusted to a smaller size
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(userImageUrl), // Replace with user image URL
                ),
                
              

                  const SizedBox(height: 16.0),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    userNidn,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  _buildInfoRow(userName),
                  _buildSeparator(),
                  _buildInfoRow(userNidn),
                  _buildSeparator(),
                  _buildInfoRow(userPhone),
                  _buildSeparator(),
                  _buildInfoRow(userEmail),
                  _buildSeparator(),
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
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          // Hapus token otentikasi
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          await prefs.remove(
                                              'auth_token'); // Menghapus token
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage()),
                                          );
                                        },
                                        child: const Text('YA'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Menutup modal
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
      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        color: const Color(0xFF191970),
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
                    MaterialPageRoute(builder: (context) =>  HomeScreen()),
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
      thickness: 1,
    );
  }
}