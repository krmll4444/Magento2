FROM nginx:1-alpine

RUN apk add --update openssl

COPY make_certificate.sh /usr/local/bin/make_certificate
RUN chmod +x /usr/local/bin/make_certificate

RUN make_certificate magento2ce.loc

#COPY sites/magento2ce.conf /etc/nginx/conf.d/
RUN rm /etc/nginx/conf.d/default.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log
