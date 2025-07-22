import 'dart:io';
import 'dart:math'; // Importing random for generating random values
import 'package:flutter/material.dart';
import 'result.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imagePath;

  const ImagePreviewScreen({super.key, required this.imagePath});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool isHovered = false;

  // Function to generate a random status
  String getRandomStatus() {
    // Randomly select a status for demonstration
    List<String> statuses = ['Fresh', 'Not Fresh', 'Old'];
    return statuses[Random().nextInt(statuses.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.file(File(widget.imagePath), fit: BoxFit.cover),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFF8F8F8)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFFF8F8F8)),
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName('/')),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: MouseRegion(
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
                  // Generate a random status and pass it to the ResultScreen
                  String randomStatus = getRandomStatus();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultScreen(
                        imagePath: widget.imagePath,
                        status: randomStatus, // Pass the random status
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isHovered
                      ? const Color(0xFF77FFC9)
                      : const Color(0xFF0A3932),
                  foregroundColor: const Color(0xFFF8F8F8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Analyze Image'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
