import 'package:flutter/material.dart';
import 'ProfilePage.dart';
import 'add_task_page.dart';
import 'task_approval_page.dart';
import 'notifikasi.dart';
import 'dashboard.dart';  // Ensure this is properly imported

class AlphaMahasiswaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Alpha Mahasiswa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 39, 40, 43),
              ),
            ),
          ),
          // Table Section
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
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Suka Kompen.',
        style: TextStyle(
          color: Color(0xFF003366), // Dark blue (Biru Dongker)
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: false, // Align title to the left
      iconTheme: const IconThemeData(color: Colors.indigo),
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
          Expanded(flex: 2, child: _TableHeaderCell(text: 'Kompen')),
          Expanded(flex: 2, child: _TableHeaderCell(text: 'Alpha')),
        ],
      ),
    );
  }

  List<Widget> _buildTableRows() {
    final data = [
      ['1.', '2241760139', 'M. Hasan', '1 Jam', '4 Jam'],
      ['2.', '2241760139', 'Faiz Abiyu', '1 Jam', '4 Jam'],
      ['3.', '2241760139', 'Faiz Basri', '1 Jam', '4 Jam'],
      ['4.', '2241760139', 'Faiz Abiyu', '1 Jam', '4 Jam'],
      ['5.', '2241760139', 'Faiz Abiyu', '1 Jam', '4 Jam'],
      ['6.', '2241760139', 'M. Rizky', '2 Jam', '5 Jam'],
      ['7.', '2241760139', 'Ahmad N.', '1 Jam', '3 Jam'],
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
                Expanded(flex: 3, child: _TableRowCell(text: data[index][2])),
                Expanded(flex: 2, child: _TableRowCell(text: data[index][3])),
                Expanded(flex: 2, child: _TableRowCell(text: data[index][4])),
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
