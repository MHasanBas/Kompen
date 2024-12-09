import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'notification_detail_screen.dart';
import 'upload_proof_screen.dart';
import 'home_page.dart';
import 'ProfilePage.dart';
import 'print_letter_screen.dart';
import 'tasks_screen.dart';
import 'history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://sukakompen.kufoto.my.id', // Ganti dengan IP server Anda
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<List> fetchAcceptedNotifications(String token) async {
    try {
      final response = await _dio.post(
        '/api/notif_terima_apply',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['accepted'] ?? [];
    } catch (error) {
      throw Exception('Gagal memuat notifikasi apply diterima: $error');
    }
  }

  Future<List> fetchDeclinedNotifications(String token) async {
    try {
      final response = await _dio.post(
        '/api/notif_tolak_apply',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['declined'] ?? [];
    } catch (error) {
      throw Exception('Gagal memuat notifikasi apply ditolak: $error');
    }
  }

  Future<List> fetchAcceptNotifications(String token) async {
    try {
      final response = await _dio.post(
        '/api/notif_terima_tugas',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['accept'] ?? [];
    } catch (error) {
      throw Exception('Gagal memuat notifikasi tugas diterima: $error');
    }
  }

  Future<List> fetchDeclineNotifications(String token) async {
    try {
      final response = await _dio.post(
        '/api/notif_tolak_tugas',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['decline'] ?? [];
    } catch (error) {
      throw Exception('Gagal memuat notifikasi tugas ditolak: $error');
    }
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ApiService apiService = ApiService();
  List _acceptedNotifications = [];
  List _declinedNotifications = [];
  List _acceptNotifications = [];
  List _declineNotifications = [];
  bool _isLoading = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchNotifications();
  }

  Future<void> _loadTokenAndFetchNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      print('Token ditemukan: $_token');
      await _fetchNotifications();
    } catch (error) {
      print('Gagal memuat notifikasi: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchNotifications() async {
    try {
      final accepted = await apiService.fetchAcceptedNotifications(_token!);
      final declined = await apiService.fetchDeclinedNotifications(_token!);
      final accept = await apiService.fetchAcceptNotifications(_token!);
      final decline = await apiService.fetchDeclineNotifications(_token!);
      print('Data notifikasi diterima: $accepted');
      print('Data notifikasi ditolak: $declined');
      setState(() {
        _acceptedNotifications = accepted;
        _declinedNotifications = declined;
        _acceptNotifications = accept;
        _declineNotifications = decline;
        _isLoading = false;
      });
    } catch (error) {
      print('Gagal memuat notifikasi: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,
        title: Text(
          'Suka Kompen.',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w900,
              color: Color(0xFF191970), // Warna biru tua
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 90, // Tinggi AppBar
        elevation: 0, // Menghapus bayangan
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.grey[100],
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notifikasi",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        ..._acceptedNotifications.map((notification) {
                          String tugasNama =
                              _getTugasNama(notification['tugas']);
                          String pemberiTugas = _getPemberiTugas(
                              notification['tugas']['pemberi_tugas']);
                          return GestureDetector(
                            onTap: () {
                              String tugasId =
                                  notification['tugas']['tugas_id'].toString();
                              String applyId =
                                  notification['apply_id'].toString();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadProofScreen(
                                      tugasId: tugasId,
                                      applyId:
                                          applyId), // Pass both tugasId and progressId
                                ),
                              );
                            },
                            child: NotificationCard(
                              name: pemberiTugas,
                              message: "Permintaan tugas $tugasNama diterima.",
                              backgroundColor: Colors.white,
                            ),
                          );
                        }).toList(),
                        ..._declinedNotifications.map((notification) {
                          String tugasNama =
                              _getTugasNama(notification['tugas']);
                          String pemberiTugas = _getPemberiTugas(
                              notification['tugas']['pemberi_tugas']);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationDetailScreen(
                                    title:
                                        "Permintaan tugas $tugasNama ditolak",
                                    message: "Mohon cari pekerjaan lain",
                                  ),
                                ),
                              );
                            },
                            child: NotificationCard(
                              name: pemberiTugas, // Menggunakan nama pemberi tugas
                              message: "Permintaan tugas $tugasNama ditolak!",
                              backgroundColor: Colors.white,
                            ),
                          );
                        }).toList(),
                        ..._acceptNotifications.map((notification) {
                          String tugasNama =
                              _getTugasNama(notification['tugas']);
                          String pemberiTugas = _getPemberiTugas(
                              notification['tugas']['pemberi_tugas']);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrintLetterScreen(),
                                ),
                              );
                            },
                            child: NotificationCard(
                              name: pemberiTugas,
                              message: "Tugas $tugasNama diterima oleh $pemberiTugas.",
                              backgroundColor: Colors.green[200],
                            ),
                          );
                        }).toList(),
                        ..._declineNotifications.map((notification) {
                          String tugasNama =
                              _getTugasNama(notification['tugas']);
                          String pemberiTugas = _getPemberiTugas(
                              notification['tugas']['pemberi_tugas']);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationDetailScreen(
                                    title: "Tugas $tugasNama ditolak",
                                    message: "Tugas kurang sesuai",
                                  ),
                                ),
                              );
                            },
                            child: NotificationCard(
                              name: pemberiTugas, 
                              message: "Pengumpulan tugas $tugasNama ditolak!",
                              backgroundColor: Colors.white,
                            ),
                          );
                        }).toList()
                      ],
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Fungsi untuk mendapatkan nama tugas
  String _getTugasNama(Map<String, dynamic> tugas) {
    return tugas['tugas_nama'] ?? "Tugas tidak tersedia";
  }

  // Fungsi untuk mendapatkan nama pemberi tugas
  String _getPemberiTugas(Map<String, dynamic>? pemberiTugas) {
    if (pemberiTugas == null) {
      return "Pemberi tugas tidak tersedia";
    }
    return pemberiTugas['dosen_nama'] ??
        pemberiTugas['admin_nama'] ??
        pemberiTugas['tendik_nama'] ??
        "Pemberi tugas tidak tersedia";
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.access_time, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
            ),
            SizedBox(width: 50),
            IconButton(
              icon: Icon(Icons.mail, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TasksScreen()),
          );
        },
        child: Icon(
          Icons.add,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String name;
  final String message;
  final Color? backgroundColor;

  NotificationCard({
    required this.name,
    required this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[300],
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
