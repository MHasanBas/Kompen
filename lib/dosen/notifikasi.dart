import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kompen/dosen/ProfilePage.dart';
import 'package:kompen/dosen/dashboard.dart';
import 'package:kompen/dosen/task_approval_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Cek_Tugas.dart';
import 'add_task_page.dart';
import 'package:dio/dio.dart';
import '../about_page.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  _NotifikasiPageState createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  List<dynamic> tugasList = []; // List untuk menampung data tugas
  bool isLoading = true; // State untuk loading

  // Fungsi untuk mengambil token autentikasi
  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Fungsi untuk mengambil notifikasi tugas dari API
 Future<void> fetchNotifications() async {
  try {
    String? authToken = await getAuthToken();
    if (authToken == null) {
      throw Exception('Token tidak ditemukan');
    }

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $authToken';

    final response = await dio.post(
      'https://kompen.kufoto.my.id/api/cek_tugas',
    );

    if (response.statusCode == 200 && response.data != null) {
      print("Response Data: ${response.data}"); // Debug respons dari API
      setState(() {
        // Mengubah data menjadi List agar bisa di-loop
        tugasList = response.data.entries.map((entry) {
          return entry.value; // Ambil nilai dari setiap key numerik
        }).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    print('Error: $e');
  }
}


  @override
  void initState() {
    super.initState();
    fetchNotifications();
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cek Tugas',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          // Additional content goes here
        
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : tugasList.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'Belum ada yang mengumpulkan tugas',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: tugasList.length,
                          itemBuilder: (context, index) {
                            var tugasItem = tugasList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          'assets/images/task.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tugasItem['tugas']
                                                      ['tugas_nama'] ??
                                                  'Nama Tugas Tidak Ditemukan',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${tugasItem['tugas']['tugas_deskripsi'] ?? 'No Description'}',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                        ),
                                        onPressed: () {
                                          var approvalId = tugasItem['approval']
                                              [0]['approval_id'];
                                          var progressId = tugasItem['approval']
                                              [0]['progress_id'];
                                          var tugasId =
                                              tugasItem['tugas']['tugas_id'];

                                          print(
                                              'Navigating to tugasId: $tugasId');

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CekTugasPage(
                                                      tugasId: tugasId,
                                                      approvalId: approvalId,
                                                      progressId: progressId),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Cek Tugas',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
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
                    MaterialPageRoute(builder: (context) => HomeScreen()),
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
}
