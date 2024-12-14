import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:kompen/mahasiswa/qr_code_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../about_page.dart';
import 'akumulasi_page.dart';
import 'kompen_card.dart';
import 'history_screen.dart';
import 'tasks_screen.dart';
import 'notification_screen.dart';
import 'ProfilePage.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "Loading...";
  String userNim = "Loading...";
  String userTotal = "Loading...";
  List<dynamic> tugas = [];

  final Dio _dio = Dio();

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchData() async {
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await _dio.post(
        'https://kompen.kufoto.my.id/api/dashboardmhs',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

if (response.statusCode == 200) {
  final data = response.data;
  print('Data: $data'); // Inspect the entire response structure
  print('Tugas: ${data['tugas']}'); // Inspect just the 'tugas' field
  
  setState(() {
    userName = data['mahasiswa']['mahasiswa_nama'];
    userNim = data['mahasiswa']['nim'];
    userTotal = data['mahasiswa']['jumlah_alpa'].toString();
    
    if (data['tugas'] is List) {
      tugas = List.from(data['tugas']);
    } else if (data['tugas'] is Map) {
      tugas = List.from(data['tugas'].values); 
    } else {
      tugas = [];
    }
  });
} else {
  setState(() {
    userName = "Failed to load data";
    userNim = "Failed to load data";
    tugas = [];
  });
}
    } catch (e) {
      setState(() {
        userName = "Error: $e";
        userNim = "Error: $e";
        tugas = [];
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
      backgroundColor: const Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF001C72),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40.0,
                      color: Color(0xFF001C72),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          userNim,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TasksScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                          ),
                          child: const Text(
                            "Yuk Kompen!",
                            style: TextStyle(
                              color: Color(0xFF001C72),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 90.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QRCodePage()), // Sesuaikan dengan nama kelas yang benar
                  );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AkumulasiPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Color(0xFF191970),
                          size: 30.0,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$userTotal Jam", // Menggabungkan userTotal dengan teks "Jam"
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF191970),
                              ),
                            ),
                            const Text(
                              "Alpha",
                              style: TextStyle(
                                color: Color(0xFF191970),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: const [
                            Text(
                              "+x Jam",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4), // Added space
                            Text(
                              "Alpha",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: const [
                            Text(
                              "-y Jam",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4), // Added space
                            Text(
                              "Alpha",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Rekomendasi Kompen",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191970),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tugas.length,
                itemBuilder: (context, index) {
                  final item = tugas[index];
                  return KompenCard(
                    title: item['tugas_nama'] ?? "Tidak ada nama",
                    hours: "${item['tugas_jam_kompen'] ?? 0} Jam",
                    description: item['tugas_deskripsi'] ?? "Deskripsi kosong",
                    icon: Icons.task,
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
        color: Colors.indigo[900], // Dark blue bottom bar
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to home
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