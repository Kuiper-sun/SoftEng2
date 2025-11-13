/*
 * Program Title: SariwAI Mobile Application
 * Programmers: [Your Name/Team Name Here]
 * Where the program fits: Frontend - This file defines the informational "How It Works" screen.
 * Date written: 2025-11-14
 * Date revised: 2025-11-14
 * Purpose: This screen provides a static, step-by-step guide for users on how
 *          to use the application to check the freshness of tilapia. It is designed
 *          to be purely informational to improve the user experience.
 * Data structures, algorithms, and control:
 *          - This is a StatelessWidget containing no complex logic. The UI is built
 *            declaratively. Private helper methods (_buildStepCard, _buildFreshnessIndicator)
 *            are used to reduce code duplication and improve readability of the main
 *            build method.
 */

import 'package:flutter/material.dart';

/// A screen that explains the step-by-step process of using the app.
///
/// This widget is purely for display and contains no mutable state.
class HowItWorksScreen extends StatelessWidget {
  /// Creates the HowItWorksScreen.
  const HowItWorksScreen({super.key});

  /// A private helper method to build a styled card for each step.
  ///
  /// This widget abstracts the common UI for each step in the guide,
  /// making the main `build` method cleaner and easier to read.
  ///
  /// [stepNumber] - The text to display for the step (e.g., "Step 1").
  /// [title] - The main title of the step.
  /// [description] - The detailed explanation for the step.
  /// [icon] - The [IconData] to display for the step.
  /// [iconColor] - The color for the icon and its background gradient.
  /// [additionalContent] - An optional list of widgets to display below the description.
  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    List<Widget>? additionalContent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconColor.withOpacity(0.2),
                      iconColor.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF103937),
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF14A66C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  stepNumber,
                  style: const TextStyle(
                    fontFamily: 'CovikSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF14A66C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            description,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xFF103937),
              height: 1.6,
            ),
          ),
          // Conditionally display additional content if it is provided.
          if (additionalContent != null) ...[
            const SizedBox(height: 12),
            ...additionalContent,
          ],
        ],
      ),
    );
  }

  /// A private helper method to build the color-coded freshness indicator row.
  ///
  /// Used within a `_buildStepCard` to show the possible results.
  ///
  /// [color] - The primary color for the indicator dot, border, and label.
  /// [label] - The freshness status text (e.g., "Fresh").
  /// [description] - A brief explanation of the status.
  Widget _buildFreshnessIndicator({
    required Color color,
    required String label,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF103937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the widget tree for the "How It Works" screen.
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
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A8E60),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: const Color(0xFF4A4A4A),
            iconSize: 20,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // --- Header Message ---
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF14A66C).withOpacity(0.1),
                        const Color(0xFF14A66C).withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF14A66C).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF14A66C),
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Follow these simple steps to check tilapia freshness',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xFF103937),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Step 1 ---
                _buildStepCard(
                  stepNumber: 'Step 1',
                  title: 'Take a Photo',
                  icon: Icons.camera_alt_rounded,
                  iconColor: const Color(0xFF14A66C),
                  description:
                  'Use your phone\'s camera within the app to snap a clear photo of the tilapia, or choose one from your gallery if you already have an image. Make sure the eyes and gills are clearly visible.',
                ),

                // --- Step 2 ---
                _buildStepCard(
                  stepNumber: 'Step 2',
                  title: 'Analyze Image',
                  icon: Icons.analytics_rounded,
                  iconColor: const Color(0xFF2196F3),
                  description:
                  'Tap the "Analyze Image" button. The app scans the photo and looks closely at two key freshness indicators:',
                  additionalContent: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.visibility_rounded,
                                color: Color(0xFF2196F3),
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Eye clarity',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Color(0xFF103937),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.palette_rounded,
                                color: Color(0xFF2196F3),
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Gill color',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Color(0xFF103937),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // --- Step 3 ---
                _buildStepCard(
                  stepNumber: 'Step 3',
                  title: 'View Result',
                  icon: Icons.assessment_rounded,
                  iconColor: const Color(0xFFFF9800),
                  description:
                  'See instant results in a simple, color-coded format:',
                  additionalContent: [
                    _buildFreshnessIndicator(
                      color: const Color(0xFF14A66C),
                      label: 'Fresh',
                      description: 'Good to eat',
                    ),
                    _buildFreshnessIndicator(
                      color: const Color(0xFFD66A4E),
                      label: 'Not Fresh',
                      description: 'Use with caution',
                    ),
                    _buildFreshnessIndicator(
                      color: const Color(0xFF735E59),
                      label: 'Old',
                      description: 'Avoid consuming',
                    ),
                    // --- ADDED THIS WIDGET ---
                    _buildFreshnessIndicator(
                      color: Colors.blueGrey,
                      label: 'No Tilapia Detected',
                      description: 'Eye or gill not found',
                    ),
                  ],
                ),

                // --- Step 4 ---
                _buildStepCard(
                  stepNumber: 'Step 4',
                  title: 'Retake If Needed',
                  icon: Icons.refresh_rounded,
                  iconColor: const Color(0xFF9C27B0),
                  description:
                  'Didn\'t get a clear shot? You can easily retake and reanalyze the photo for the best results.',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}