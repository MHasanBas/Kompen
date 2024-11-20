import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = "http://192.168.122.83:8000/api";

  Future<List<dynamic>> getLevels() async {
    try {
      Response response = await _dio.get("$baseUrl/levels");
      if (response.statusCode == 200 && response.data.containsKey('data')) {
        return response.data['data'];
      } else {
        throw Exception('Invalid response structure');
      }
    } catch (e) {
      throw Exception("Error fetching levels: $e");
    }
  }

  Future<void> register({
    required int levelId,
    required String username,
    required String nama,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      Response response = await _dio.post(
        "$baseUrl/create_data",
        data: {
          'level_id': levelId,
          'username': username,
          'nama': nama,
          'password': password,
        },
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      throw Exception("Error during registration: $e");
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      Response response = await _dio.post(
        "$baseUrl/login",
        data: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode != 200 || !response.data.containsKey('token')) {
        throw Exception(response.data['message'] ?? 'Login gagal');
      }
      // Simpan token, jika dibutuhkan
      return response.data['token'];
    } catch (e) {
      throw Exception("Error during login: $e");
    }
  }
}
