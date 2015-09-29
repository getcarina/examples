FROM nginx:1.7

# Update some config values
RUN sed -i -e "s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e "s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf

# Copy nginx config file
COPY wordpress-fpm.conf /etc/nginx/conf.d/default.conf
