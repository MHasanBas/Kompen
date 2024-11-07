import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kompen/mahasiswa/models/task.dart';
import '../print_letter_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CetakScreen());
  }
}

class CetakScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan data task dari argumen navigasi
    final Task task = ModalRoute.of(context)!.settings.arguments as Task;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Suka Kompen.',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF191970),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        leadingWidth: 482.0,
        toolbarHeight: 89.0,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Text(
                      task.title,
                      style: GoogleFonts.exo(
                        textStyle: TextStyle(
                          fontSize: 20.0, 
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      task.jenis,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFA1A3D2)),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 146.5,
                      width: 145.0,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Icon(Icons.cloud_off, size: 50.0, color: Colors.blue),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'By ${task.nama}',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        )
                      )
                    ),
                    SizedBox(height: 5),
                    Text(
                      task.tugas,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w300,
                        )
                      )
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),  
            // box time
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all( 
                  color: Colors.black, 
                  width: 1.0, 
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Icon(
                      Icons.access_time
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '16:00 PM',
                          style: GoogleFonts.exo(
                            textStyle: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        Text(
                          task.date,
                          style: GoogleFonts.exo(
                            textStyle: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF666666)
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: 100),
                    Icon(
                      Icons.arrow_downward, 
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          '- ${task.time} Jam', 
                          style: GoogleFonts.exo(
                            textStyle: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600
                            ),
                          )
                        ),
                        Text(
                          'Alpa',
                          style: GoogleFonts.exo(
                            textStyle: TextStyle(
                              color: const Color(0xFF666666),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600
                            )
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
            SizedBox(height: 20),  // Tambahkan jarak antara Box Time dan Button
            // button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrintLetterScreen()),
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27B1FF),
                  padding: EdgeInsets.symmetric(
                    horizontal: 100.0,
                    vertical: 20.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cetak Form',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        color: const Color(0xFF191970),
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to home
                },
              ),
              IconButton(
                icon: Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to time page
                },
              ),
              SizedBox(width: 50), // Space for the FAB
              IconButton(
                icon: Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to mail page
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to profile page
                },
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
          onPressed: () {
            // Action when FAB is pressed
          },
          child: Icon(
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