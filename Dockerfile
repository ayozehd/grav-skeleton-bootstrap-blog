FROM alpine:3.12

LABEL Maintainer="Ayoze Hernandez Diaz <ayoze.dev@gmail.com> (@ayozehd)" \
      Description="Container based on trafex/alpine-nginx-php7 to run a Grav app"

# Install packages and remove default server definition
RUN apk --no-cache add php7 php7-fpm php7-opcache php7-mysqli php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype php7-session \
    php7-mbstring php7-zip php7-gd nginx supervisor curl git && \
    rm /etc/nginx/conf.d/default.conf

# Configure nginx
COPY docker/config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY docker/config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY docker/config/php.ini /etc/php7/conf.d/custom.ini

# Configure supervisord
COPY docker/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html /data/letsencrypt

# Set Grav version on .env
ENV GRAV_VERSION 1.6.26

# Download Grav from GitHub
RUN git clone -b ${GRAV_VERSION} https://github.com/getgrav/grav.git /var/www/html

# Copy skeleton
COPY . /var/www/html/user

WORKDIR /var/www/html

# Install Grav dependencies + admin
RUN bin/grav install
RUN bin/gpm install admin -y

# ENV GRAV_PLUGINS "quark pagination feed archives breadcrumbs simplesearch sitemap feed taxonomylist"

# # Install Grav Plugins or Themes
# RUN bin/gpm install \
#     ${GRAV_PLUGINS} \
#     -y

# Create New User. 
# For more information, see https://github.com/getgrav/grav-plugin-login
ENV ADMIN_USER admin
ENV ADMIN_PASSWORD Gravity0
ENV ADMIN_EMAIL admin@example.com
ENV ADMIN_PERMISSIONS b
ENV ADMIN_FULLNAME Admin
ENV ADMIN_TITLE Administrator
RUN bin/plugin login newuser \
    --user="${ADMIN_USER}" \
    --password="${ADMIN_PASSWORD}" \
    --email="${ADMIN_EMAIL}" \
    --permissions="${ADMIN_PERMISSIONS}" \
    --fullname="${ADMIN_FULLNAME}" \
    --title="${ADMIN_TITLE}"

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping