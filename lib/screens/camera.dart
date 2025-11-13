/*
 * Program Title: SariwAI Mobile Application
 * Programmers: [Your Name/Team Name Here]
 * Where the program fits: Frontend - This file defines the screen where users can
 *                         choose to either take a new photo or select one from their device's gallery.
 * Date written: 2025-11-14
 * Date revised: 2025-11-14
 * Purpose: This screen provides the user interface for image selection. It contains
 *          two primary actions: launching the device camera and opening the image
 *          gallery. Once an image is selected, it navigates the user to the
 *          ImagePreviewScreen, passing the selected image's path.
 * Data structures, algorithms, and control:
 *          - State Management: Uses a StatefulWidget to manage the hover state of the buttons.
 *          - Control Flow: An async function `_pickImage` handles the interaction with the
 *                        image_picker plugin. On successful image selection, it uses the
 *                        Navigator to push the ImagePreviewScreen onto the stack.
 */

// --- Framework and Plugin Imports ---
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// --- Project Screen Imports ---
import 'imagepreview.dart';

/// A screen that allows users to select an image from the camera or gallery.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // Instance of the image picker plugin to handle camera/gallery access.
  final ImagePicker _picker = ImagePicker();

  // --- State Variables for UI ---
  // BEST PRACTICE: Each interactive element should have its own state.
  // Using separate booleans ensures only the hovered button changes color.
  bool _isCameraHovered = false;
  bool _isGalleryHovered = false;

  /// Picks an image from the given [source] (camera or gallery) and navigates
  /// to the preview screen.
  Future<void> _pickImage(ImageSource source) async {
    try {
      // Await the user to select an image.
      final XFile? image = await _picker.pickImage(source: source);

      // If an image is successfully picked, navigate to the preview screen.
      // The `mounted` check is a good practice to ensure the widget is still
      // in the widget tree before performing async navigation.
      if (image != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImagePreviewScreen(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      // Basic error handling if the image picker fails.
      // In a production app, this could be a user-facing dialog.
      debugPrint('Error selecting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text(
          'Import Image',
          style: TextStyle(
            fontFamily: 'CovikSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        foregroundColor: const Color(0xFF1A8E60),
        elevation: 0.5, // A subtle shadow to separate the app bar from the body.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF4A4A4A),
          onPressed: () {
            // Standard way to return to the previous screen.
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        // This outer Column structures the whole screen vertically.
        child: Column(
          children: [
            // This inner Column centers the placeholder icon.
            const Column(
              children: [
                SizedBox(height: 250),
                Icon(
                  Icons.photo_camera_back_rounded,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 40),
              ],
            ),
            // The Expanded widget pushes the buttons to the bottom of the screen.
            Expanded(child: Container()),

            // Contains the action buttons, padded from the bottom edge.
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  // BEST PRACTICE SUGGESTION: The two buttons below are very similar.
                  // In a larger app, it would be ideal to extract this button logic
                  // into a reusable custom widget (e.g., `PrimaryActionButton`)
                  // to avoid code duplication and simplify maintenance.

                  // --- "Use Camera" Button ---
                  MouseRegion(
                    onEnter: (_) => setState(() => _isCameraHovered = true),
                    onExit: (_) => setState(() => _isCameraHovered = false),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCameraHovered
                            ? const Color(0xFF77FFC9)
                            : const Color(0xFF0A3932),
                        foregroundColor: const Color(0xFFF8F8F8),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        textStyle: const TextStyle(
                          fontFamily: 'CovikSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Use Camera'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- "Select from Gallery" Button ---
                  MouseRegion(
                    onEnter: (_) => setState(() => _isGalleryHovered = true),
                    onExit: (_) => setState(() => _isGalleryHovered = false),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isGalleryHovered
                            ? const Color(0xFF77FFC9)
                            : const Color(0xFF0A3932),
                        foregroundColor: const Color(0xFFF8F8F8),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        textStyle: const TextStyle(
                          fontFamily: 'CovikSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Select from Gallery'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}