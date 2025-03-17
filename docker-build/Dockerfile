# --- Stage 1: Build Stage ---
FROM python:3.10-slim AS builder

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# -------- Stage 2: Runtime Stage --------
FROM python:3.10-slim

# Set environment variables (optional best practice)
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy files from the build stage
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY app.py .

# Expose the port Flask will run on
EXPOSE 5001

# Set environment variable for AWS_SECRET_KEY (optional at runtime)
# ENV AWS_SECRET_KEY=your_default_value_here

# Run the app
CMD ["python", "app.py"]