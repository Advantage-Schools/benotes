FROM php:8.1-fpm-alpine

LABEL mantainer="github.com/fr0tt"
LABEL description="Benotes"

ENV user application

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apk --no-cache update && apk --no-cache add \
    git \
    curl \
    curl-dev \
    zlib-dev \
    libpng-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libxml2-dev \
    libmcrypt-dev \
    libpq \
    postgresql-dev \
    sqlite \
    zip \
    unzip \
    libzip-dev \
    libmcrypt-dev \
    openssl

RUN docker-php-ext-configure gd \
    --enable-gd \
    --with-jpeg

RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mysqli \
    pgsql \
    pdo_pgsql \
    opcache \
    exif \
    pcntl \
    bcmath \
    gd \
    curl \
    dom \
    xml


COPY ./docker/nginx/default.conf /etc/nginx/sites-enabled/default
COPY ./docker/entrypoint.sh /entrypoint.d/app_entrypoint.sh

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy code to /var/www
COPY --chown=www:www-data . /var/www

# add root to www group
RUN chmod -R ug+w /var/www/storage

WORKDIR /var/www

RUN chown -R $user:www-data storage && chmod -R 775 storage


USER $user


ARG USE_COMPOSER
RUN if [ "$USE_COMPOSER" = "true" ] ; \
    then \
    composer install --prefer-dist --no-interaction ; \
    fi

USER root


ARG INSTALL_NODE
RUN if [ "$INSTALL_NODE" = "true" ] ; \
    then \
    apk --no-cache add nodejs npm ; \
    fi

# will be overriden by the bind mount - if used
RUN ln -snf ../storage/app/public/ public/storage
