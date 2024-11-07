import 'package:flutter/material.dart';

class KompenCard extends StatelessWidget {
  final String title;
  final String hours;
  final String description;
  final IconData icon; // Ikon yang akan digunakan

  const KompenCard({
    super.key,
    required this.title,
    required this.hours,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Background putih sesuai desain Figma
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Shadow untuk efek kartu
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Placeholder untuk gambar/icon
          Container(
            width: 50, // Lebar ruang untuk gambar sesuai desain Figma
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[50], // Background biru muda untuk gambar
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue, size: 30), // Ikon
          ),
          const SizedBox(width: 16), // Spasi antara gambar dan teks

          // Bagian teks judul dan deskripsi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191970), // Warna teks utama (navy blue)
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey, // Warna deskripsi lebih terang
                  ),
                ),
              ],
            ),
          ),

          // Bagian jam
          Text(
            hours,
            style: const TextStyle(
              color: Colors.red, // Warna jam sesuai desain
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    
  }
  
}
