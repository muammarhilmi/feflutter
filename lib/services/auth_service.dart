import 'dart:convert';
import 'package:flutter/foundation.dart'; 
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // --- KONFIGURASI IP ---
  static String get baseUrl {
    const String ipLaptop = "192.168.1.21"; 
    const String port = "5001";
    return "http://$ipLaptop:$port/api"; 
  }

  // 1. LOGIN MANUAL
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status': true, 'data': data['user'], 'message': data['message']};
      } else {
        return {'status': false, 'message': data['message']};
      }
    } catch (e) {
      debugPrint("LOGIN ERROR: $e");
      return {'status': false, 'message': "Gagal koneksi ke server ($e)"};
    }
  }

  // 2. REGISTER MANUAL
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {'status': true, 'message': data['message']};
      } else {
        return {'status': false, 'message': data['message']};
      }
    } catch (e) {
      debugPrint("REGISTER ERROR: $e");
      return {'status': false, 'message': "Gagal koneksi: $e"};
    }
  }

  // 3. GOOGLE AUTH BACKEND
  static Future<Map<String, dynamic>> googleAuthBackend(String email, String name, String googleId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/google-auth'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "name": name,
          "google_id": googleId
        }),
      );
      
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
         return {'status': true, 'data': data['user'], 'message': data['message']};
      } else {
        return {'status': false, 'message': data['message'] ?? "Gagal ke backend"};
      }
    } catch (e) {
      debugPrint("GOOGLE BACKEND ERROR: $e");
      return {'status': false, 'message': "Koneksi Gagal: $e"};
    }
  }

  // 4. RESET PASSWORD
  static Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": newPassword}),
      );
      final data = jsonDecode(response.body);
      return {'status': response.statusCode == 200, 'message': data['message']};
    } catch (e) {
      debugPrint("RESET PASSWORD ERROR: $e");
      return {'status': false, 'message': "Koneksi Gagal: $e"};
    }
  }

  // --- SESSION MANAGEMENT ---

  static Future<void> saveUserSession(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_login', true);
    await prefs.setString('user_name', user['name']?.toString() ?? "User");
    await prefs.setString('user_email', user['email']?.toString() ?? "");
    await prefs.setString('user_id', user['id']?.toString() ?? "");
    // Token disimpan agar tips_service.dart tidak error
    await prefs.setString('user_token', user['email']?.toString() ?? ""); 
  }

  // Fungsi yang tadi hilang dan bikin error
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token') ?? "";
  }

  static Future<Map<String, String>> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('user_name') ?? "No Name",
      'email': prefs.getString('user_email') ?? "No Email",
      'id': prefs.getString('user_id') ?? "",
    };
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_login') ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
    } catch (e) {
      debugPrint("Google Logout Error: $e");
    }
  }
}