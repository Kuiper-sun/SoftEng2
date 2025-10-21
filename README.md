---
title: SariwAI API
emoji: 🐟
colorFrom: green
colorTo: blue
sdk: docker
pinned: false
---

<div align="center">
  <h1>SariwAI Tilapia Freshness API 🐟</h1>
  <p>
    A backend API for the SariwAI mobile application that uses a DETR v2 model to detect the freshness of tilapia from an uploaded image.
  </p>
  <p>
    <img src="https://img.shields.io/badge/Python-3.9+-blue?logo=python" alt="Python Version">
    <img src="https://img.shields.io/badge/Flask-2.x-black?logo=flask" alt="Flask">
    <img src="https://img.shields.io/badge/%F0%9F%A4%97%20Hugging%20Face-Models-yellow" alt="Hugging Face Models">
    <img src="https://img.shields.io/badge/Docker-Ready-blue?logo=docker" alt="Docker Ready">
  </p>
</div>

## ► Features
-   **Health Check:** A `/healthz` endpoint to verify that the API is running.
-   **Image-based Prediction:** Accepts an image file and analyzes it for tilapia freshness.
-   **AI-Powered Detection:** Uses the `RT-DeTrv2` object detection model to identify the fish's eyes and gills.
-   **Clear Freshness Logic:** Determines the final freshness status (`Fresh`, `Not Fresh`, `Old`) based on the condition of both the eye and the gill.
-   **Robust Error Handling:** Provides clear JSON responses for missing files, incomplete detections, or internal server errors.

---

## ► How It Works

The API follows a simple but effective pipeline for each prediction request:
1.  **Image Upload:** The user sends a `POST` request with an image of a tilapia to the `/predict` endpoint.
2.  **Object Detection:** The image is passed to the `RT-DETR` model, which identifies the locations of the tilapia's **eye** and **gill** and their respective states (e.g., `Fresh_Eye`, `Not-Fresh_Gill`).
3.  **Best Detection Selection:** The API selects the highest-confidence detection for both the eye and the gill.
4.  **Freshness Rule Application:** A hierarchical rule is applied to determine the overall freshness. The final status is determined by the worst-rated component (e.g., if the eye is `Fresh` but the gill is `Old`, the final status will be `Old`).
5.  **JSON Response:** The API returns a detailed JSON object with the final status, the individual predictions for the eye and gill, and their confidence scores.

---

## ► API Documentation

### Health Check Endpoint
-   **URL:** `/healthz`
-   **Method:** `GET`
-   **Description:** Checks if the server is alive and running.
-   **Success Response (200 OK):**
    ```
    OK
    ```

### Prediction Endpoint
-   **URL:** `/predict`
-   **Method:** `POST`
-   **Description:** Analyzes an uploaded image of a tilapia and returns its freshness status.
-   **Request Body:** `multipart/form-data` with a single field:
    -   `file`: The image file (e.g., `.jpg`, `.png`).

#### Example Success Response (200 OK)
```json
{
  "status": "Not Fresh",
  "eye_prediction": "Fresh",
  "gill_prediction": "Not-Fresh",
  "eye_score": 0.9871,
  "gill_score": 0.9234
}
