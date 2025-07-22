import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import 'screens/howitworks.dart';
import 'screens/camera.dart';
import 'screens/result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SariwAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Color(0xFFF8F8F8),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/howitworks': (context) => const HowItWorksScreen(),
        '/camera': (context) => const CameraScreen(),
        '/result': (context) =>
            const ResultScreen(imagePath: '', status: 'Fresh'),
      },
    );
  }
}
