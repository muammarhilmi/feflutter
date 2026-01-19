import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import '../pages/main_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController(); // Backend butuh nama
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb 
       ? '585593837076-tpgn5tqhcf320jr8713arort017csufo.apps.googleusercontent.com' 
       : null, 
    scopes: ['email'],
  );

  void _handleRegister() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mohon isi semua data")));
      return;
    }

    setState(() => loading = true);
    final result = await AuthService.register(nameController.text, emailController.text, passwordController.text);
    setState(() => loading = false);

    if (result['status']) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Register berhasil! Silakan Login.")));
        Navigator.pop(context);
      }
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? "Registrasi gagal")));
    }
  }

  void _handleGoogleRegister() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      setState(() => loading = true);
      final result = await AuthService.googleAuthBackend(googleUser.email, googleUser.displayName ?? "No Name", googleUser.id);
      setState(() => loading = false);

      if (result['status']) {
        await AuthService.saveUserSession(result['data']);
        if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainPage()), (route) => false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"), backgroundColor: Colors.pink, foregroundColor: Colors.white),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.person_add, size: 80, color: Colors.pink),
              const SizedBox(height: 16),
              const Text("Buat Akun Baru", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
                  child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text("Register"),
                ),
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: loading ? null : _handleGoogleRegister,
                  icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.pink),
                  label: const Text("Daftar dengan Google", style: TextStyle(color: Colors.pink)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.pink)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}