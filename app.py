"""
Program Title: Tilapia Freshness Detection API
Programmers: [Kieferson Carl Supnet]
Where the program fits: This is the backend server for the mobile application. It exposes
                        a single API endpoint to analyze images of tilapia and determine
                        their freshness based on an object detection model.
Date written: 2025-11-14
Date revised: 2025-11-14
Purpose: This script launches a Flask web server that loads a pre-trained
         transformer model from Hugging Face. It provides a '/predict'
         endpoint that accepts an image file, performs object detection
         to find the fish's eye and gill, and returns a JSON response with
         the freshness classification ('Fresh', 'Not Fresh', 'Old', or
         'No Tilapia Detected').
Data structures, algorithms, and control:
         - Data Structures: Dictionaries are used to store detection results and confidence scores.
         - Algorithms: Uses the RT-DETR (Real-Time Detection Transformer) model for object detection.
                       A rule-based algorithm ('apply_freshness_rules') determines the final
                       freshness level by taking the worst of the eye and gill classifications.
         - Control Flow: The Flask framework routes HTTP requests. The '/predict' endpoint
                       contains the main control flow: file validation, image processing,
                       model inference, result post-processing, and JSON response generation.
"""

import os
import time
from flask import Flask, request, jsonify
from transformers import AutoImageProcessor, AutoModelForObjectDetection
from PIL import Image
import torch

# --- Configuration Constants ---
MODEL_PATH = "Kuiper-sun/sariwai-rt-detr-v2"
CONFIDENCE_THRESHOLD = 0.4

# --- Flask App Initialization ---
app = Flask(__name__)

# --- Model Loading ---
try:
    image_processor = AutoImageProcessor.from_pretrained(MODEL_PATH)
    model = AutoModelForObjectDetection.from_pretrained(MODEL_PATH)
except Exception as e:
    print(f"CRITICAL ERROR: Failed to load object detection model. Reason: {e}")
    exit()

def apply_freshness_rules(eye_status, gill_status):
    """
    Determines the final freshness status based on eye and gill classifications.
    """
    hierarchy = {'fresh': 0, 'not-fresh': 1, 'old': 2}
    eye_level = hierarchy.get(eye_status.lower().replace('_', '-'), -1)
    gill_level = hierarchy.get(gill_status.lower().replace('_', '-'), -1)
    final_level = max(eye_level, gill_level)

    if final_level == 0:
        return 'Fresh'
    if final_level == 1:
        return 'Not Fresh'
    if final_level == 2:
        return 'Old'
    return 'Undetermined'

# --- API Endpoints ---

@app.route('/healthz')
def healthz():
    """A simple health check endpoint to confirm the server is running."""
    return "OK", 200

@app.route('/predict', methods=['POST'])
def predict():
    """
    Handles the image upload and prediction process.
    """
    start_time = time.time()

    # 1. Validate the incoming request
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400

    try:
        # 2. Process the image and run model inference
        image = Image.open(file.stream).convert("RGB")
        inputs = image_processor(images=image, return_tensors="pt")

        with torch.no_grad(): # Disables gradient calculation for faster inference
            outputs = model(**inputs)

        # 3. Post-process the model output to get human-readable results
        target_sizes = torch.tensor([image.size[::-1]])
        results = image_processor.post_process_object_detection(
            outputs,
            threshold=CONFIDENCE_THRESHOLD,
            target_sizes=target_sizes
        )[0]

        # 4. Analyze detection results to find the best eye and gill
        if not results or not results["scores"].nelement():
            return jsonify({
                'status': 'No Tilapia Detected',
                'message': f'Model did not detect any objects with confidence > {CONFIDENCE_THRESHOLD}.'
            })

        best_eye = {'score': -1.0, 'status': 'Not Found'}
        best_gill = {'score': -1.0, 'status': 'Not Found'}

        for score, label_id in zip(results["scores"], results["labels"]):
            label = model.config.id2label[label_id.item()]
            label_lower = label.lower()

            if 'eye' in label_lower and score > best_eye['score']:
                best_eye['score'] = score.item()
                best_eye['status'] = label.rsplit('_', 1)[0] # Extracts status like "fresh" from "fresh_eye"
            elif 'gill' in label_lower and score > best_gill['score']:
                best_gill['score'] = score.item()
                best_gill['status'] = label.rsplit('_', 1)[0]

        # 5. Determine final status and construct the response
        if best_eye['status'] == 'Not Found' or best_gill['status'] == 'Not Found':
            missing_parts = [p for p, s in [("eye", best_eye), ("gill", best_gill)] if s['status'] == 'Not Found']
            return jsonify({
                'status': 'No Tilapia Detected',
                'eye_prediction': best_eye['status'],
                'gill_prediction': best_gill['status'],
                'eye_score': best_eye['score'],
                'gill_score': best_gill['score'],
                'message': f"Detection failed. Could not find: {', '.join(missing_parts)}."
            })

        final_status = apply_freshness_rules(best_eye['status'], best_gill['status'])

        return jsonify({
            'status': final_status,
            'eye_prediction': best_eye['status'],
            'gill_prediction': best_gill['status'],
            'eye_score': best_eye['score'],
            'gill_score': best_gill['score'],
            'execution_time_seconds': time.time() - start_time
        })

    except Exception as e:
        # Catch any unexpected errors during the process.
        return jsonify({'error': f"An internal error occurred: {str(e)}"}), 500

# --- Application Entry Point ---
if __name__ == '__main__':
    # '0.0.0.0' makes the server accessible from any IP address.
    app.run(host='0.0.0.0', port=7860)