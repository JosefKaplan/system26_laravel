FROM php:8.4-cli

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    zip \
    git \
    libsqlite3-dev \
    libicu-dev \
    libzip-dev

# Install PHP extensions
RUN docker-php-ext-install \
    intl \
    bcmath \
    zip

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy project
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Create SQLite database if it doesn't exist
RUN touch database/database.sqlite

# Permissions
RUN chmod -R 775 storage bootstrap/cache

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000
