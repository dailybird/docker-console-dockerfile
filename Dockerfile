FROM php:7.1-fpm

MAINTAINER dailybird <dailybirdo@gmail.com>

# 安装 git curl vim zip
RUN apt-get update && apt-get install -y git curl vim libfreetype6-dev \
	&& rm -rf /var/lib/apt/list* \
	&& pecl install zip \
	&& docker-php-ext-enable zip

# 安装 composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \

# 配置 composer 包括引入中国国内镜像
RUN mv composer.phar /usr/local/bin/composer \
 	&& echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc \
 	&& source ~/.bashrc \
 	&& composer config -g repo.packagist composer https://packagist.phpcomposer.com
