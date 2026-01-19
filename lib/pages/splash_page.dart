import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../auth/login_page.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await AuthService.isLoggedIn();

    await Future.delayed(const Duration(milliseconds: 800));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            loggedIn ? const MainPage() : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
