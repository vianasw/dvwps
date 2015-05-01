FROM ubuntu:14.04
MAINTAINER William Viana <vianasw@gmail.com>

RUN apt-get update && apt-get install -y apache2 php5-mysql php5 libapache2-mod-php5 php5-mcrypt php5-gd supervisor wget rsync

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/supervisor

COPY configs/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN wget https://wordpress.org/wordpress-3.8.1.tar.gz && tar zxvf wordpress-3.8.1.tar.gz

COPY entrypoint.sh /entrypoint.sh
COPY configs/dir.conf /etc/apache2/mods-enabled/dir.conf
COPY wp_vuln_plugins/theme-my-login /wordpress/wp-content/plugins/theme-my-login

RUN rsync -avP /wordpress/ /var/www/html/
RUN cd /var/www/html && chown -R :www-data *
RUN mkdir /var/www/html/wp-content/uploads && chown -R :www-data /var/www/html/wp-content/uploads

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
