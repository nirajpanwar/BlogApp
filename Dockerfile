FROM python:3.10-slim

# Install required system packages
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libfreetype6-dev \
    libpq-dev \
    pkg-config \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Python deps first for better layer caching
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . .

# Collect static files inside image
#RUN python manage.py collectstatic --noinput

# Django-environ will read .env automatically if this is set
ENV DJANGO_READ_DOT_ENV_FILE=True

# Expose Gunicorn port
EXPOSE 8000

# Gunicorn start command
CMD ["gunicorn", "blog_project.wsgi:application", "--bind", "0.0.0.0:8000"]
