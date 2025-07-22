import 'package:flutter/material.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text(
          'How It Works',
          style: TextStyle(
            fontFamily: 'CovikSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFF8F8F8),
        foregroundColor: Color(0xFF1A8E60),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Color(0xFF4A4A4A),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            const Text(
              '1. Take a Photo',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xFF103937),
              ),
            ),
            const Text(
              'Use your phone\'s camera within the app to\n'
              'snap a clear photo of the tilapia, or choose one\n'
              'from your gallery if you already have an image.\n'
              'Make sure the eyes and gills are clearly visible.',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFF103937),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              '2. Analyze Image',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xFF103937),
              ),
            ),
            const Text(
              'Tap the “Analyze Image” button. The app scans\n'
              'the photo and looks closely at two key freshness indicators:\n'
              '• Eye clarity\n'
              '• Gill color',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFF103937),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              '3. View Result',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xFF103937),
              ),
            ),
            const Text(
              'See instant results in a simple, color-coded\nformat:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFF103937),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 6, backgroundColor: Color(0xFF14A66C)),
                SizedBox(width: 10),
                Text(
                  'Fresh  –  Good to eat',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF103937),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 6, backgroundColor: Color(0xFFD66A4E)),
                SizedBox(width: 10),
                Text(
                  'Not Fresh  –  Use with caution',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF103937),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 6, backgroundColor: Color(0xFF735E59)),
                SizedBox(width: 10),
                Text(
                  'Old  –  Avoid consuming',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF103937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              '4. Retake If Needed',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xFF103937),
              ),
            ),
            const Text(
              'Didn’t get a clear shot? You can easily retake\n'
              'and reanalyze the photo for the best results.',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFF103937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
