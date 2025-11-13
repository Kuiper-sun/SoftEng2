/*
 * Program Title: SariwAI Mobile Application
 * Programmers: [Your Name/Team Name Here]
 * Where the program fits: Frontend - This file defines the screen that displays the final
 *                         analysis results to the user.
 * Date written: 2025-11-14
 * Date revised: 2025-11-14
 * Purpose: This screen takes the analysis data from the backend (via the ImagePreviewScreen)
 *          and presents it in a clear, user-friendly format. It uses color-coding
 *          and conditional UI elements to show the freshness status, detailed
 *          predictions, and confidence scores, or a clear message if no tilapia was detected.
 * Data structures, algorithms, and control:
 *          - This is a StatelessWidget that displays data passed via its constructor.
 *          - Control Flow: Uses `switch` statements in helper methods to determine the
 *                          appropriate color and text for the given status. Conditional logic
 *                          in the `build` method (`if (showDetails)`) alters the UI layout
 *                          based on the analysis result.
 */

import 'dart:io';
import 'package:flutter/material.dart';

/// A screen that displays the results of the tilapia freshness analysis.
///
/// This widget is responsible for interpreting the `status` string and other
/// data from the backend to provide visual feedback to the user.
class ResultScreen extends StatelessWidget {
  /// The local file system path to the analyzed image.
  final String imagePath;

  /// The final freshness status from the backend (e.g., 'Fresh', 'No Tilapia Detected').
  final String status;

  /// The classification of the fish's eye (e.g., 'fresh', 'not-fresh').
  final String eyePrediction;

  /// The classification of the fish's gill (e.g., 'fresh', 'old').
  final String gillPrediction;

  /// The model's confidence score for the eye prediction.
  final double eyeScore;

  /// The model's confidence score for the gill prediction.
  final double gillScore;

  /// Creates the ResultScreen.
  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.status,
    this.eyePrediction = 'Not Found',
    this.gillPrediction = 'Not Found',
    this.eyeScore = 0.0,
    this.gillScore = 0.0,
  });

  /// Determines the primary display color based on the freshness status.
  ///
  /// Returns a specific [Color] for each known status, with a fallback grey color.
  Color getStatusColor() {
    // --- CLEANED UP ---
    // Removed the 'Incomplete Detection' case which is no longer sent by the backend.
    // Changed 'No Fish Detected' to 'No Tilapia Detected'.
    switch (status) {
      case 'Fresh':
        return const Color(0xFF14A66C);
      case 'Not Fresh':
        return const Color(0xFFD66A4E);
      case 'Old':
        return const Color(0xFF735E59);
      case 'No Tilapia Detected': // Updated to match the backend
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  /// Provides a user-friendly description corresponding to the freshness status.
  ///
  /// Returns a specific [String] for each known status.
  String getStatusDescription() {
    // --- CLEANED UP ---
    // Simplified the switch to handle the one failure case from the backend.
    switch (status) {
      case 'Fresh':
        return 'This tilapia looks fresh and good to eat.';
      case 'Not Fresh':
        return 'This fish isn’t at its best. Use with caution.';
      case 'Old':
        return 'This tilapia appears old. Avoid consuming it.';
      case 'No Tilapia Detected': // Updated to match the backend
      default:
        return 'No tilapia detected. Please retake the photo, ensuring both the eye and gill are clearly visible.';
    }
  }

  /// Builds the widget tree for the results screen.
  @override
  Widget build(BuildContext context) {
    // Determine the color and description once to reuse throughout the build method.
    final color = getStatusColor();
    final description = getStatusDescription();

    // --- SIMPLIFIED ---
    // The 'displayStatus' transformation is no longer needed.
    // The backend now sends the correct 'No Tilapia Detected' string directly.
    // We can just use the 'status' variable.

    // Calculate formatted percentage strings for scores, but only if scores are valid.
    final String eyeScorePercent =
    eyeScore > 0 ? '(${(eyeScore * 100).toStringAsFixed(1)}%)' : '';
    final String gillScorePercent =
    gillScore > 0 ? '(${(gillScore * 100).toStringAsFixed(1)}%)' : '';

    // A boolean flag to determine if the detailed analysis box should be shown.
    // This is true only for successful detections.
    final bool showDetails =
        status == 'Fresh' || status == 'Not Fresh' || status == 'Old';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- Top Section: Image Display Area ---
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
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 30),
                      onPressed: () =>
                          Navigator.popUntil(context, ModalRoute.withName('/')),
                    ),
                  ),
                ],
              ),
            ),

            // --- Bottom Section: Results Panel ---
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showDetails ? 'The tilapia is' : 'Analysis Result',
                        style: const TextStyle(
                          fontFamily: 'CovikSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF103937),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          // Now using the 'status' variable directly. It's much cleaner.
                          status,
                          style: const TextStyle(
                            fontFamily: 'CovikSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xFFF8F8F8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Conditionally render either the details box or a simple description.
                      if (showDetails)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Analysis Details',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Eye Prediction:',
                                      style: TextStyle(
                                          fontSize: 16, fontFamily: 'Inter')),
                                  Text('$eyePrediction $eyeScorePercent',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Gill Prediction:',
                                      style: TextStyle(
                                          fontSize: 16, fontFamily: 'Inter')),
                                  Text('$gillPrediction $gillScorePercent',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 8),
                              Text(description,
                                  style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(0xFF103937))),
                            ],
                          ),
                        )
                      else
                      // This view is shown for "No Tilapia Detected".
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xFF103937),
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // --- Action Button ---
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A3932),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Navigate back to the Camera screen, removing the
                          // result and preview screens from the navigation stack.
                          Navigator.popUntil(
                              context, ModalRoute.withName('/camera'));
                        },
                        child: const Text(
                          'Analyze Another Fish',
                          style: TextStyle(
                            fontFamily: 'CovikSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}