FROM python:3.9-slim

# Install PostgreSQL client
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create necessary directories
RUN mkdir -p static/uploads templates

COPY . .

# Ensure uploads directory exists and has proper permissions
RUN chmod 777 static/uploads

EXPOSE 8080

# CMD ["python", "app.py"]
# CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
# Run with Gunicorn (Cloud Run will set $PORT)

CMD python database.py && exec gunicorn --bind :$PORT app:app --workers 2 --threads 4 --timeout 0