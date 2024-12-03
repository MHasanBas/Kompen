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

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.236.129:8000', // Ganti dengan IP server Anda
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
        title: Text(
          'Suka Kompen.',
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF191970),
          ),
        ),
        backgroundColor: Colors.white,
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
        color: Colors.indigo[900],
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.access_time, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()),
                  );
                },
              ),
              SizedBox(width: 40),
              IconButton(
                icon: Icon(Icons.mail, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 20),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TasksScreen()),
          );
        },
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
