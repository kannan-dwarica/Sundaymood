FROM node:18 AS frontend-builder
WORKDIR /build
# Copy frontend files
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build
RUN ls -la dist/

FROM python:3.10

ENV PYTHONUNBUFFERED=1
ENV PORT=8000

WORKDIR /app

# Copy frontend build and verify
COPY --from=frontend-builder /build/dist /app/staticfiles/frontend
RUN ls -la /app/staticfiles/frontend

# Copy backend files
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn

# Copy the rest of the backend
COPY backend/ .

# Debug: Show directory structure
RUN echo "=== Directory Structure ===" && \
    ls -R /app/staticfiles && \
    echo "=== Frontend Files ===" && \
    ls -la /app/staticfiles/frontend

# Collect static files
RUN python manage.py collectstatic --noinput

# Start gunicorn (using full path)
CMD ["/usr/local/bin/gunicorn", "backend.wsgi:application", "--bind", "0.0.0.0:$PORT"]
