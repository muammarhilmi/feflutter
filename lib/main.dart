import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
import 'pages/main_page.dart';
import 'auth/login_page.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // CEK STATUS LOGIN
  final bool isLoggedIn = await AuthService.isLoggedIn();

  runApp(NailApp(isLoggedIn: isLoggedIn));
}

class NailApp extends StatelessWidget {
  final bool isLoggedIn;

  const NailApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),

      /// FLOW APLIKASI
      home: isLoggedIn
          ? const MainPage()
          : const SplashPage(),
    );
  }
}
