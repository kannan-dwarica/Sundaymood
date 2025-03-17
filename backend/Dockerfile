FROM node:18 AS frontend-builder
WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

FROM python:3.10

ENV PYTHONUNBUFFERED=1
ENV PORT=8000

WORKDIR /app

# Copy frontend build
COPY --from=frontend-builder /frontend/dist /app/staticfiles/frontend

# Copy only the requirements file first, to leverage Docker cache
COPY backend/requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY backend/ /app/

# Collect static files
RUN python manage.py collectstatic --noinput

# Run migrations
RUN python manage.py migrate

# Start gunicorn
CMD gunicorn backend.wsgi:application --bind 0.0.0.0:$PORT
