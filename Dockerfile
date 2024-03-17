# Użyj oficjalnego obrazu PHP Apache
FROM php:7.4-apache

# Zainstaluj dodatkowe zależności
RUN apt-get update \
    && apt-get install -y \
       zlib1g-dev \
       libicu-dev \
       libpng-dev \
       libjpeg-dev \
       libfreetype6-dev \
       libjpeg62-turbo-dev \
       libxml2-dev \
       libzip-dev \
       unzip \
       wget \
    && rm -rf /var/lib/apt/lists/*

# Konfiguracja PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd intl pdo pdo_mysql zip

# Pobierz i wypakuj PrestaShop
WORKDIR /var/www/html
RUN wget https://download.prestashop.com/download/releases/prestashop_1.7.7.0.zip
RUN unzip prestashop_1.7.7.0.zip
RUN mv */* . && rm -rf prestashop*


# Ustawienia Apache
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html

# Port, na którym działa PrestaShop
EXPOSE 80

# Polecenie startowe
CMD ["apache2-foreground"]
