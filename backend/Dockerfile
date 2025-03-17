FROM python:3.10

ENV PYTHONUNBUFFERED=1
ENV PORT=8000

WORKDIR /app

# Copy only the requirements file first, to leverage Docker cache
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . /app/

# Collect static files
RUN python manage.py collectstatic --noinput

# Run migrations
RUN python manage.py migrate

# Start gunicorn
CMD gunicorn backend.wsgi:application --bind 0.0.0.0:$PORT
