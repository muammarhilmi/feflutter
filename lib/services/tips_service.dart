import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tip.dart';
import 'auth_service.dart';

class TipsService {
  static const String baseUrl = "http://192.168.1.21:5001/api";

  static Future<List<Tip>> fetchTips() async {
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/api/tips"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Tip.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("Session habis. Silakan login ulang.");
    } else {
      throw Exception("Gagal memuat tips");
    }
  }
}
