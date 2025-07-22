import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontFamily: 'CovikSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 55,
                  color: Color(0xFF14A66C),
                ),
              ),

              const SizedBox(height: 5),
              const Text(
                'SariwAI helps you determine the freshness of\ntilapia by analyzing visual indicators from\ncaptured or uploaded images, ensuring the\nfish is consumed at its best quality.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF103937),
                ),
              ),

              const SizedBox(height: 0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/howitworks');
                },
                child: const Text(
                  'How it works',
                  style: TextStyle(
                    fontFamily: 'CovikSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF1A8E60),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF1A8E60),
                    decorationThickness: 2,
                  ),
                ),
              ),

              const SizedBox(height: 40),
              Image.asset('assets/images/logo.png', width: 250),

              const Text(
                'SariwAI',
                style: TextStyle(
                  fontFamily: 'CovikSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 55,
                  color: Color(0xFF2E5662),
                ),
              ),

              const SizedBox(height: 0),
              const Text(
                'TILAPIA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xFF2E5662),
                  letterSpacing: 18 * 0.25,
                ),
              ),

              const SizedBox(height: 60),
              MouseRegion(
                onEnter: (_) {
                  setState(() {
                    isHovered = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    isHovered = false;
                  });
                },
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/camera');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isHovered
                        ? Color(0xFF77FFC9)
                        : Color(0xFF0A3932),
                    foregroundColor: Color(0xFFF8F8F8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(55),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontFamily: 'CovikSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
