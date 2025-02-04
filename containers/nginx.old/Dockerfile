FROM nginx:latest

RUN rm /etc/nginx/conf.d/default.conf

RUN apt-get update && apt-get install -y \
    curl \
    git \
    nano

# Copy custom configuration
COPY hosts/amefa4.nginx /etc/nginx/sites-available/
COPY config/nginx.conf /etc/nginx/

RUN usermod -u 1000 www-data
