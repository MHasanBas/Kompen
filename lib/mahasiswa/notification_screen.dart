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

  Future<List> fetchAcceptedNotifications(String token) async {
    try {
      final response = await _dio.post(
        'https://kompen.kufoto.my.id/api/notif_terima_apply',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['accepted'] ?? [];
      } else {
        print('API Error: ${response.statusCode} - ${response.statusMessage}');
        return [];
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('Endpoint tidak ditemukan: ${e.response?.statusCode}');
      } else {
        print('DioException: $e');
      }
      return [];
    } catch (error) {
      throw Exception('Gagal memuat notifikasi apply diterima: $error');
    }
  }

  Future<List> fetchDeclinedNotifications(String token) async {
    final dio = Dio();
    final options = Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    try {
      final response = await dio.post(
        'https://kompen.kufoto.my.id/api/notif_tolak_apply',
        options: options,
      );
      
      if (response.statusCode == 200) {
        var declinedNotifications = response.data['declined'] ?? [];
        print('Declined Notifications: $declinedNotifications');
        return declinedNotifications;
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List> fetchAcceptNotifications(String token) async {
    try {
      final response = await _dio.post(
        'https://kompen.kufoto.my.id/api/notif_terima_tugas',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['accept'] ?? [];
    } catch (error) {
      throw Exception('Gagal memuat notifikasi tugas diterima: $error');
    }
  }

  Future<List> fetchDeclineNotifications(String token) async {
    final dio = Dio();
    final options = Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    try {
      final response = await dio.post(
        'https://kompen.kufoto.my.id/api/notif_tolak_tugas',
        options: options,
      );
      
      if (response.statusCode == 200) {
        var declineNotifications = response.data['decline'] ?? [];
        print('Decline Notifications: $declineNotifications');
        return declineNotifications;
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ApiService apiService = ApiService();
  List _originalAcceptedNotifications = [];
  List _originalDeclinedNotifications = [];
  List _originalAcceptNotifications = [];
  List _originalDeclineNotifications = [];
  
  List _filteredAcceptedNotifications = [];
  List _filteredDeclinedNotifications = [];
  List _filteredAcceptNotifications = [];
  List _filteredDeclineNotifications = [];
  
  bool _isLoading = true;
  
  // Filter options
  List<String> _filterOptions = [
    'Semua Notifikasi',
    'Permintaan Diterima',
    'Permintaan Ditolak',
    'Tugas Diterima',
    'Tugas Ditolak'
  ];
  String _selectedFilter = 'Semua Notifikasi';

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      String? authToken = await getAuthToken();

      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final accepted = await apiService.fetchAcceptedNotifications(authToken);
      final declined = await apiService.fetchDeclinedNotifications(authToken);
      final accept = await apiService.fetchAcceptNotifications(authToken);
      final decline = await apiService.fetchDeclineNotifications(authToken);
      
      setState(() {
        _originalAcceptedNotifications = accepted;
        _originalDeclinedNotifications = declined;
        _originalAcceptNotifications = accept;
        _originalDeclineNotifications = decline;
        
        _filteredAcceptedNotifications = accepted;
        _filteredDeclinedNotifications = declined;
        _filteredAcceptNotifications = accept;
        _filteredDeclineNotifications = decline;
        
        _isLoading = false;
      });
      
      _applyFilter(_selectedFilter);
    } catch (error) {
      print('Gagal memuat notifikasi: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      
      switch (filter) {
        case 'Semua Notifikasi':
          _filteredAcceptedNotifications = _originalAcceptedNotifications;
          _filteredDeclinedNotifications = _originalDeclinedNotifications;
          _filteredAcceptNotifications = _originalAcceptNotifications;
          _filteredDeclineNotifications = _originalDeclineNotifications;
          break;
        case 'Permintaan Diterima':
          _filteredAcceptedNotifications = _originalAcceptedNotifications;
          _filteredDeclinedNotifications = [];
          _filteredAcceptNotifications = [];
          _filteredDeclineNotifications = [];
          break;
        case 'Permintaan Ditolak':
          _filteredAcceptedNotifications = [];
          _filteredDeclinedNotifications = _originalDeclinedNotifications;
          _filteredAcceptNotifications = [];
          _filteredDeclineNotifications = [];
          break;
        case 'Tugas Diterima':
          _filteredAcceptedNotifications = [];
          _filteredDeclinedNotifications = [];
          _filteredAcceptNotifications = _originalAcceptNotifications;
          _filteredDeclineNotifications = [];
          break;
        case 'Tugas Ditolak':
          _filteredAcceptedNotifications = [];
          _filteredDeclinedNotifications = [];
          _filteredAcceptNotifications = [];
          _filteredDeclineNotifications = _originalDeclineNotifications;
          break;
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _filterOptions.map((filter) {
              return ListTile(
                title: Text(filter),
                trailing: _selectedFilter == filter 
                  ? Icon(Icons.check, color: Colors.green) 
                  : null,
                onTap: () {
                  _applyFilter(filter);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Suka Kompen.",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.indigo[900],
                  fontSize: 24,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.grey),
              onPressed: _showFilterBottomSheet,
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.grey[100],
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notifikasi",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _selectedFilter,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        ..._buildNotificationWidgets(),
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

  List<Widget> _buildNotificationWidgets() {
    List<Widget> notifications = [];

    notifications.addAll(_filteredAcceptedNotifications.map((notification) {
      String tugasNama = _getTugasNama(notification['tugas']);
      String pemberiTugas = _getPemberiTugas(notification['tugas']['pemberi_tugas']);
      return GestureDetector(
        onTap: () {
          String tugasId = notification['tugas']['tugas_id'].toString();
          String applyID = notification['apply_id'].toString();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadProofScreen(
                tugasId: tugasId,
                applyID: applyID,
              ),
            ),
          );
        },
        child: NotificationCard(
          name: pemberiTugas,
          message: "Permintaan tugas $tugasNama diterima.",
          backgroundColor: Colors.white,
        ),
      );
    }).toList());

    notifications.addAll(_filteredDeclinedNotifications.map((notification) {
      String tugasNama = _getTugasNama(notification['tugas']);
      String pemberiTugas = _getPemberiTugas(notification['tugas']['pemberi_tugas']);
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationDetailScreen(
                title: "Permintaan tugas $tugasNama ditolak",
                message: "Mohon cari pekerjaan lain",
              ),
            ),
          );
        },
        child: NotificationCard(
          name: pemberiTugas,
          message: "Permintaan tugas $tugasNama ditolak!",
          backgroundColor: Colors.red[100],
        ),
      );
    }).toList());

    notifications.addAll(_filteredAcceptNotifications.map((notification) {
      String tugasNama = _getTugasNama(notification['tugas']);
      String pemberiTugas = _getPemberiTugas(notification['tugas']['pemberi_tugas']);
      int approvalId = notification['approval_id'];
      return GestureDetector(
      onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PrintLetterScreen(approvalId: approvalId),
    ),
  );
},

        child: NotificationCard(
          name: pemberiTugas,
          message: "Tugas $tugasNama diterima oleh $pemberiTugas.",
          backgroundColor: Colors.green[200],
        ),
      );
    }).toList());

    notifications.addAll(_filteredDeclineNotifications.map((notification) {
      String tugasNama = _getTugasNama(notification['tugas']);
      String pemberiTugas = _getPemberiTugas(notification['tugas']['pemberi_tugas']);
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationDetailScreen(
                title: "Tugas $tugasNama ditolak",
                message: "Tugas kurang sesuai",
              ),
            ),
          );
        },
        child: NotificationCard(
          name: pemberiTugas,
          message: "Pengumpulan tugas $tugasNama ditolak!",
          backgroundColor: Colors.red[200],
        ),
      );
    }).toList());

    // If no notifications found
    if (notifications.isEmpty) {
      notifications.add(
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Text(
            'Tidak ada notifikasi untuk filter ini',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return notifications;
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
