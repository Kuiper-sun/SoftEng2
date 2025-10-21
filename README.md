# SariwAI Backend API Documentation

## Overview

The SariwAI backend is a Flask-based REST API that uses machine learning (specifically RT-DETR object detection model) to analyze tilapia fish images and determine freshness based on eye clarity and gill color detection.

---

## Table of Contents

1. [Technology Stack](#technology-stack)
2. [Model Information](#model-information)
3. [API Endpoints](#api-endpoints)
4. [Freshness Detection Logic](#freshness-detection-logic)
5. [Detection Workflow](#detection-workflow)
6. [Response Structures](#response-structures)
7. [Error Handling](#error-handling)
8. [Setup & Deployment](#setup--deployment)

---

## Technology Stack

### Core Framework
- **Flask** - Lightweight Python web framework
- **Python** - Backend programming language

### Machine Learning
- **PyTorch** - Deep learning framework
- **Transformers (Hugging Face)** - Model loading and processing
- **RT-DETR** - Real-Time Detection Transformer for object detection
- **PIL (Pillow)** - Image processing

### Model
- **Model Name:** `Kuiper-sun/sariwai-rt-detr-v2`
- **Type:** Object Detection
- **Architecture:** RT-DETR (Real-Time Detection Transformer)
- **Purpose:** Detect and classify tilapia eye and gill freshness states

---

## Model Information

### Model Components

```python
MODEL_PATH = "Kuiper-sun/sariwai-rt-detr-v2"

# Components loaded at startup:
image_processor = AutoImageProcessor.from_pretrained(MODEL_PATH)
model = AutoModelForObjectDetection.from_pretrained(MODEL_PATH)
```

### Detection Classes

The model is trained to detect 6 distinct classes:

#### Eye Classifications
1. **Fresh_eye** - Clear, bright eyes
2. **Not-fresh_eye** - Slightly cloudy eyes
3. **Old_eye** - Opaque, dull eyes

#### Gill Classifications
4. **Fresh_gill** - Bright red/pink gills
5. **Not-fresh_gill** - Brownish gills
6. **Old_gill** - Gray/brown gills

### Detection Parameters

- **Confidence Threshold:** 0.4 (40%)
- **Processing:** Runs inference without gradient computation (`torch.no_grad()`)
- **Input Format:** RGB images
- **Output:** Bounding boxes, labels, and confidence scores

---

## API Endpoints

### 1. Health Check Endpoint

**Endpoint:** `/healthz`  
**Method:** `GET`  
**Purpose:** Check if the API service is running

**Response:**
```
Status: 200 OK
Body: "OK"
```

**Use Case:** Container orchestration health checks, monitoring systems

---

### 2. Prediction Endpoint

**Endpoint:** `/predict`  
**Method:** `POST`  
**Content-Type:** `multipart/form-data`  
**Purpose:** Analyze tilapia image for freshness

#### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| file | File | Yes | Image file (JPEG, PNG, etc.) |

#### Request Example

```bash
curl -X POST http://localhost:5000/predict \
  -F "file=@tilapia_image.jpg"
```

#### Response Codes

| Code | Description |
|------|-------------|
| 200 | Success - Analysis completed |
| 400 | Bad Request - Missing file or invalid input |
| 500 | Server Error - Processing error |

---

## Freshness Detection Logic

### Freshness Hierarchy

The system uses a hierarchical approach where the worst condition determines the overall status:

```python
hierarchy = {
    'fresh': 0,      # Best condition
    'not-fresh': 1,  # Medium condition
    'old': 2         # Worst condition
}
```

### Freshness Rules (`apply_freshness_rules` function)

#### Rule 1: Both Detections Required (Critical)
```
If eye NOT detected OR gill NOT detected:
    Return "Incomplete Detection"
```

#### Rule 2: Take Worst Condition
```
final_level = max(eye_level, gill_level)

If final_level == 0: Return "Fresh"
If final_level == 1: Return "Not Fresh"
If final_level == 2: Return "Old"
```

### Logic Examples

| Eye Status | Gill Status | Final Status | Reasoning |
|------------|-------------|--------------|-----------|
| Fresh | Fresh | **Fresh** | Both are fresh |
| Fresh | Not-fresh | **Not Fresh** | Worst condition wins |
| Not-fresh | Old | **Old** | Worst condition wins |
| Fresh | Not Found | **Incomplete Detection** | Missing gill |
| Not Found | Fresh | **Incomplete Detection** | Missing eye |
| Not Found | Not Found | **Incomplete Detection** | Both missing |

---

## Detection Workflow

### Step-by-Step Process

```
1. Receive Image Upload
   ↓
2. Validate Request (file present?)
   ↓
3. Preprocess Image (image_processor)
   ↓
4. Run Model Inference (model forward pass)
   ↓
5. Post-process Detections (filter by threshold)
   ↓
6. Parse Results
   ├─→ Find best eye detection
   └─→ Find best gill detection
   ↓
7. Validate Both Detected
   ↓
8. Apply Freshness Rules
   ↓
9. Return JSON Response
```

### Detection Processing Logic

```python
# For each detection above threshold (0.4):
for score, label_id, box in zip(results["scores"], results["labels"], results["boxes"]):
    label = model.config.id2label[label_id.item()]
    
    # Check if it's an eye detection
    if 'eye' in label.lower():
        if score > best_eye['score']:
            best_eye['score'] = score.item()
            best_eye['status'] = label.rsplit('_', 1)[0]  # Extract freshness state
    
    # Check if it's a gill detection
    elif 'gill' in label.lower():
        if score > best_gill['score']:
            best_gill['score'] = score.item()
            best_gill['status'] = label.rsplit('_', 1)[0]  # Extract freshness state
```

**Key Points:**
- Only the **highest confidence** eye detection is kept
- Only the **highest confidence** gill detection is kept
- Non-eye/gill detections are ignored
- Label format: `{freshness}_{part}` (e.g., "Fresh_eye")

---

## Response Structures

### Successful Analysis Response

```json
{
  "status": "Fresh",
  "eye_prediction": "Fresh",
  "gill_prediction": "Fresh",
  "eye_score": 0.8542,
  "gill_score": 0.9123
}
```

### Incomplete Detection Response

**Scenario:** Missing eye, gill, or both

```json
{
  "status": "Incomplete Detection",
  "eye_prediction": "Fresh",
  "gill_prediction": "Not Found",
  "eye_score": 0.7834,
  "gill_score": -1.0,
  "message": "Both eye and gill must be detected. Missing: gill"
}
```

### No Fish Detected Response

**Scenario:** No detections above threshold

```json
{
  "status": "No Fish Detected",
  "eye_prediction": "Not Found",
  "gill_prediction": "Not Found",
  "eye_score": -1.0,
  "gill_score": -1.0
}
```

### Error Response

```json
{
  "error": "An error occurred during prediction: <error_message>"
}
```

---

## Response Field Definitions

| Field | Type | Description | Possible Values |
|-------|------|-------------|-----------------|
| `status` | string | Overall freshness determination | "Fresh", "Not Fresh", "Old", "No Fish Detected", "Incomplete Detection", "Undetermined" |
| `eye_prediction` | string | Eye freshness state | "Fresh", "Not-fresh", "Old", "Not Found" |
| `gill_prediction` | string | Gill freshness state | "Fresh", "Not-fresh", "Old", "Not Found" |
| `eye_score` | float | Confidence score for eye (0-1) | -1.0 (not found) or 0.0-1.0 (confidence) |
| `gill_score` | float | Confidence score for gill (0-1) | -1.0 (not found) or 0.0-1.0 (confidence) |
| `message` | string | Additional info (optional) | Explanation for incomplete detection |
| `error` | string | Error message (on failure) | Description of what went wrong |

---

## Error Handling

### Client Errors (400)

#### Missing File
```json
{
  "error": "No file part in the request"
}
```

#### Empty Filename
```json
{
  "error": "No file selected"
}
```

### Server Errors (500)

#### Processing Exception
```json
{
  "error": "An error occurred during prediction: <detailed_error>"
}
```

### Model Loading Errors

If the model fails to load at startup:
```
❌ Error loading model: <error_message>
<application exits>
```

---

## Logging & Monitoring

### Console Output Format

#### Startup
```
✅ Object Detection Model loaded successfully!
```

#### Prediction Analysis
```
==================================================
            STARTING NEW PREDICTION ANALYSIS
==================================================
✅  Model found 2 potential objects:
  - Detection: Label = 'Fresh_eye', Confidence = 0.8542
    ✅ Valid EYE detection kept
  - Detection: Label = 'Fresh_gill', Confidence = 0.9123
    ✅ Valid GILL detection kept

--- Analysis Summary ---
Best Eye Found: Fresh (Score: 0.8542)
Best Gill Found: Fresh (Score: 0.9123)
Final Determined Status: Fresh
--------------------
⏱️  Total Execution Time: 1.2340 seconds
==================================================
```

#### Critical Scenarios

**No Detections:**
```
‼️  CRITICAL: The model detected NOTHING above the 0.4 threshold.
```

**Incomplete Detection:**
```
‼️  CRITICAL: Incomplete detection - Missing eye and gill
```

### Performance Metrics

Each request logs:
- Number of objects detected
- Individual detection labels and scores
- Best eye/gill selections
- Final status determination
- **Total execution time** (start to finish)

---

## Setup & Deployment

### Prerequisites

```bash
# Python version
Python 3.8+

# Required packages
pip install flask
pip install transformers
pip install torch
pip install pillow
```

### Installation

```bash
# Clone repository
git clone <repository_url>
cd sariwai-backend

# Install dependencies
pip install -r requirements.txt

# The model will be downloaded automatically on first run
```

### Running Locally

```bash
python app.py
```

**Server Configuration:**
- Host: `0.0.0.0` (accessible from all network interfaces)
- Port: `5000`
- Debug Mode: Off (production-ready)

### Environment Variables (Optional)

```bash
# Custom model path
export MODEL_PATH="your-username/your-model-name"

# Custom port
export PORT=8080
```

### Docker Deployment

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

### Hugging Face Spaces Deployment

The API is currently deployed at:
```
https://kuiper-sun-sariwai-api.hf.space
```

**Deployment Features:**
- Automatic scaling
- Cold start handling (60-second timeout in frontend)
- Health check endpoint for monitoring
- HTTPS enabled

---

## API Usage Examples

### Python (requests)

```python
import requests

url = "http://localhost:5000/predict"
files = {'file': open('tilapia.jpg', 'rb')}

response = requests.post(url, files=files)
result = response.json()

print(f"Status: {result['status']}")
print(f"Eye: {result['eye_prediction']} ({result['eye_score']:.2%})")
print(f"Gill: {result['gill_prediction']} ({result['gill_score']:.2%})")
```

### JavaScript (fetch)

```javascript
const formData = new FormData();
formData.append('file', fileInput.files[0]);

fetch('http://localhost:5000/predict', {
  method: 'POST',
  body: formData
})
.then(response => response.json())
.then(data => {
  console.log('Status:', data.status);
  console.log('Eye:', data.eye_prediction, data.eye_score);
  console.log('Gill:', data.gill_prediction, data.gill_score);
});
```

### cURL

```bash
curl -X POST http://localhost:5000/predict \
  -F "file=@/path/to/tilapia.jpg" \
  -H "Accept: application/json"
```

---

## Performance Considerations

### Model Inference Time

- **Average:** 1-2 seconds per image
- **Cold Start:** 5-10 seconds (first request after deployment)
- **Factors:** Image size, model complexity, hardware

### Optimization Tips

1. **Batch Processing:** Process multiple images in sequence
2. **Image Preprocessing:** Resize large images before upload
3. **Caching:** Consider caching results for identical images
4. **GPU Acceleration:** Deploy on GPU-enabled infrastructure for faster inference

---

## Limitations & Known Issues

### Current Limitations

1. **Single Image Processing:** API processes one image per request
2. **Detection Requirement:** Both eye AND gill must be visible
3. **Confidence Threshold:** Fixed at 0.4 (not configurable via API)
4. **Image Format:** Must be readable by PIL (JPEG, PNG, etc.)
5. **Model Scope:** Trained specifically for tilapia fish

---

## Troubleshooting

### Common Issues

#### Model Not Loading
```
❌ Error loading model: <error>
```
**Solution:** Check internet connection, verify model name, ensure sufficient disk space

#### No Detections
```
‼️  CRITICAL: The model detected NOTHING above the 0.4 threshold.
```
**Solution:** Ensure image shows tilapia clearly, check lighting, verify eye/gill visibility

#### Incomplete Detection
```
status: "Incomplete Detection"
```
**Solution:** Retake photo ensuring both eye and gill are visible and in focus

#### Timeout Errors
**Solution:** Increase timeout in frontend (default: 60s), check network stability


