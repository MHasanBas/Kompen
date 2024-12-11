import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'history_screen.dart';
import 'tasks_screen.dart';
import 'notification_screen.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../about_page.dart';


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
  String userPhone = "Loading...";

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  final Dio _dio = Dio();

  Future<void> fetchProfileData() async {
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await _dio.post(
        'https://sukakompen.kufoto.my.id/api/profilemhs', // Ganti dengan endpoint API Anda
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          userName = data['mahasiswa_nama'] ?? "Nama tidak tersedia";
          userNim = data['nim'] ?? "NIM tidak tersedia";
          userSemester = "Semester ${data['semester']?.toString() ?? "tidak tersedia"}";
          userProdi = data['prodi'] ?? "Prodi Tidak Tersedia";
        });
      } else {
        setState(() {
          userName = "Failed to load data";
          userNim = "Failed to load data";
          userSemester = "Failed to load data";
          userProdi = "Failed to load data";
        });
      }
    } catch (e) {
      setState(() {
        userName = "Error: $e";
        userNim = "Error: $e";
        userSemester = "Error: $e";
        userProdi = "Error: $e";
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
        title: const Text(
          'Suka Kompen',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF191970), // Warna biru tua
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline, // Icon info
              color: Color(0xFF191970), // Warna icon
            ),
            tooltip: 'Tentang Pengembang', // Tooltip pada icon
            onPressed: () {
              // Navigasi ke AboutPage saat ikon ditekan
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Card with full width
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF001C72),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 100.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 130.0,
                      color: Color(0xFF001C72),
                    ),
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
                    userNim,
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
                  _buildInfoRow(userName),
                  _buildSeparator(),
                  _buildInfoRow(userNim),
                  _buildSeparator(),
                  _buildInfoRow(userSemester),
                  _buildSeparator(),
                  _buildInfoRow(userProdi),
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
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.indigo[900], // Ubah warna bottom bar menjadi biru tua
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
             IconButton(
  icon: Icon(Icons.home, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // Sesuaikan dengan nama kelas 'HomePage'
    );
  },
),

              IconButton(
                icon: Icon(Icons.access_time, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  // Arahkan ke halaman Histori
              Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => HistoryScreen()), // Sesuaikan dengan nama kelas yang benar
);

                },
              ),
              SizedBox(width: 50), // Beri ruang lebih untuk tombol +
              IconButton(
  icon: Icon(Icons.mail, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationScreen()), // Sesuaikan dengan nama kelas 'NotificationScreen'
    );
  },
),

              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  // Aksi ke halaman profil
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 90, // Ukuran lingkaran FAB lebih besar
        height: 90, // Tinggi lingkaran FAB lebih besar
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Bentuk lingkaran penuh
          color: Colors.blueAccent, // Warna biru lebih cerah
        ),
        child: FloatingActionButton(
          elevation: 0, // Hapus elevation agar rata dengan lingkaran
          backgroundColor: Colors.transparent, // Jadikan background transparan agar tidak bertumpuk
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TasksScreen()),
            );
          },
          child: Icon(
            Icons.add, 
            size: 50, // Ukuran icon + lebih besar dari icon biasa
            color: Colors.white, // Warna putih agar kontras
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