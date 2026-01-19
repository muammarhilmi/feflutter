import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool loading = false;

  void _handleReset() async {
    if (emailController.text.isEmpty || newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Isi semua data")));
      return;
    }
    setState(() => loading = true);
    final result = await AuthService.resetPassword(emailController.text, newPasswordController.text);
    setState(() => loading = false);

    if (result['status']) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password berhasil diubah.")));
        Navigator.pop(context);
      }
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? "Gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password"), backgroundColor: Colors.pink, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_reset, size: 80, color: Colors.pink),
            const SizedBox(height: 16),
            const Text("Lupa Password?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email Terdaftar", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email))),
            const SizedBox(height: 12),
            TextField(controller: newPasswordController, obscureText: true, decoration: const InputDecoration(labelText: "Password Baru", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock_open))),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : _handleReset,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
                child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text("Ubah Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}