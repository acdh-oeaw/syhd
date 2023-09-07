FROM php:7.4-apache
LABEL maintainer="Martin Helmich <typo3@martin-helmich.de>"

# phantomjs
RUN apt-get update && apt-get install -y build-essential chrpath libssl-dev libxft-dev wget
RUN apt-get install libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev

RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
RUN ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin

# Install TYPO3
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget sendmail libnss3-tools \
    # Configure PHP
    libxml2-dev libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libpq-dev \
    libzip-dev \
    zlib1g-dev \
    # Install required 3rd party tools
    graphicsmagick && \
    # Configure extensions
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-install -j$(nproc) mysqli soap gd zip opcache intl pgsql pdo_pgsql && \
    echo 'always_populate_raw_post_data = -1\nmax_execution_time = 240\nmax_input_vars = 1500\nupload_max_filesize = 32M\npost_max_size = 32M' > /usr/local/etc/php/conf.d/typo3.ini && \
    # Configure Apache as needed
    a2enmod rewrite && \
    apt-get clean && \
    apt-get -y purge \
    libxml2-dev libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    zlib1g-dev && \
    rm -rf /var/lib/apt/lists/* /usr/src/*

RUN cd /tmp && wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 && \
    mv mkcert-v1.4.3-linux-amd64 /usr/bin/mkcert && \
    chmod +x /usr/bin/mkcert && \
    mkcert --version && \
    mkdir -p /etc/apache2/ssl && \
    cd /etc/apache2/ssl && \
    mkcert -install && \
    mkcert localhost 127.0.0.1 ::1 && \
    ls -la && \
    mv localhost+2-key.pem cert-key.pem && \
    mv localhost+2.pem cert.pem 
 

RUN a2enmod ssl && a2enmod rewrite && a2enmod proxy_http

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
EXPOSE 443