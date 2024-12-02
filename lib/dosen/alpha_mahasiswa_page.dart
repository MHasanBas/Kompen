import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'ProfilePage.dart';
import 'add_task_page.dart';
import 'task_approval_page.dart';
import 'notifikasi.dart';
import 'dashboard.dart';  // Ensure this is properly imported
import 'package:google_fonts/google_fonts.dart';

class Mahasiswa {
  final String nim;
  final String nama;
  final int jamAlpa;
  final int tugasJamKompen;
  final String tugasDeskripsi;
  final String tugasTenggat;

  Mahasiswa({
    required this.nim,
    required this.nama,
    required this.jamAlpa,
    required this.tugasJamKompen,
    required this.tugasDeskripsi,
    required this.tugasTenggat,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      nim: json['mahasiswa_alpa_nim'] ?? '',
      nama: json['mahasiswa_alpa_nama'] ?? '',
      jamAlpa: json['jam_alpa'] ?? 0,
      tugasJamKompen: json['approval']?['tugas']?['tugas_jam_kompen'] ?? '',
      tugasDeskripsi: json['approval']?['tugas']?['tugas_deskripsi'] ?? '',
      tugasTenggat: json['approval']?['tugas']?['tugas_tenggat'] ?? '',
    );
  }
}

class AlphaMahasiswaPage extends StatefulWidget {
  @override
  _AlphaMahasiswaPageState createState() => _AlphaMahasiswaPageState();
}

class _AlphaMahasiswaPageState extends State<AlphaMahasiswaPage> {
  late Future<List<Mahasiswa>> mahasiswaList;

  @override
  void initState() {
    super.initState();
    mahasiswaList = fetchMahasiswaAlpha();
  }

  Future<List<Mahasiswa>> fetchMahasiswaAlpha() async {
    Dio dio = Dio();
    final String apiUrl = 'http://192.168.236.129:8000/api/alpa'; // Replace with your API URL

    try {
      final response = await dio.post(
        apiUrl,
        data: {
          'key1': 'value1', // Replace with actual parameters required by the API
          'key2': 'value2',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Mahasiswa.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder<List<Mahasiswa>>(
        future: mahasiswaList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Alpha Mahasiswa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildTableHeader(),
                            const Divider(height: 1, thickness: 1),
                            ..._buildTableRows(snapshot.data!),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
AppBar _buildAppBar() {
  return AppBar(
     automaticallyImplyLeading: false,
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
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    toolbarHeight: 90.0, // Tambahkan `.0` untuk lebih spesifik
  );
}
  

        

  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: const [
          Expanded(flex: 1, child: _TableHeaderCell(text: 'No.')),
          Expanded(flex: 2, child: _TableHeaderCell(text: 'NIM')),
          Expanded(flex: 3, child: _TableHeaderCell(text: 'Nama')),
          Expanded(flex: 2, child: _TableHeaderCell(text: 'Jam Alpa')),
          Expanded(flex: 3, child: _TableHeaderCell(text: 'Jam Kompen')),
        ],
      ),
    );
  }

  List<Widget> _buildTableRows(List<Mahasiswa> mahasiswaList) {
    return List.generate(
      mahasiswaList.length,
      (index) => Column(
        children: [
          Container(
            color: index % 2 == 0
                ? Colors.grey.shade100
                : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Expanded(flex: 1, child: _TableRowCell(text: (index + 1).toString())),
                Expanded(flex: 2, child: _TableRowCell(text: mahasiswaList[index].nim)),
                Expanded(flex: 3, child: _TableRowCell(text: mahasiswaList[index].nama)),
                Expanded(flex: 2, child: _TableRowCell(text: mahasiswaList[index].jamAlpa.toString())),
                Expanded(flex: 3, child: _TableRowCell(text: mahasiswaList[index].tugasJamKompen.toString())),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
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
              icon: const Icon(Icons.access_time, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskApprovalPage()),
                );
              },
            ),
            const SizedBox(width: 50), // Spacer for FloatingActionButton
            IconButton(
              icon: const Icon(Icons.mail, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotifikasiPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profilescreen()),
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
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;

  const _TableHeaderCell({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}

class _TableRowCell extends StatelessWidget {
  final String text;

  const _TableRowCell({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12),
      textAlign: TextAlign.center,
    );
  }
}
