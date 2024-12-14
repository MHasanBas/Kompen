import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final String urlLogin = "https://kompen.kufoto.my.id/api/login";

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Function to save user credentials including token
  Future<void> saveUserCredentials(String userId, String levelId, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId); // Save user_id
    await prefs.setString('level_id', levelId); // Save level_id
    await prefs.setString('auth_token', token); // Save the authentication token
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
        MaterialPageRoute(builder: (context) => dosen.HomeScreen()),
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
        final String userId = data['user']['id'].toString(); // Save user_id
        final String token = data['token']; // Save the token

        if (levelId != null && token.isNotEmpty) {
          // Save user_id, level_id, and token in SharedPreferences
          await saveUserCredentials(userId, levelId, token);

          showLoginResultDialog(context, 'Selamat datang, $userName!', true, levelId);
        } else {
          showLoginResultDialog(context, 'Level ID atau token tidak ditemukan.', false, null);
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

  Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<String?> getLevelId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('level_id');
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    
    body: Container(
      // Menambahkan warna latar belakang
      decoration: BoxDecoration(
        color: Colors.blue[100], // Warna latar belakang
        image: const DecorationImage(
          image: AssetImage('assets/images/men.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 80), // Spasi atas untuk teks "Suka Kompen."
          // Memindahkan teks "Suka Kompen." ke bagian atas
          Text(
            "Suka Kompen.",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 30, 130),
              ),
            ),
          ),
          const SizedBox(height: 30), // Spasi antara teks dan TextField
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0), // Padding horizontal
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildTextField(
                  controller: usernameController,
                  hintText: "Username",
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: passwordController,
                  hintText: "Password",
                  isPassword: true,
                ),
              ],
            ),
          ),
          const Spacer(), // Mendorong tombol Login ke bawah layar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                login(usernameController.text, passwordController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ),
              ),
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
          ),
          const SizedBox(height: 30), // Spasi bawah untuk margin
        ],
      ),
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