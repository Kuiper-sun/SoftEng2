/*
 * Program Title: SariwAI Mobile Application
 * Programmers: [Your Name/Team Name Here]
 * Where the program fits: Frontend - This is the initial screen that users see when they
 *                         first open the application.
 * Date written: 2025-11-14
 * Date revised: 2025-11-14
 * Purpose: This screen serves as the landing page, welcoming the user and providing a
 *          brief introduction to the app's purpose. It features entry animations and
 *          clear navigation paths to the "How It Works" screen and the main camera feature.
 * Data structures, algorithms, and control:
 *          - State Management: Uses a StatefulWidget with a SingleTickerProviderStateMixin
 *                            to manage animations and the hover state of the main button.
 *          - Control Flow: An AnimationController orchestrates a fade and slide transition
 *                        when the screen loads. Navigation is handled via Navigator.pushNamed.
 */

import 'package:flutter/material.dart';

/// The main welcome screen for the SariwAI application.
///
/// It displays an introduction, the app logo, and navigation buttons.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

/// The state class for [WelcomeScreen], managing animations and hover effects.
class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  /// A boolean to track the hover state of the "Get Started" button for visual feedback.
  bool isHovered = false;

  /// The controller that manages the duration and state of the entry animations.
  late AnimationController _animationController;

  /// The animation that controls the fade-in effect of the screen content.
  late Animation<double> _fadeAnimation;

  /// The animation that controls the slide-up effect of the screen content.
  late Animation<Offset> _slideAnimation;

  /// Called once when the widget is inserted into the widget tree.
  ///
  /// This is where the animation controller and animations are initialized.
  /// The animation is started by calling `_animationController.forward()`.
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this, // `vsync` prevents off-screen animations from consuming resources.
    );

    // Defines a fade animation from transparent (0.0) to opaque (1.0).
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Defines a slide animation that moves content up from below.
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    // Starts the animations.
    _animationController.forward();
  }

  /// Called when the widget is permanently removed from the widget tree.
  ///
  /// It is crucial to dispose of the [AnimationController] to free up resources
  /// and prevent memory leaks.
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Builds the widget tree for the welcome screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            // Apply the fade and slide animations to the entire column.
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // --- Welcome Title ---
                    // ShaderMask is used to apply a gradient to the text.
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF14A66C), Color(0xFF0D7A4E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Welcome!',
                        style: TextStyle(
                          fontFamily: 'CovikSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 55,
                          color: Colors.white, // This color is a placeholder, the gradient is used instead.
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // --- Description Card ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'SariwAI helps you determine the freshness of tilapia by analyzing visual indicators from captured or uploaded images, ensuring the fish is consumed at its best quality.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xFF103937),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF14A66C).withOpacity(0.1),
                                  const Color(0xFF14A66C).withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/howitworks');
                              },
                              icon: const Icon(
                                Icons.help_outline_rounded,
                                color: Color(0xFF1A8E60),
                                size: 20,
                              ),
                              label: const Text(
                                'How it works',
                                style: TextStyle(
                                  fontFamily: 'CovikSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF1A8E60),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- App Logo ---
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF14A66C).withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      // LayoutBuilder makes the logo size responsive to the screen width.
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double logoSize =
                              MediaQuery.of(context).size.width * 0.5;
                          if (logoSize > 220) logoSize = 220; // Max size
                          if (logoSize < 150) logoSize = 150; // Min size
                          return Image.asset(
                            'assets/images/logo.png',
                            width: logoSize,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- App Name ---
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF2E5662), Color(0xFF1A3A42)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds),
                      child: const Text(
                        'SariwAI',
                        style: TextStyle(
                          fontFamily: 'CovikSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 55,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    // --- App Subtitle ---
                    const Text(
                      'TILAPIA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color(0xFF2E5662),
                        letterSpacing: 18 * 0.25, // Creates wide spacing
                      ),
                    ),
                    const SizedBox(height: 50),

                    // --- Get Started Button ---
                    MouseRegion(
                      onEnter: (_) => setState(() => isHovered = true),
                      onExit: (_) => setState(() => isHovered = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(55),
                          boxShadow: [
                            BoxShadow(
                              color: isHovered
                                  ? const Color(0xFF14A66C).withOpacity(0.4)
                                  : const Color(0xFF0A3932).withOpacity(0.3),
                              blurRadius: isHovered ? 20 : 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/camera');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isHovered
                                ? const Color(0xFF14A66C)
                                : const Color(0xFF0A3932),
                            foregroundColor: const Color(0xFFF8F8F8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 70,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(55),
                            ),
                            elevation: 0, // Elevation is handled by the AnimatedContainer's shadow.
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontFamily: 'CovikSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 24,
                                color: Color(0xFFF8F8F8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}