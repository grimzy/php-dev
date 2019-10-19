# PHP version and variant to build (defaults are latest)
ARG BUILD_PHP_VERSION=7.3
ARG BUILD_PHP_VARIANT=cli

FROM php:$BUILD_PHP_VERSION-$BUILD_PHP_VARIANT

# Copy PHP config
COPY php.ini /usr/local/etc/php/

ARG BUILD_XDEBUG_VERSION

# Install dependencies
# Install and enable xdebug and pdo mysql
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    && pecl install xdebug$BUILD_XDEBUG_VERSION \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-enable xdebug pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
    && rm -f /tmp/composer-setup.*
