import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
<<<<<<< HEAD

// Halaman untuk Dosen dan Mahasiswa
import 'dosen/task_approval_page.dart';
import 'dosen/dashboard.dart';
import 'mahasiswa/home_page.dart' as mahasiswa;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nimController = TextEditingController();
=======
import 'mahasiswa/home_page.dart' as mahasiswa;
import 'dosen/dashboard.dart' as dosen;
import 'tendik/dashboard.dart' as tendik;
import 'register.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
>>>>>>> e88278ae2dd2621af214d0f6444d1014219c1f7a
  final TextEditingController passwordController = TextEditingController();

  // API URLs
  final String url_domain = "http://192.168.1.7:8000/";

<<<<<<< HEAD
  // Fungsi untuk login
  Future<void> login(BuildContext context) async {
    String nim = nimController.text;
    String password = passwordController.text;

    if (nim.isEmpty || password.isEmpty) {
      showLoginResultDialog(context, 'NIM/NIP dan Password tidak boleh kosong', false);
      return;
    }

    // URL endpoint untuk login
    final String loginUrl = "${url_domain}api/login"; 

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nim": nim, "password": password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        bool isSuccess = responseData['success'];
        String message = responseData['message'];

        // Menampilkan dialog hasil login
        showLoginResultDialog(context, message, isSuccess);

        if (isSuccess) {
          // Arahkan ke halaman sesuai role
          if (responseData['role'] == 'dosen') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (responseData['role'] == 'mahasiswa') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => mahasiswa.HomePage()),
            );
          }
        }
      } else {
        showLoginResultDialog(context, 'Login gagal, coba lagi.', false);
      }
    } catch (e) {
      print("Error: $e");
      showLoginResultDialog(context, 'Terjadi kesalahan, coba lagi.', false);
    }
  }

  // Dialog untuk menampilkan hasil login
  void showLoginResultDialog(BuildContext context, String message, bool isSuccess) {
=======
  void showLoginResultDialog(BuildContext context, String message, bool isSuccess, String levelKode) {
>>>>>>> e88278ae2dd2621af214d0f6444d1014219c1f7a
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            isSuccess ? 'Login Berhasil' : 'Login Gagal',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSuccess ? Colors.green : Colors.red,
              ),
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(fontSize: 18),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
<<<<<<< HEAD
=======
                  if (isSuccess) {
                    // Cek level pengguna dan arahkan ke halaman yang sesuai
                    if (levelKode == 'MHS') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => mahasiswa.HomePage()),
                      );
                    } else if (levelKode == 'DSN') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => dosen.HomeScreen()),
                      );
                    } else if (levelKode == 'TDK') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => tendik.HomeScreen()),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }
                  }
>>>>>>> e88278ae2dd2621af214d0f6444d1014219c1f7a
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                ),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

<<<<<<< HEAD
=======
  // Fungsi login ke API
  Future<void> login(String username, String password, BuildContext context) async {
    var url = 'http://192.168.69.40:8000/api/login'; // Ganti dengan URL API yang sesuai
    var response = await http.post(Uri.parse(url), body: {
      'username': username, 
      'password': password,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Pastikan data level ada dalam respons
      String levelKode = data['user']['level_kode']; // Ambil level_kode
      showLoginResultDialog(context, 'Selamat datang, ${data['user']['nama']}!', true, levelKode);
    } else {
      var data = jsonDecode(response.body);
      showLoginResultDialog(context, 'Username atau password salah', false, '');
      usernameController.clear();
      passwordController.clear();
    }
  }

>>>>>>> e88278ae2dd2621af214d0f6444d1014219c1f7a
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 30, 130),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Text(
                  "Suka Kompen.",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.blue[900]!,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: "Username", // Menggunakan username sebagai input
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.blue[900]!,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      login(usernameController.text, passwordController.text, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Belum punya akun? Register",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
}

class RegisterPage extends StatelessWidget {
  final TextEditingController nimController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 30, 130),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Text(
                  "Register",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.blue[900]!,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: nimController,
                      decoration: const InputDecoration(
                        hintText: "NIM/NIP",
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.blue[900]!,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.blue[900]!,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Confirm Password",
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      // Implement registration logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
=======
}
>>>>>>> e88278ae2dd2621af214d0f6444d1014219c1f7a
