FROM richarvey/nginx-php-fpm:1.9.1

COPY . .

# Image config
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Laravel config
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr

# Allow composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN rm -rf vendor composer.lock
RUN composer install --no-interaction --optimize-autoloader --no-dev
# Optimizing Configuration loading
RUN php artisan config:cache
# Optimizing View loading
RUN php artisan view:cache
# Cache the framework bootstrap files
RUN php artisan optimize
# Create a symbolic link from public/storage to storage/app/public
RUN php artisan storage:link
