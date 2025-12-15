FROM php:8.3-cli

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       git \
       unzip \
       libzip-dev \
    && docker-php-ext-install zip pdo pdo_sqlite \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose Render port
EXPOSE 10000

# Start Laravel
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=${PORT:-10000}

