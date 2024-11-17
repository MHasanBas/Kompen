import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'mahasiswa/home_page.dart' as mahasiswa;
import 'dosen/dashboard.dart' as dosen;
import 'tendik/dashboard.dart' as tendik;
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Dio dio = Dio();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String urlLogin = "http://192.168.18.30:8000/api/login";

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showLoginResultDialog(
      BuildContext context, String message, bool isSuccess, String? levelId) {
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
                  if (isSuccess && levelId != null) {
                    navigateToHome(levelId);
                  }
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

  void navigateToHome(String levelId) {
    if (levelId == '4') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => mahasiswa.HomePage()),
      );
    } else if (levelId == '2') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => dosen.HomeScreen()),
      );
    } else if (levelId == '3') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => tendik.HomeScreen()),
      );
    } else {
      showLoginResultDialog(context, 'Level pengguna tidak dikenali.', false, null);
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await dio.post(urlLogin, data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200 && response.data['user'] != null) {
        final data = response.data;
        final String? levelId = data['user']['level_id']?.toString();
        final String userName = data['user']['nama'] ?? 'Pengguna';

        if (levelId != null) {
          showLoginResultDialog(context, 'Selamat datang, $userName!', true, levelId);
        } else {
          showLoginResultDialog(context, 'Level ID tidak ditemukan.', false, null);
        }
      } else {
        showLoginResultDialog(context, 'Username atau password salah', false, null);
      }
    } on DioError catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Terjadi kesalahan pada server.';
      showLoginResultDialog(context, errorMessage, false, null);
    } catch (e) {
      showLoginResultDialog(context, 'Terjadi kesalahan. Silakan coba lagi.', false, null);
    } finally {
      usernameController.clear();
      passwordController.clear();
    }
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
                  buildTextField(
                      controller: usernameController, hintText: "Username"),
                  const SizedBox(height: 20),
                  buildTextField(
                      controller: passwordController,
                      hintText: "Password",
                      isPassword: true),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      login(usernameController.text, passwordController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
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
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  RegisterPage(),
                        )),
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

  Widget buildTextField(
      {required TextEditingController controller,
      required String hintText,
      bool isPassword = false}) {
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