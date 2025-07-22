import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final String status;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.status,
  });

  Color getStatusColor() {
    switch (status) {
      case 'Fresh':
        return const Color(0xFF14A66C);
      case 'Not Fresh':
        return const Color(0xFFD66A4E);
      case 'Old':
        return const Color(0xFF735E59);
      default:
        return Colors.grey;
    }
  }

  String getStatusDescription() {
    switch (status) {
      case 'Fresh':
        return 'This tilapia looks fresh and good to eat.';
      case 'Not Fresh':
        return 'This fish isn’t at its best. Use with caution.';
      case 'Old':
        return 'This tilapia appears old. Avoid consuming it.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor();
    final description = getStatusDescription();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.file(File(imagePath), fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () =>
                          Navigator.popUntil(context, ModalRoute.withName('/')),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'The tilapia is',
                      style: TextStyle(
                        fontFamily: 'CovikSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF103937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      width:
                          double.infinity, // Full width container for green box
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        status,
                        style: const TextStyle(
                          fontFamily: 'CovikSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xFFF8F8F8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center, // Center the white box
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width:
                            MediaQuery.of(context).size.width *
                            0.85, // Same width as the green box
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Good to go?',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              description,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Color(0xFF103937),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
