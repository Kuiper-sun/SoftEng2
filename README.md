# SariwAI Frontend Documentation

## Overview

SariwAI is a Flutter mobile application that helps users determine the freshness of tilapia fish by analyzing visual indicators from captured or uploaded images. The app uses machine learning to evaluate eye clarity and gill color to assess fish freshness.

---

## Table of Contents

1. [Project Structure](#project-structure)
2. [Main Application Entry](#main-application-entry)
3. [Screen Components](#screen-components)
4. [API Integration](#api-integration)
5. [Color Scheme & Styling](#color-scheme--styling)
6. [Dependencies](#dependencies)

---

## Project Structure

```
lib/
├── main.dart
└── screens/
    ├── welcome.dart
    ├── howitworks.dart
    ├── camera.dart
    ├── imagepreview.dart
    └── result.dart
```

---

## Main Application Entry

### `main.dart`

The entry point of the application that configures routing and theme.

**Key Features:**
- Material Design theme with custom color scheme
- Route-based navigation system
- Custom font family (Inter, CovikSans)
- Debug banner disabled

**Routes:**
- `/` - Welcome Screen
- `/howitworks` - How It Works Screen
- `/camera` - Camera/Image Import Screen
- `/result` - Result Display Screen

---

## Screen Components

### 1. Welcome Screen (`welcome.dart`)

**Purpose:** Landing page with app introduction and call-to-action.

**Features:**
- Animated entrance with fade and slide effects
- Gradient text effects for branding
- Hover effects on the "Get Started" button
- Informational card describing the app's functionality
- Link to "How It Works" guide

**Key Components:**
- `AnimationController` for entrance animations
- `FadeTransition` and `SlideTransition` for smooth UI reveal
- `MouseRegion` for desktop hover interactions
- Gradient `ShaderMask` for styled text

**Navigation:**
- Get Started → `/camera`
- How it works → `/howitworks`

---

### 2. How It Works Screen (`howitworks.dart`)

**Purpose:** Educational guide explaining the app's analysis process.

**Features:**
- Step-by-step visual guide with 4 main steps
- Color-coded freshness indicators
- Custom card components for each step
- Informational header with app usage tips

**Step Breakdown:**

#### Step 1: Take a Photo
- Icon: Camera
- Action: Capture or upload tilapia image
- Requirements: Clear visibility of eyes and gills

#### Step 2: Analyze Image
- Icon: Analytics
- Key Indicators:
  - Eye clarity
  - Gill color

#### Step 3: View Result
- Icon: Assessment
- Freshness Categories:
  - **Fresh** (Green) - Good to eat
  - **Not Fresh** (Orange) - Use with caution
  - **Old** (Brown) - Avoid consuming

#### Step 4: Retake If Needed
- Icon: Refresh
- Option to retake unclear photos

**Custom Widgets:**
- `_buildStepCard()` - Displays each analysis step
- `_buildFreshnessIndicator()` - Shows color-coded freshness levels

---

### 3. Camera Screen (`camera.dart`)

**Purpose:** Image selection interface for camera or gallery.

**Features:**
- Two image source options:
  - Camera capture
  - Gallery selection
- Hover effects on action buttons
- Clean, minimalist UI with centered icon

**Key Functions:**
- `_pickImage(ImageSource source)` - Handles image selection
- Uses `ImagePicker` package for media access
- Navigates to `ImagePreviewScreen` on successful selection

**Error Handling:**
- Try-catch block for image selection errors
- Console logging for debugging

---

### 4. Image Preview Screen (`imagepreview.dart`)

**Purpose:** Display selected image and trigger ML analysis.

**Features:**
- Full-screen image preview with black background
- Navigation controls (back and close buttons)
- "Analyze Image" button with loading state
- HTTP multipart request to ML API

**API Integration:**

**Endpoint:** `https://kuiper-sun-sariwai-api.hf.space/predict`

**Request:**
- Method: POST
- Content-Type: multipart/form-data
- File field: `file`
- Format: image/jpeg
- Timeout: 60 seconds (for cold starts)

**Response Structure:**
```json
{
  "status": "Fresh|Not Fresh|Old|No Fish Detected|Incomplete Detection",
  "eye_prediction": "string",
  "gill_prediction": "string",
  "eye_score": 0.0-1.0,
  "gill_score": 0.0-1.0
}
```

**Key Functions:**
- `_analyzeImage()` - Sends image to API and processes response
- Handles loading states and error scenarios
- Uses `Navigator.pushReplacement` for result screen

**Error Handling:**
- Network timeout management
- Server error responses
- Connection failure notifications via SnackBar

---

### 5. Result Screen (`result.dart`)

**Purpose:** Display analysis results with detailed breakdown.

**Features:**
- Full-screen image display
- Color-coded status badge
- Detailed analysis breakdown (when applicable)
- Prediction scores with percentages
- Option to analyze another fish

**Status Categories:**

| Status | Color | Description |
|--------|-------|-------------|
| Fresh | Green (#14A66C) | Good to eat |
| Not Fresh | Orange (#D66A4E) | Use with caution |
| Old | Brown (#735E59) | Avoid consuming |
| No Fish Detected | Blue Grey | No tilapia detected |
| Incomplete Detection | Orange (#FF8C00) | Missing eye or gill |

**Display Logic:**
- Shows detailed analysis only for: Fresh, Not Fresh, Old
- For incomplete/no detection: Shows warning message
- Percentage scores displayed when available

**Analysis Details Card:**
- Eye prediction with confidence score
- Gill prediction with confidence score
- Status description text

**Navigation:**
- Back button → Returns to previous screen
- Close button → Returns to home
- "Analyze Another Fish" → Returns to camera screen

---

## API Integration

### Request Flow

1. User selects image (camera/gallery)
2. Image displayed in preview screen
3. User taps "Analyze Image"
4. Loading state activated
5. Image uploaded via multipart POST request
6. Response parsed and validated
7. User navigated to result screen with data

### Error Scenarios

- **Network Timeout:** 60-second timeout for slow connections
- **Server Error:** Status code ≠ 200
- **Invalid Response:** Missing required fields (uses default values)
- **Connection Failure:** Network unavailable

### Data Validation

- Default values for missing scores: `0.0`
- Default values for missing predictions: `'Not Found'`
- Default status: `'Error'`

---

## Color Scheme & Styling

### Primary Colors

```dart
Primary Green: #14A66C
Dark Green: #0A3932
Light Green: #77FFC9
Background: #F8F8F8
Text Dark: #103937
Text Medium: #4A4A4A
```

### Status Colors

```dart
Fresh: #14A66C
Not Fresh: #D66A4E
Old: #735E59
```

### Typography

**Font Families:**
- **CovikSans** - Used for titles, buttons, and bold text
- **Inter** - Used for body text and descriptions

**Text Styles:**
- Headers: Bold, 18-22px
- Body: Regular, 15-16px
- Buttons: Bold, 16-18px

### UI Components

**Buttons:**
- Border radius: 12px
- Padding: 16px vertical, 24px horizontal
- Elevation: 0-2px

**Cards:**
- Border radius: 16-20px
- Shadow: Black with 5% opacity, 15px blur
- Background: White on light gray background

---

## Dependencies

### Required Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^latest  # Image selection from camera/gallery
  http: ^latest          # HTTP requests
  http_parser: ^latest   # Content-Type parsing
```

### Platform Permissions

**iOS (Info.plist):**
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to capture tilapia images</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select tilapia images</string>
```

**Android (AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## Navigation Flow

```
Welcome Screen (/)
    ↓
    ├─→ How It Works (/howitworks) ─→ Back to Welcome
    │
    └─→ Camera Screen (/camera)
            ↓
        Image Preview
            ↓
        Result Screen (/result)
            ↓
            ├─→ Back (returns to preview)
            ├─→ Close (returns to home)
            └─→ Analyze Another (returns to camera)
```

---

## Key Features Summary

1. **User-Friendly Interface:** Clean, modern design with intuitive navigation
2. **Educational Content:** Step-by-step guide for users
3. **Real-Time Analysis:** ML-powered freshness detection
4. **Multiple Input Methods:** Camera capture or gallery selection
5. **Detailed Results:** Confidence scores and visual feedback
6. **Error Handling:** Comprehensive error management and user feedback
7. **Responsive Design:** Adapts to different screen sizes
8. **Smooth Animations:** Professional entrance effects and transitions

---

## Future Enhancements

Potential improvements for future versions:
- Offline mode with cached results
- Multi-language support
- History of analyzed fish
- Share results functionality
- Advanced filtering options
- Camera guides/overlays for better photo capture

---

## Development Notes

- Uses StatefulWidget for screens requiring state management
- StatelessWidget for static content screens
- Proper error handling with try-catch blocks
- Loading states for async operations
- Proper navigation stack management
- Responsive image sizing
- Accessibility considerations with semantic widgets

---

## Contact & Support

For technical issues or questions about the app, refer to the main project documentation or contact the development team.
