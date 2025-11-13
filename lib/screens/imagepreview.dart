/*
 * Program Title: SariwAI Mobile Application
 * Programmers: [Your Name/Team Name Here]
 * Where the program fits: Frontend - This file defines the screen that displays a selected
 *                         image and allows the user to send it to the backend for analysis.
 * Date written: 2025-11-14
 * Date revised: 2025-11-14
 * Purpose: This screen acts as a confirmation step after a user selects an image.
 *          It shows a full-screen preview of the image and provides an "Analyze Image"
 *          button. When pressed, it handles the HTTP multipart request to the backend API,
 *          shows a loading indicator, and navigates to the ResultScreen upon a
 *          successful response.
 * Data structures, algorithms, and control:
 *          - State Management: Uses a StatefulWidget to manage a `_isLoading` boolean flag,
 *                            which controls the UI during the network request.
 *          - Control Flow: The `_analyzeImage` async method contains the core logic. It uses
 *                        a try-catch-finally block for robust error handling during the
 *                        HTTP request. Navigation is handled via Navigator.pushReplacement.
 */

// --- Framework and Plugin Imports ---
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

// --- Project Screen Imports ---
import 'result.dart';

/// A screen that displays a preview of the selected image and allows the user
/// to initiate the analysis process.
class ImagePreviewScreen extends StatefulWidget {
  /// The local file system path to the image that should be previewed.
  final String imagePath;

  const ImagePreviewScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  // BEST PRACTICE: Store configurable values like URLs as constants.
  // This avoids "magic strings" and makes the code easier to maintain.
  static const String _apiEndpoint =
      'https://kuiper-sun-tilapia-api.hf.space/predict';

  /// A state variable to track whether the analysis is in progress.
  /// Used to show a loading indicator and disable the button.
  bool _isLoading = false;

  /// Handles the process of uploading the image to the backend API for analysis.
  ///
  /// This method performs the following steps:
  /// 1. Sets the UI to a loading state.
  /// 2. Creates and sends an HTTP multipart request with the image file.
  /// 3. Awaits a response from the server.
  /// 4. On success (status 200), it decodes the JSON response and navigates to
  ///    the [ResultScreen] with the analysis data.
  /// 5. On failure (server or connection error), it shows a snackbar message.
  /// 6. Finally, it resets the UI from the loading state.
  Future<void> _analyzeImage() async {
    // Start loading indicator
    setState(() {
      _isLoading = true;
    });

    final uri = Uri.parse(_apiEndpoint);

    try {
      // Create a multipart request for file upload.
      var request = http.MultipartRequest('POST', uri)
        ..files.add(
          await http.MultipartFile.fromPath(
            'file', // The field name the backend API expects.
            widget.imagePath,
            contentType: MediaType('image', 'jpeg'),
          ),
        );

      // Send the request. A long timeout is used to handle potential "cold starts"
      // of the backend server, which can be slow on the first request.
      final streamedResponse =
      await request.send().timeout(const Duration(seconds: 60));

      // --- Handle the server's response ---
      if (streamedResponse.statusCode == 200) {
        final responseBody = await streamedResponse.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);

        // Safely extract all data from the response, providing default values.
        final String status = decodedResponse['status'] ?? 'Error';
        final String eyePrediction = decodedResponse['eye_prediction'] ?? 'Not Found';
        final String gillPrediction = decodedResponse['gill_prediction'] ?? 'Not Found';
        final double eyeScore = (decodedResponse['eye_score'] as num?)?.toDouble() ?? 0.0;
        final double gillScore = (decodedResponse['gill_score'] as num?)?.toDouble() ?? 0.0;

        // Navigate to the results page if the widget is still mounted.
        if (mounted) {
          // Use pushReplacement so the user can't navigate "back" from the result
          // screen to the preview screen. It creates a more logical user flow.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResultScreen(
                imagePath: widget.imagePath,
                status: status,
                eyePrediction: eyePrediction,
                gillPrediction: gillPrediction,
                eyeScore: eyeScore,
                gillScore: gillScore,
              ),
            ),
          );
        }
      } else {
        // Handle server-side errors (e.g., 400, 500).
        final errorBody = await streamedResponse.stream.bytesToString();
        debugPrint("Server Error [${streamedResponse.statusCode}]: $errorBody");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Server Error: Could not get a valid response.')),
          );
        }
      }
    } catch (e, stacktrace) {
      // Handle network errors (e.g., timeout, no internet connection).
      debugPrint("================== HTTP REQUEST FAILED ==================");
      debugPrint("URL: $uri");
      debugPrint("Error Type: ${e.runtimeType}");
      debugPrint("Error Message: $e");
      debugPrint("Stacktrace: $stacktrace");
      debugPrint("=========================================================");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Connection failed. Please check your internet and try again.')),
        );
      }
    } finally {
      // This block ensures the loading indicator is always turned off,
      // even if an error occurs.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Builds the widget tree for the image preview screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        // The Stack widget allows layering widgets on top of each other.
        // Used here to place buttons over the central image.
        child: Stack(
          children: [
            // --- Center: The image preview ---
            Center(child: Image.file(File(widget.imagePath), fit: BoxFit.contain)),

            // --- Top-Left: Back Button ---
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // --- Top-Right: Close Button (returns to home) ---
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () =>
                    Navigator.popUntil(context, ModalRoute.withName('/')),
              ),
            ),

            // --- Bottom: Analyze Button ---
            Positioned(
              bottom: 32,
              left: 24,
              right: 24,
              child: ElevatedButton(
                // The button is disabled while loading to prevent multiple submissions.
                onPressed: _isLoading ? null : _analyzeImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3332),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor:
                  const Color(0xFF0A3332).withOpacity(0.5),
                ),
                // Conditionally show a loading indicator or the button text.
                child: _isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Analyze Image',
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
    );
  }
}