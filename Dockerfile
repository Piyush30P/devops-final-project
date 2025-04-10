# Use Python 3.9 slim as the base image - smaller than the standard image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Prevents Python from writing pyc files
ENV PYTHONDONTWRITEBYTECODE=1
# Keeps Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY service/ ./service/
COPY setup.cfg .

# Expose port 8080 (the port your app runs on)
EXPOSE 8080

# Health check to verify the application is running correctly
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Command to run the application
CMD ["python", "-m", "service.app"]
