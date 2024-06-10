import 'package:flutter/material.dart';
import 'package:project_akhir_pmp/screens/welcome_screen.dart';
import 'package:project_akhir_pmp/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Akhir PMP',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: const WelcomeScreen(),
    );
  }
}
