import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cetak/cetaksurat.dart';
import 'notification_screen.dart';
import 'tasks_screen.dart';
import 'home_page.dart';
import 'ProfilePage.dart';
import 'package:intl/intl.dart';
import '../about_page.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://kompen.kufoto.my.id', 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<List> FetchHistory(String token) async {
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
}

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService apiService = ApiService();
  List _history = [];
  bool _isLoading = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      await _fetchHistory();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchHistory() async {
    try {
      final history = await apiService.FetchHistory(_token!);
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getTugasNama(Map<String, dynamic> tugas) {
    return tugas['tugas_nama'] ?? "Tugas tidak tersedia";
  }

  String _getPemberiTugas(Map<String, dynamic>? pemberiTugas) {
    if (pemberiTugas == null) {
      return "Pemberi tugas tidak tersedia";
    }
    return pemberiTugas['dosen_nama'] ??
        pemberiTugas['admin_nama'] ??
        pemberiTugas['tendik_nama'] ??
        "Pemberi tugas tidak tersedia";
  }

  String _formatDate(String dateTime) {
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return 'Tanggal tidak valid';
    }
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
    
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final history = _history[index];
                  String tugasNama = _getTugasNama(history['tugas']);
                  String pemberiTugas =
                      _getPemberiTugas(history['tugas']['pemberi_tugas']);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 5.0),
                    child: Card(
                      color: Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CetakScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    tugasNama,
                                    style: GoogleFonts.exo(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$pemberiTugas',
                                        style: GoogleFonts.roboto(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${history['tugas']['tugas_deskripsi']}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    '${history['tugas']['tugas_tipe']} | ${_formatDate(history['tugas']['tugas_tenggat'])}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 8.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        color: Colors.indigo[900], // Dark blue bottom bar
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
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage()), // Sesuaikan dengan nama kelas yang benar
                  );
                },
              ),

              IconButton(
                icon: Icon(Icons.access_time,
                    color: Colors.white,
                    size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  // Arahkan ke halaman Histori
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HistoryScreen()), // Sesuaikan dengan nama kelas yang benar
                  );
                },
              ),
              SizedBox(width: 50), // Beri ruang lebih untuk tombol +
              IconButton(
                icon: Icon(Icons.mail,
                    color: Colors.white,
                    size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotificationScreen()), // Sesuaikan dengan nama kelas 'NotificationScreen'
                  );
                },
              ),

              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage()), // Sesuaikan dengan nama kelas yang benar
                  );

                  // Navigate to profile page
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
          backgroundColor: Colors
              .transparent, // Jadikan background transparan agar tidak bertumpuk
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
}