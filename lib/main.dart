/*
 * Program Title: SariwAI Mobile Application
 * Programmers: [Your Name/Team Name Here]
 * Where the program fits: Frontend - This file is the main entry point for the Flutter application.
 * Date written: 2025-11-14
 * Date revised: 2025-11-14
 * Purpose: This file initializes the entire Flutter application. It sets up the root
 *          widget (MyApp), defines global application themes (like fonts and colors),
 *          and configures the named navigation routes that allow users to move
 *          between different screens.
 * Data structures, algorithms, and control:
 *          - Data Structures: A Map<String, WidgetBuilder> is used to define the named routes
 *                            for screen navigation.
 *          - Control Flow: The runApp() function inflates the root widget and attaches it to
 *                          the screen, starting the application's lifecycle. Navigation is
 *                          handled by the MaterialApp widget's routing system.
 */

// --- Framework Imports ---
import 'package:flutter/material.dart';

// --- Project Screen Imports ---
import 'screens/welcome.dart';
import 'screens/howitworks.dart';
import 'screens/camera.dart';
import 'screens/result.dart';

/// The main entry point for the application.
///
/// This function calls `runApp` to inflate the root widget and start the Flutter app.
void main() {
  runApp(const MyApp());
}

/// The root widget of the SariwAI application.
///
/// This StatelessWidget sets up the [MaterialApp], which configures the
/// overall theme, title, and navigation system for the entire app.
class MyApp extends StatelessWidget {
  /// Creates the MyApp widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // A title used by the operating system to identify the app.
      title: 'SariwAI',

      // Hides the "debug" banner in the top-right corner of the screen.
      debugShowCheckedModeBanner: false,

      // Defines the global visual theme for the entire application.
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
      ),

      // The route that is displayed when the application first starts.
      initialRoute: '/',

      // Defines the set of named routes for navigating between screens.
      // Using named routes makes navigation cleaner and easier to manage.
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/howitworks': (context) => const HowItWorksScreen(),
        '/camera': (context) => const CameraScreen(),
        // Note: The '/result' route is defined with placeholder data here.
        // In a real scenario, navigation to this screen would pass dynamic
        // data (the actual image path and status) as arguments.
        '/result': (context) =>
        const ResultScreen(imagePath: '', status: 'Fresh'),
      },
    );
  }
}