#
# Dockerfile for the Tilapia Freshness Detection API
#
# This file describes the steps to build a Docker container image for the backend application.
# It uses a multi-stage build to create a lean, secure, and efficient final image.
#

# --- Stage 1: Builder ---
# In this stage, we install all dependencies, including any that are only
# needed to build the application (e.g., compilers). This keeps the
# final image smaller.
FROM python:3.9-slim AS builder

# Set the working directory inside the container
WORKDIR /app

# Set environment variables to improve build efficiency and security
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copy only the requirements file first to leverage Docker's build cache.
# This step will only be re-run if requirements.txt changes.
COPY requirements.txt .

# Install dependencies into a virtual environment within the builder stage.
# Using --no-cache-dir reduces layer size. The --prefix option makes the
# environment portable, so we can copy it to the next stage.
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

# --- Stage 2: Final Image ---
# This is the actual image that will be deployed. It is built to be as
# small and secure as possible.
FROM python:3.9-slim

# Set the working directory for the final image
WORKDIR /app

# Copy the virtual environment with all installed dependencies from the builder stage.
# This is much faster and more reliable than running pip install again.
COPY --from=builder /opt/venv /opt/venv

# Copy the application source code into the final image.
# This step happens after dependency installation, so changes to the code
# won't cause the dependencies to be re-installed.
COPY . .

# Create a non-root user to run the application for better security.
# The application code is copied before this, so we can set correct ownership.
RUN useradd -m -u 1000 user && chown -R user:user /app
USER user

# Set the environment variables for the final container.
# This ensures the application uses the correct Python environment and cache directory.
ENV PATH="/opt/venv/bin:$PATH"
ENV TRANSFORMERS_CACHE="/home/user/.cache"

# Expose the port the application will run on. This is good practice for documentation.
EXPOSE 7860

# The command to run the application using Gunicorn.
CMD ["gunicorn", "--bind", "0.0.0.0:7860", "app:app"]