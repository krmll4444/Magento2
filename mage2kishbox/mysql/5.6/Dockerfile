FROM mysql:5.6


ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN chown -R mysql:root /var/lib/mysql/

ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD my.cnf /etc/mysql/conf.d/my.cnf

CMD ["mysqld"]

EXPOSE 3306
