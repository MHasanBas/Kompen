import 'package:flutter/material.dart';

class PrintLetterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cetak Surat Kompen"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Surat Kompen",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Gambar atau ikon surat
                          Icon(
                            Icons.document_scanner,
                            size: 100,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Surat Kompen Anda telah siap untuk dicetak.",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 16),
                    // Informasi tambahan jika ada
                    Text(
                      "Pastikan untuk memeriksa semua detail sebelum mencetak.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            // Tombol untuk mencetak surat
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Warna tombol
                foregroundColor: Colors.white, // Warna teks tombol
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Aksi untuk mendownload surat kompen
              },
              child: Text(
                "Cetak Surat",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.indigo[900], // Ubah warna bottom bar menjadi biru tua
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  // Aksi ke halaman beranda
                },
              ),
              IconButton(
                icon: Icon(Icons.access_time, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  // Aksi ke halaman waktu
                },
              ),
              SizedBox(width: 50), // Beri ruang lebih untuk tombol +
              IconButton(
                icon: Icon(Icons.mail, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  // Aksi ke halaman pesan
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30), // Warna icon putih dan ukuran lebih besar
                onPressed: () {
                  // Aksi ke halaman profil
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
          backgroundColor: Colors.transparent, // Jadikan background transparan agar tidak bertumpuk
          onPressed: () {
            // Aksi untuk tambah tugas baru
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
