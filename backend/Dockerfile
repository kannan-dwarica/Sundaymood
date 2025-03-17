FROM node:18 AS frontend-builder
WORKDIR /build
# Copy frontend files from project root
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

FROM python:3.10

ENV PYTHONUNBUFFERED=1
ENV PORT=8000

WORKDIR /app

# Copy frontend build
COPY --from=frontend-builder /build/dist /app/staticfiles/frontend

# Copy backend files
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the backend
COPY backend/ .

# Collect static files
RUN python manage.py collectstatic --noinput

# Run migrations
RUN python manage.py migrate

# Start gunicorn
CMD gunicorn backend.wsgi:application --bind 0.0.0.0:$PORT
