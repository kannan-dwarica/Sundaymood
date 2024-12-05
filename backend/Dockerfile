FROM python:3.10
WORKDIR /app
# Copy only the requirements file first, to leverage Docker cache
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app/
CMD [ "python", "manage.py", "runserver", "0.0.0.0:8000"]

ENV PYTHONUNBUFFERED 1
CMD ["gunicorn", "project.wsgi:application", "--bind", "0.0.0.0:8000"]
