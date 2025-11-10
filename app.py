import os
import time
from flask import Flask, request, jsonify
from transformers import AutoImageProcessor, AutoModelForObjectDetection
from PIL import Image
import torch

app = Flask(__name__)
# This should be your model's path on Hugging Face
MODEL_PATH = "Kuiper-sun/sariwai-rt-detr-v2" 

try:
    image_processor = AutoImageProcessor.from_pretrained(MODEL_PATH)
    model = AutoModelForObjectDetection.from_pretrained(MODEL_PATH)
    print("✅ Object Detection Model loaded successfully!")
except Exception as e:
    print(f"❌ Error loading model: {e}")
    exit()

def apply_freshness_rules(eye_status, gill_status):
    # This function now only runs if BOTH eye and gill are found.
    # The check for "Not Found" is handled before calling it.
    hierarchy = {'fresh': 0, 'not-fresh': 1, 'old': 2}
    
    eye_level = hierarchy.get(eye_status.lower().replace('_', '-'), -1)
    gill_level = hierarchy.get(gill_status.lower().replace('_', '-'), -1)

    final_level = max(eye_level, gill_level)

    if final_level == 0: return 'Fresh'
    elif final_level == 1: return 'Not Fresh'
    elif final_level == 2: return 'Old'
    else: return 'Undetermined' # Fallback, should not be reached with valid labels

@app.route('/healthz')
def healthz():
    return "OK", 200

@app.route('/predict', methods=['POST'])
def predict():
    start_time = time.time()

    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400

    try:
        image = Image.open(file.stream).convert("RGB")
        inputs = image_processor(images=image, return_tensors="pt")
        with torch.no_grad():
            outputs = model(**inputs)

        target_sizes = torch.tensor([image.size[::-1]])
        results = image_processor.post_process_object_detection(outputs, threshold=0.4, target_sizes=target_sizes)[0]

        print("\n" + "="*50)
        print("            STARTING NEW PREDICTION ANALYSIS")
        print("="*50)
        
        # This initial check remains the same. If the model sees absolutely nothing, it stops.
        if not results or not results["scores"].nelement():
             print("‼️  CRITICAL: The model detected NOTHING above the 0.4 threshold.")
             print("="*50 + "\n")
             return jsonify({
                'status': 'No Tilapia Detected',
                'eye_prediction': 'Not Found',
                'gill_prediction': 'Not Found',
                'eye_score': -1.0,
                'gill_score': -1.0,
            })

        print(f"✅  Model found {len(results['scores'])} potential objects:")
        
        best_eye = {'score': -1.0, 'status': 'Not Found'}
        best_gill = {'score': -1.0, 'status': 'Not Found'}

        for score, label_id, box in zip(results["scores"], results["labels"], results["boxes"]):
            label = model.config.id2label[label_id.item()]
            label_lower = label.lower()
            
            print(f"  - Detection: Label = '{label}', Confidence = {score.item():.4f}")
            
            if 'eye' in label_lower:
                if score > best_eye['score']:
                    best_eye['score'] = score.item()
                    # Ensures we get "fresh", "not-fresh", etc.
                    best_eye['status'] = label.rsplit('_', 1)[0]
                    print(f"    ✅ Valid EYE detection kept")
            elif 'gill' in label_lower:
                if score > best_gill['score']:
                    best_gill['score'] = score.item()
                    best_gill['status'] = label.rsplit('_', 1)[0]
                    print(f"    ✅ Valid GILL detection kept")
            else:
                print(f"    ❌ Ignored (not an eye or gill)")
        
        # --- MODIFICATION START ---
        # If either the eye or gill was not found, we now return "No Tilapia Detected".
        # This replaces the entire "Incomplete Detection" block.
        if best_eye['status'] == 'Not Found' or best_gill['status'] == 'Not Found':
            missing_parts = []
            if best_eye['status'] == 'Not Found': missing_parts.append("eye")
            if best_gill['status'] == 'Not Found': missing_parts.append("gill")
            
            print(f"‼️  CRITICAL: Detection failed. Missing: {' and '.join(missing_parts)}. Returning 'No Tilapia Detected'.")
            print("="*50 + "\n")
            
            return jsonify({
                'status': 'No Tilapia Detected', # Simplified status
                'eye_prediction': best_eye['status'],
                'gill_prediction': best_gill['status'],
                'eye_score': best_eye['score'],
                'gill_score': best_gill['score'],
                'message': f"Detection failed. Could not find: {', '.join(missing_parts)}."
            })
        # --- MODIFICATION END ---

        # If the code reaches here, it means BOTH an eye and a gill were found.
        # Now we can safely determine the final freshness status.
        final_status = apply_freshness_rules(best_eye['status'], best_gill['status'])
        
        end_time = time.time()
        duration = end_time - start_time

        print("\n--- Analysis Summary ---")
        print(f"Best Eye Found: {best_eye['status']} (Score: {best_eye['score']:.4f})")
        print(f"Best Gill Found: {best_gill['status']} (Score: {best_gill['score']:.4f})")
        print(f"Final Determined Status: {final_status}")
        print("-" * 20)
        print(f"⏱️  Total Execution Time: {duration:.4f} seconds")
        print("="*50 + "\n")

        return jsonify({
            'status': final_status,
            'eye_prediction': best_eye['status'],
            'gill_prediction': best_gill['status'],
            'eye_score': best_eye['score'],
            'gill_score': best_gill['score'],
        })

    except Exception as e:
        print(f"❌ An error occurred during prediction: {str(e)}")
        return jsonify({'error': f"An error occurred during prediction: {str(e)}"}), 500

if __name__ == '__main__':
    # The port needs to be 7860 for Hugging Face Spaces Gradio/Flask compatibility
    app.run(host='0.0.0.0', port=7860)