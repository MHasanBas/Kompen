import 'package:flutter/material.dart';
import 'add_task_page.dart';
import 'task_approval_page.dart';
import 'notifikasi.dart';
import 'dashboard.dart';
import 'ProfilePage.dart';

class KompenMahasiswaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Suka Kompen.',
          style: TextStyle(
            color: Color(0xFF003366), // Dark blue (Biru Dongker)
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false, // Align title to the left
        iconTheme: IconThemeData(color: Colors.indigo),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Kompen Mahasiswa',
              style: TextStyle(
                fontSize: 16, // Ukuran font judul lebih kecil
                fontWeight: FontWeight.bold,
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
                      ..._buildTableRows(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
                    MaterialPageRoute(builder: (context) => HomePage()),
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
              const SizedBox(width: 50), // Spacer for the FloatingActionButton
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
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
          Expanded(flex: 2, child: _TableHeaderCell(text: 'Nama')),
          Expanded(flex: 2, child: _TableHeaderCell(text: 'Tugas Kompen')),
          Expanded(flex: 1, child: _TableHeaderCell(text: 'Bobot')),
          Expanded(flex: 2, child: _TableHeaderCell(text: 'Status')),
        ],
      ),
    );
  }

  List<Widget> _buildTableRows() {
    final data = [
      ['1.', '2241760139', 'Faiz Abiyu', 'Mengaji', '1', 'Selesai'],
      ['2.', '2241760139', 'Faiz Abiyu', 'Mengaji', '2', 'Belum Selesai'],
      ['3.', '2241760139', 'Faiz Abiyu', 'Mengaji', '1', 'Selesai'],
    ];

    return List.generate(
      data.length,
      (index) => Column(
        children: [
          Container(
            color: index % 2 == 0
                ? Colors.grey.shade100
                : Colors.white, // Alternating row colors
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Expanded(flex: 1, child: _TableRowCell(text: data[index][0])),
                Expanded(flex: 2, child: _TableRowCell(text: data[index][1])),
                Expanded(flex: 2, child: _TableRowCell(text: data[index][2])),
                Expanded(flex: 2, child: _TableRowCell(text: data[index][3])),
                Expanded(flex: 1, child: _TableRowCell(text: data[index][4])),
                Expanded(
                  flex: 2,
                  child: _TableRowCell(
                    icon: data[index][5] == 'Selesai'
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        data[index][5] == 'Selesai' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
        ],
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
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.indigo,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _TableRowCell extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color? color;

  const _TableRowCell({this.text, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return icon != null
        ? Icon(
            icon,
            color: color,
            size: 20,
          )
        : Text(
            text ?? '',
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          );
  }
}
