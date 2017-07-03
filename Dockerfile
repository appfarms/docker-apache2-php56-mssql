FROM ppoffice/mssql-odbc

RUN apt-get update && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get -y install apache2 php5.6 php5.6-mssql && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN /usr/sbin/a2enmod rewrite
RUN /usr/sbin/a2enmod actions

RUN /etc/init.d/apache2 restart
RUN phpenmod mssql

# Edit 000-default.conf to change apache site settings.
ADD ./000-default.conf /etc/apache2/sites-available/

# Uncomment these two lines to fix "non-UTF8" chars encoding and time format problems
ADD ./freetds.conf /etc/freetds/
ADD ./locales.conf /etc/freetds/

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
