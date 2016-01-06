FROM nginx:1.9

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

ADD entrypoint.sh /entrypoint.sh

EXPOSE 80

CMD ["/entrypoint.sh"]
