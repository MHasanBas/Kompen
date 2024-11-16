import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mahasiswa/home_page.dart' as mahasiswa;
import 'dosen/dashboard.dart' as dosen;
import 'tendik/dashboard.dart' as tendik;
import 'register.dart';

final dio = Dio();

final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

String url_domain = "http://192.168.18.30:8000";
String url_login = url_domain + "/api/login";

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> login(BuildContext context) async {
    // Tampilkan loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      var response = await dio.post(
        url_login,
        data: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      // Tutup dialog loading
      Navigator.pop(context);

      if (response.statusCode == 200) {
        var data = response.data;

        String levelKode = data['user']['level_kode'];
        String nama = data['user']['nama'];

        // Panggil halaman sesuai peran pengguna
        navigateToDashboard(context, levelKode, nama);
      } else {
        // Tampilkan pesan error jika login gagal
        showSnackbar(context, response.data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      // Tutup dialog loading dan tampilkan pesan error
      Navigator.pop(context);
      showSnackbar(context, 'Terjadi kesalahan: $e');
    }
  }

  void navigateToDashboard(BuildContext context, String levelKode, String nama) {
    String greetingMessage = "Selamat datang, $nama!";
    Widget destination;

    if (levelKode == 'MHS') {
      destination = mahasiswa.HomePage();
    } else if (levelKode == 'DSN') {
      destination = dosen.HomeScreen();
    } else if (levelKode == 'TDK') {
      destination = tendik.HomeScreen();
    } else {
      showSnackbar(context, 'Peran tidak dikenal');
      return;
    }

    // Tampilkan pesan sukses
    showSnackbar(context, greetingMessage, isSuccess: true);

    // Navigasikan ke halaman tujuan
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  void showSnackbar(BuildContext context, String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
                  buildTextField(usernameController, "Username"),
                  const SizedBox(height: 20),
                  buildTextField(passwordController, "Password", isPassword: true),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      login(context);
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
                        MaterialPageRoute(builder: (context) => RegisterPage()),
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

  Widget buildTextField(TextEditingController controller, String hintText, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.blue[900]!,
          width: 2.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
