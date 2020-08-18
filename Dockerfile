FROM debian:stretch-slim
MAINTAINER m4nzm333

# Update Repo
RUN apt-get update
# Install Apache
RUN apt-get install apache2 -y

# Add SURY PHP PPA repository
RUN apt-get -y install lsb-release apt-transport-https ca-certificates wget
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
# Update Repo
RUN apt-get update
# Install php
RUN apt -y install php7.4
# Install Common Dependencies
RUN apt-get install -y php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl
# Install mod for Apache
RUN apt install libapache2-mod-php7.4
# # Enable Mod for Apache
RUN a2enmod php7.4 && a2enmod rewrite

# COMPOSER
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '572cb359b56ad9ae52f9c23d29d4b19a040af10d6635642e646a7caa7b96de717ce683bd797a92ce99e5929cc51e7d5f') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN mv composer.phar /usr/local/bin/composer
RUN php -r "unlink('composer-setup.php');"

# File for index php
COPY phpinfo.php /var/www/html/
# Expose Port to Apache
EXPOSE 80
CMD apachectl -D FOREGROUND