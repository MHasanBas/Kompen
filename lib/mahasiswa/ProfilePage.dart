import 'package:flutter/material.dart';
import 'history_screen.dart';
import 'tasks_screen.dart';
import 'notification_screen.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../about_page.dart';
import 'package:kompen/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Loading...";
  String userNim = "Loading...";
  String userSemester = "Loading...";
  String userProdi = "Loading...";
  String userImageUrl = "https://via.placeholder.com/150";

  final Dio _dio = Dio();

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchProfileData() async {
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) throw Exception('Token tidak ditemukan');

      final response = await _dio.post(
        'https://kompen.kufoto.my.id/api/profilemhs',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        setState(() {
          if (data != null && data['data'] != null) {
            var mahasiswaData = data['data'];
            userName = mahasiswaData['mahasiswa_nama'] ?? "Nama tidak tersedia";
            userNim = mahasiswaData['nim'] ?? "NIM tidak tersedia";
            userSemester =
                "Semester ${mahasiswaData['semester']?.toString() ?? "tidak tersedia"}";
            userProdi = mahasiswaData['prodi_id']?.toString() ?? "Prodi Tidak Tersedia";
            userImageUrl =
                data['image_url'] ?? "https://via.placeholder.com/150";
          }
        });
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      setState(() {
        userName = "Error: $e";
        userNim = "Error: $e";
        userSemester = "Error: $e";
        userProdi = "Error: $e";
      });
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
        title: const Text(
          'Suka Kompen',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF191970)),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF191970)),
            tooltip: 'Tentang Pengembang',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage())),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: const Color(0xFF001C72), borderRadius: BorderRadius.circular(12.0)),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(userImageUrl),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    userNim,
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
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
                  _buildInfoRow(userNim),
                  _buildSeparator(),
                  _buildInfoRow(userSemester),
                  _buildSeparator(),
                  _buildInfoRow(userProdi),
                  _buildSeparator(),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ],
        ),
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
              _buildNavBarIcon(Icons.home, const HomePage()),
              _buildNavBarIcon(Icons.access_time,  HistoryScreen()),
              const SizedBox(width: 50), // Ruang untuk FAB
              _buildNavBarIcon(Icons.mail,  NotificationScreen()),
              _buildNavBarIcon(Icons.person, const ProfilePage()),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  TasksScreen())),
          child: const Icon(Icons.add, size: 50, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavBarIcon(IconData icon, Widget page) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 30),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
    );
  }

  Widget _buildInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSeparator() {
    return const Divider(color: Colors.grey, height: 1, thickness: 0.5, indent: 16, endIndent: 16);
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF001C72),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () async {
                            // Hapus token otentikasi
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.remove('auth_token'); // Menghapus token
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text('YA'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Menutup modal
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
        child: Text("LogOut", style: TextStyle(color: Colors.red, fontSize: 18.0, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
