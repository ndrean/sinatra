FROM debian:buster-slim

RUN apt-get update \
    && apt-get install -y nginx  curl\
    && rm /var/log/nginx/access.log && ln -s /dev/stdout /var/log/nginx/access.log \
    && rm /var/log/nginx/error.log && ln -s /dev/stderr /var/log/nginx/error.log \
    && apt-get install gettext-base -y\
    && rm -rf /var/lib/opt/lists/*

# for testing curl http://localhost inside the container
# RUN apt-get update && apt-get install curl -y

# set a default value; the value comes with the docker-compose file
ENV PROXY_UPSTREAM=example.com

COPY proxy.conf /etc/nginx/conf.d/default.tmp

COPY substenv.sh ./

# COPY ./public /usr/share/nginx/html:ro || done in the docker-compose by bind-mont

# we do: RUN envsubst '$PROXY_UPSTREAM' < /etc/nginx/conf.d/default.tmp > /etc/nginx/conf.d/default.conf
ENTRYPOINT ["/substenv.sh"]

# facultatif
EXPOSE 8080

# the CMD is injected in 'entrypoint' because of "$@".
# we use the exec form of CMD so nginx stops on SIGTERM
CMD ["usr/sbin/nginx", "-g","daemon off;"]

# STOPSIGNAL SIGQUIT

# => build image from Dockerfile and navigate to localhost:8080 
# docker image build -t ndrean/webserver:latest . 
# && docker container run  -p 8080:80 --name ws  --rm -it --network mynet ndrean/webserver:latest