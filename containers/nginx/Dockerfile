FROM nginx:latest

# Copy custom configuration
COPY config/nginx.conf /etc/nginx/

RUN rm /etc/nginx/conf.d/default.conf || true

RUN apt-get update && apt-get install -y \
    curl \
    nano

RUN usermod -u 1000 www-data
