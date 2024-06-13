import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_akhir_pmp/screens/home/form/settings/change_theme.dart';
import 'package:provider/provider.dart';
import 'package:project_akhir_pmp/screens/home/home_screen.dart';
import 'package:project_akhir_pmp/screens/opening/welcome_screen.dart';
import 'package:project_akhir_pmp/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Project Akhir PMP',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.isDarkMode ? darkMode : lightMode,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
