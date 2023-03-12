ARG _CONTAINER_NGINX_DEV_IMAGE
ARG _CONTAINER_NGINX_DEV_IMAGE_TAG
ARG _CONTAINER_NGINX_PROD_IMAGE
ARG _CONTAINER_NGINX_PROD_IMAGE_TAG



FROM "${_CONTAINER_NGINX_DEV_IMAGE}":"${_CONTAINER_NGINX_DEV_IMAGE_TAG}" AS dev
# run in non-interactive mode
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
       procps \
       net-tools \
       nginx
# link nginx logs to std output
# RUN touch /var/log/nginx/access.log /var/log/nginx/error.log
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
EXPOSE 80
EXPOSE 443
COPY ./entrypoint.sh /opt/
COPY ./etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./etc/nginx/sites-available/ /etc/nginx/sites-available/
COPY ./var/www/html/ /var/www/html/
ENTRYPOINT /opt/entrypoint.sh
# CMD ['/opt/entrypoint.sh']



FROM "${_CONTAINER_NGINX_PROD_IMAGE}":"${_CONTAINER_NGINX_PROD_IMAGE_TAG}" AS prod
COPY --from=dev /etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=dev /etc/nginx/sites-available/default /etc/nginx/conf.d/default.conf
COPY --from=dev /var/www/html/ /usr/share/nginx/html/
