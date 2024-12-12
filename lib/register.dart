import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'login_page.dart';

final dio = Dio();

var all_data = [];

final TextEditingController usernameController = TextEditingController();
final TextEditingController namaController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

String url_domain = "https://kompen.kufoto.my.id";
String url_create_data = url_domain + "/api/create_data";
String url_get_levels = url_domain + "/api/levels";

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<dynamic> levels = [];
  int? selectedLevelId;

  @override
  void initState() {
    super.initState();
    fetchLevels();
  }

  Future<void> fetchLevels() async {
    try {
      var response = await dio.get(url_get_levels);
      print(response.data);
      if (response.statusCode == 200 && response.data.containsKey('data')) {
        setState(() {
          levels = response.data['data'];
        });
      } else {
        throw Exception('Invalid response structure');
      }
    } catch (e) {
      print("Error fetching levels: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data level.')),
      );
    }
  }

  Future<void> register(int levelId, String username, String nama,
      String password, String confirmPassword, BuildContext context) async {
    try {
      var response = await dio.post(
        url_create_data,
        data: {
          'level_id': levelId,
          'username': username,
          'nama': nama,
          'password': password,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi berhasil!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        usernameController.clear();
        namaController.clear();
        passwordController.clear();
      } else {
        String errorMessage = response.data['message'] ?? 'Registrasi gagal';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print("Error during registration: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat registrasi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/men.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Text(
                "Suka Kompen",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 30, 130),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<int>(
                        value: selectedLevelId,
                        items: levels.isEmpty
                            ? []
                            : levels.map<DropdownMenuItem<int>>((level) {
                                return DropdownMenuItem<int>(
                                  value: level['level_id'],
                                  child: Text(level['level_nama']),
                                );
                              }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLevelId = value!;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Pilih Level",
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: "Username",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: namaController,
                        decoration: InputDecoration(
                          hintText: "Nama",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (selectedLevelId == null) {
                    print("Level harus dipilih");
                  } else if (usernameController.text.isEmpty ||
                      namaController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty) {
                    print("Semua field harus diisi");
                  } else if (passwordController.text !=
                      confirmPasswordController.text) {
                    print("Password dan konfirmasi password tidak cocok");
                  } else {
                    register(
                      selectedLevelId!,
                      usernameController.text,
                      namaController.text,
                      passwordController.text,
                      confirmPasswordController.text,
                      context,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 30, 130),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Register",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text(
                "Sudah Punya Akun? Login",
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
    );
  }
}