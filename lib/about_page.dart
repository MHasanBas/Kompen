import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tentang Pengembang",
          style: TextStyle(
            color: Colors.white, // Mengubah warna teks menjadi putih
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 18, 17, 102), // Warna biru
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Mengubah warna ikon back menjadi putih
          onPressed: () {
            Navigator.pop(context); // Menavigasi kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              "Tim Pengembang",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF004D40),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  DeveloperCard(
                    name: "M. Hasan Basri",
                    role: "Mobile Developer",
                    imagePath: "assets/images/developer1.png",
                    icon: Icons.phone_android,
                    roleColor: Colors.teal,
                  ),
                  DeveloperCard(
                    name: "Faiz Abiyu",
                    role: "Backend Developer",
                    imagePath: "assets/images/developer2.png",
                    icon: Icons.code,
                    roleColor: Colors.indigo,
                  ),
                  DeveloperCard(
                    name: "Fahmi Mardiansyah",
                    role: "Frontend Developer",
                    imagePath: "assets/images/developer3.png",
                    icon: Icons.web,
                    roleColor: Colors.orange,
                  ),
                  DeveloperCard(
                    name: "Nasywa Syafinka",
                    role: "SA / QA",
                    imagePath: "assets/images/developer4.png",
                    icon: Icons.check_circle,
                    roleColor: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Kartu Pengembang
class DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;
  final IconData icon;
  final Color roleColor;

  DeveloperCard({
    required this.name,
    required this.role,
    required this.imagePath,
    required this.icon,
    required this.roleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Foto Pengembang
          CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage(imagePath),
            backgroundColor: Colors.grey[200],
          ),
          SizedBox(height: 10),
          // Nama Pengembang
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF37474F),
            ),
          ),
          SizedBox(height: 5),
          // Role Pengembang dengan Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: roleColor,
                size: 20,
              ),
              SizedBox(width: 5),
              Text(
                role,
                style: TextStyle(
                  fontSize: 14,
                  color: roleColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
