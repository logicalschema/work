# Base image: Red Hat Universal Base Image (UBI) 9
FROM registry.redhat.io/ubi9/ubi-minimal:9.6

# Environment Variables
ENV APP_USER="www-wordpress" \
    APP_UID="1001" \
    APP_PORT="9000" \
    INSTALL_PKGS="vi php php-devel php-fpm" \
    INSTALL_EXTS="php-intl php-mysqlnd php-gd php-xml php-mbstring php-json php-pear php-pecl-zip php-opcache php-cli" 
    
# Enable EPEL and install packages
RUN microdnf update -y && \
    microdnf module enable php:8.3 -y && \
    microdnf install -y $INSTALL_PKGS $INSTALL_EXTS && \
    microdnf install -y libmemcached-awesome libmemcached-awesome-devel ImageMagick ImageMagick-devel && \
    microdnf clean all && \
    printf "\n" | pecl install imagick && \
    pecl install --configureoptions 'with-libmemcached-dir="yes" with-zlib-dir="no" with-system-fastlz="no" enable-memcached-igbinary="no" enable-memcached-msgpack="no" enable-memcached-json="no" enable-memcached-protocol="no" enable-memcached-sasl="yes" enable-memcached-session="yes"' memcached && \
    echo "extension=imagick.so" > /etc/php.d/20-imagick.ini && \
    echo "extension=memcached.so" > /etc/php.d/40-memcached.ini

# Configure and change permissions for folder and files
RUN sed -i "s/^user = apache$/user = ${APP_USER}/" /etc/php-fpm.d/www.conf && \ 
    sed -i "s/^group = apache$/group = ${APP_USER}/" /etc/php-fpm.d/www.conf && \
    sed -i "s/^listen = \/run\/php-fpm\/www.sock$/listen = 0.0.0.0:9000/" /etc/php-fpm.d/www.conf && \
    useradd -u ${APP_UID} ${APP_USER} && \
    mkdir -p /run/php-fpm && \
    chown -R ${APP_UID}:0 /run/php-fpm /var/www/html /var/log/php-fpm && \
    chmod -R g=u /run/php-fpm /var/www/html /var/log/php-fpm && \
    chmod -R g+w /var/www/html

USER ${APP_UID}
EXPOSE 9000

# Start Apache in the foreground
CMD ["php-fpm", "--nodaemonize"]



