##### Dev image
FROM php:8.3-fpm as dev

# Аргументи та змінні середовища
ARG APP_DIR=/var/www/html
ENV APP_DIR=$APP_DIR
ENV APP_ENV=dev
ENV PHP_INI_DIR=/usr/local/etc/php

WORKDIR $APP_DIR

# Встановлення системних залежностей
RUN apt-get update && \
    apt-get install -y \
        git \
        autoconf \
        gcc \
        g++ \
        make \
        openssh-client \
        openssl \
        bash \
        nano \
        supervisor \
        libicu-dev \
        libzip-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype-dev \
        libpq-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype-dev \
        librabbitmq-dev \
        libxslt1-dev \
        acl \
        nodejs \
        yarn \
        sudo \
        unzip \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Додавання віртуального середовища до PATH
ENV PATH="/opt/venv/bin:$PATH"

COPY devops/docker/php/php.ini /usr/local/etc/php/php.ini

# Створення Docker користувача
RUN adduser \
      --disabled-password \
      --gecos "" \
      --uid "1001" \
      "docker" && \
    adduser docker www-data && \
    echo "docker:docker" | chpasswd && \
    echo "docker  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Встановлення php розширень
RUN pecl install xdebug-3.4.1 apcu-5.1.22 amqp && \
    docker-php-ext-configure gd --with-freetype=/usr/lib --with-jpeg=/usr/lib && \
    docker-php-ext-install bcmath xsl intl pcntl zip pdo pdo_pgsql pgsql gd && \
    docker-php-ext-enable amqp apcu xsl xdebug pdo pdo_pgsql pgsql && \
    echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

## Встановлення composer
RUN curl -sS https://getcomposer.org/installer | php -- --2 --install-dir=/usr/local/bin --filename=composer

# Конфігурація Openssh
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ed25519_key && \
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa && \
    ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 && \
    mkdir -p /var/run/sshd \

# Створення Dir для PhpStorm
RUN mkdir -p /opt/.phpstorm_helpers && \
    chown docker:docker /opt/.phpstorm_helpers

# Configure local supervisord
RUN rm -f /etc/supervisord.conf
COPY devops/docker/supervisord/conf.local.conf /etc/supervisord.conf
RUN mkdir -p -m 777 /var/log/supervisor

COPY config/supervisord/supervisord.conf /tmp/supervisord.conf
COPY bin/set-permissions.sh /opt/set-permissions.sh
RUN cat /tmp/supervisord.conf >> /etc/supervisord.conf

# Set the HISTFILE environment variable
ENV HISTFILE=/root/.bash_history

# Ensure the directory exists and create the history file with the right permissions
RUN mkdir -p $(dirname $HISTFILE) && touch $HISTFILE && chown docker:docker $HISTFILE

# Права
RUN chown -R docker:docker /home/docker
RUN mkdir -p /var/run/supervisor && chmod 777 /var/run/supervisor
RUN chown -R docker:docker /var/run/supervisor /var/log/supervisor
RUN chmod 777 -R /var/log/

EXPOSE 9000

EXPOSE 22

ENTRYPOINT ["sudo", "-E", "/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

##### Prod image
FROM dev AS prod

ENV APP_ENV=prod
ENV APP_DEBUG=0
ENV PGSSLCERT /tmp/postgresql.crt

RUN docker-php-ext-install opcache

## Copy project files to workdir
COPY --chown=www-data:www-data . .

### Enable opcache
#COPY devops/docker/php/conf.d/opcache.ini /usr/local/etc/php/conf.d/10-opcache.ini
#RUN sed -i "s|\$APP_DIR|${APP_DIR}|g" /usr/local/etc/php/conf.d/10-opcache.ini

## Configure supervisord
#COPY devops/docker/supervisord/conf.conf /etc/supervisord.conf
#
### Remove dev dependencies
#USER www-data
#RUN composer install --no-dev --no-interaction --optimize-autoloader --classmap-authoritative --no-scripts

USER root

## Cleanup
RUN apk del dev-deps && \
    rm -rf /tmp/* /var/cache/apk/* /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]