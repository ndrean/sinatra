FROM debian:buster-slim

RUN apt-get update \
    && apt-get install -y nginx  \
    && rm /var/log/nginx/access.log && ln -s /dev/stdout /var/log/nginx/access.log \
    && rm /var/log/nginx/error.log && ln -s /dev/stderr /var/log/nginx/error.log \
    && apt-get install gettext-base -y\
    && rm -rf /var/lib/opt/lists/*

# for testing curl http://localhost inside the container
# RUN apt-get update && apt-get install curl -y


ENV PROXY_UPSTREAM=$PROXY_UPSTREAM TEST=petitest
COPY proxy.conf /etc/nginx/conf.d/default.tmp
# RUN envsubst '$PROXY_UPSTREAM' < /etc/nginx/conf.d/default.tmp > /etc/nginx/conf.d/default.conf

# COPY startws.sh /
# RUN chmod +x startws.sh
# CMD ["/startws.sh"]

# COPY ./public /usr/share/nginx/html:ro || done in the docker-compose by bind-mont

RUN envsubst '$TEST' < /etc/nginx/conf.d/default.tmp > /etc/nginx/conf.d/default.conf


# COPY proxy.conf /etc/nginx/conf.d/default.conf
# facultatif
EXPOSE 80

# use the exec form of CMD so nginx stops on SIGTERM
CMD ["usr/sbin/nginx", "-g","daemon: off;"]

STOPSIGNAL SIGQUIT

# => build image from Dockerfile and navigate to localhost:8080 
# docker image build -t ndrean/webserver:latest . 
# && docker container run  -p 8080:80 --name ws  --rm -it --network mynet ndrean/webserver:latest