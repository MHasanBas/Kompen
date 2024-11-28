import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkumulasiPage extends StatefulWidget {
  const AkumulasiPage({super.key});

  @override
  _AkumulasiPageState createState() => _AkumulasiPageState();
}

class _AkumulasiPageState extends State<AkumulasiPage> {
  String userTotal = "Loading..."; // Kolom jumlah_alpa dari MahasiswaModel
  String userJumlah = "Loading..."; // Menampilkan jumlah alpa dari AkumulasiModel
  String userSemester = "Loading..."; // Kolom semester dari AkumulasiModel
  List<dynamic> akumulasi = [];

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  final Dio _dio = Dio();

  Future<void> fetchData() async {
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await _dio.post(
        'http://192.168.194.83:8000/api/akumulasi', // Ubah endpoint ke API Akumulasi
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        setState(() {
          // Ambil kolom jumlah_alpa dari MahasiswaModel
          userTotal = data['mahasiswa']['jumlah_alpa'].toString();
          
          // Ambil kolom jumlah_alpa dan semester dari AkumulasiModel
          if (data['akumulasi'].isNotEmpty) {
            userJumlah = data['akumulasi'][0]['jumlah_alpa'].toString(); // Ambil jumlah alpa dari AkumulasiModel
            userSemester = data['akumulasi'][0]['semester'].toString(); // Ambil semester
            akumulasi = data['akumulasi']; // Daftar akumulasi
          } else {
            userJumlah = "No data";
            userSemester = "No data";
          }
        });
      } else {
        setState(() {
          userTotal = "Failed to load data";
          userJumlah = "Failed to load data";
          userSemester = "Failed to load data";
          akumulasi = [];
        });
      }
    } catch (e) {
      setState(() {
        userTotal = "Error: $e";
        userJumlah = "Error: $e";
        userSemester = "Error: $e";
        akumulasi = [];
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Memanggil fetchData saat halaman diinisialisasi
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
        automaticallyImplyLeading: false, // Hilangkan tombol kembali
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: userTotal == "Loading..." // Tampilkan loading saat data sedang dimuat
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTimeInfo(Icons.access_time, "$userTotal Jam", "Alpha"),
                            _buildTimeInfoWithLabel(
                                Icons.arrow_upward, "+ X", "Alpha",
                                color: Colors.red),
                            _buildTimeInfoWithLabel(
                                Icons.arrow_downward, "- Y", "Alpha",
                                color: Colors.green),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.grey),

                        // List akumulasi per semester
                        ...akumulasi.map((item) {
                          return Column(
                            children: [
                              AkumulasiRow(
                                semester: item['semester']?.toString() ?? 'Unknown',
                                hours: "${item['jumlah_alpa']?.toString() ?? '0'} Jam",
                              ),
                              const Divider(color: Colors.grey),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total Alpha = $userTotal Jam",
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
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
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {},
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {},
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
        decoration: BoxDecoration(
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

  Widget _buildTimeInfo(IconData icon, String time, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF191970), size: 24),
            const SizedBox(width: 8),
            Text(
              time,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF191970),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfoWithLabel(IconData icon, String time, String label,
      {Color color = Colors.black}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              time,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: color),
        ),
      ],
    );
  }
}

class AkumulasiRow extends StatelessWidget {
  final String semester;
  final String hours;

  const AkumulasiRow({super.key, required this.semester, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            semester,
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            hours,
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ),
      ],
    );
  }
}