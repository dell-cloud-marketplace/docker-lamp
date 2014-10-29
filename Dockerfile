FROM dell/lamp-base:1.0
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 run.sh

# Remove any pre-installed applications
RUN rm -fr /var/www/html/*

# Add the folder with the sample application
ADD hello-world-lamp /hello-world-lamp

# Add volumes for MySQL and the application.
VOLUME ['/var/lib/mysql', '/var/www/html']

EXPOSE 80 3306 443

CMD ["/run.sh"]
