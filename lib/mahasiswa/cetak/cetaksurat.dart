import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import '../print_letter_screen.dart';

class CetakScreen extends StatefulWidget {
  @override
  _CetakScreenState createState() => _CetakScreenState();
}

class _CetakScreenState extends State<CetakScreen> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://kompen.kufoto.my.id/api", // Ganti dengan URL Laravel API Anda
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {"Content-Type": "application/json"},
    ),
  );

  Map<String, dynamic>? _taskData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTaskData();
  }

  Future<void> _fetchTaskData() async {
    try {
      final taskId = 2; // ID tugas dapat diganti dengan nilai dinamis
      final Response response = await _dio.post(
        '/show_history',
        data: {"tugas_id": taskId},
      );

      if (response.data.containsKey("tugas")) {
        setState(() {
          _taskData = response.data["tugas"];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print("Error: ${response.data['error']}");
      }
    } catch (e) {
      print("Error: $e");
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
            textStyle: TextStyle(
              fontSize: 20.0, // Dikurangi dari 24.0
              fontWeight: FontWeight.w900,
              color: const Color(0xFF191970),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70.0, // Dikurangi dari 89.0
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _taskData != null
              ? Padding(
                  padding: const EdgeInsets.all(15.0), // Dikurangi dari 20.0
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15.0), // Dikurangi dari 25.0
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10), // Dikurangi dari 12
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3, // Dikurangi dari 5
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _taskData?['tugas_nama'] ?? 'No Data',
                              style: GoogleFonts.exo(
                                textStyle: TextStyle(
                                  fontSize: 16.0, // Dikurangi dari 20.0
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _taskData?['jenis'] ?? 'No Data',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: 10.0, // Dikurangi dari 12.0
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFA1A3D2)),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 120.0, // Dikurangi dari 146.5
                              width: 120.0, // Dikurangi dari 145.0
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(10), // Dikurangi dari 12
                              ),
                              child: Icon(Icons.cloud_off,
                                  size: 40.0, // Dikurangi dari 50.0
                                  color: Colors.blue),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _taskData?['pemberi_tugas']['dosen_nama'] ??
                                  'Unknown',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 10.0, // Dikurangi dari 12.0
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _taskData?['tugas_deskripsi'] ?? 'No Description',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 12.0, // Dikurangi dari 15.0
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0), // Dikurangi dari 20.0
                          ],
                        ),
                      ),
                      SizedBox(height: 15), // Dikurangi dari 20
                      // Kotak waktu
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10), // Dikurangi dari 15
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15), // Dikurangi dari 20
                          border: Border.all(
                            color: Colors.black,
                            width: 0.8, // Dikurangi dari 1.0
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time, size: 20), // Dikurangi dari default
                            SizedBox(width: 8), // Dikurangi dari 10
                       Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text(
      'Tanggal', // Label
      style: GoogleFonts.exo(
        textStyle: TextStyle(
          fontSize: 13.0, // Ukuran font untuk label
          fontWeight: FontWeight.w600,
          color: const Color(0xFF666666),
        ),
      ),
    ),
    SizedBox(height: 5), // Jarak antara label dan nilai tanggal
    Text(
      _taskData?['tugas_tenggat'] != null
          ? _taskData!['tugas_tenggat'].split(' ')[0] // Mengambil hanya tanggal
          : 'No Date',
      style: GoogleFonts.exo(
        textStyle: TextStyle(
          fontSize: 13.0, // Ukuran font untuk nilai tanggal
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ],
),



                            
                             SizedBox(width: 80), // Dikurangi dari 100
      Icon(
        Icons.arrow_downward,
        color: Colors.red,
        size: 18, // Dikurangi dari default
      ),
      SizedBox(width: 8), // Dikurangi dari 10
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${_taskData?['jam'] ?? '-'} Jam', // Menampilkan nilai "jam"
            style: GoogleFonts.exo(
              textStyle: TextStyle(
                  fontSize: 13.0, // Dikurangi dari 15.0
                  fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            'Alpa',
            style: GoogleFonts.exo(
              textStyle: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: 13.0, // Dikurangi dari 15.0
                  fontWeight: FontWeight.w600),
            ),
          ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15), // Dikurangi dari 20
                      // Tombol
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrintLetterScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF27B1FF),
                            padding: EdgeInsets.symmetric(
                              horizontal: 80.0, // Dikurangi dari 100
                              vertical: 15.0, // Dikurangi dari 20
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Dikurangi dari 12
                            ),
                          ),
                          child: Text(
                            'Cetak Form',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0, // Dikurangi dari 28.0
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    "No Task Found",
                    style: TextStyle(fontSize: 16.0, color: Colors.red), // Dikurangi dari 18
                  ),
                ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        color: const Color(0xFF191970),
        child: Container(
          height: 60, // Dikurangi dari 70
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white, size: 25), // Dikurangi dari 30
                onPressed: () {
                  // Navigate to home
                },
              ),
              IconButton(
                icon: Icon(Icons.access_time, color: Colors.white, size: 25), // Dikurangi dari 30
                onPressed: () {
                  // Navigate to time page
                },
              ),
              SizedBox(width: 40), // Dikurangi dari 50
              IconButton(
                icon: Icon(Icons.mail, color: Colors.white, size: 25), // Dikurangi dari 30
                onPressed: () {
                  // Navigate to mail page
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 25), // Dikurangi dari 30
                onPressed: () {
                  // Navigate to profile page
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 70, // Dikurangi dari 90
        height: 70, // Dikurangi dari 90
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            // Action when FAB is pressed
          },
          child: Icon(
            Icons.add,
            size: 40, // Dikurangi dari 50
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
