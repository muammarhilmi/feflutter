import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import '../pages/main_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
} 

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  // GANTI 'YOUR_WEB_CLIENT_ID_DISINI' dengan ID yang di-copy dari Google Cloud (Web Application)
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '585593837076-tpgn5tqhcf320jr8713arort017csufo.apps.googleusercontent.com'  //android
        : '585593837076-tdl7818qqsi9g1t54q1b61gaani0qfpv.apps.googleusercontent.com', //web aplication
    scopes: ['email'],
  );

  void _handleManualLogin() async {
    if (email.text.isEmpty || password.text.isEmpty) return;
    setState(() => loading = true);
    final result = await AuthService.login(email.text, password.text);
    setState(() => loading = false);

    if (result['status']) {
      await AuthService.saveUserSession(result['data']);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Login gagal")),
        );
      }
    }
  }

  void _handleGoogleLogin() async {
    try {
      print("LOG: Memulai Google Sign-In...");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("LOG: User membatalkan login.");
        return;
      }

      setState(() => loading = true);
      print("LOG: Login Google Berhasil: ${googleUser.email}");

      final result = await AuthService.googleAuthBackend(
        googleUser.email,
        googleUser.displayName ?? "No Name",
        googleUser.id,
      );

      setState(() => loading = false);

      if (result['status']) {
        print("LOG: Backend Berhasil Memproses.");
        await AuthService.saveUserSession(result['data']);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainPage()),
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? "Gagal verifikasi backend")),
          );
        }
      }
    } catch (error) {
      setState(() => loading = false);
      print("LOG ERROR: $error"); // Cek ini di Debug Console!
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error Sistem: $error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.spa, size: 80, color: Colors.pink),
              const SizedBox(height: 16),
              const Text(
                "Nail Beauty App",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                  ),
                  child: const Text("Lupa Password?", style: TextStyle(color: Colors.pink)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : _handleManualLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: loading ? null : _handleGoogleLogin,
                  icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.pink),
                  label: const Text("Masuk dengan Google", style: TextStyle(color: Colors.pink)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.pink),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                ),
                child: const Text("Belum punya akun? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}