FROM alpine:3.14.0
RUN apk add --no-cache curl
EXPOSE 5001
COPY . /test
WORKDIR /test
ENTRYPOINT ["/bin/sh", "-c", "apk add --no-cache curl && chmod +x /test/ping.sh && /test/ping.sh"]

FROM alpine:3.14.0
RUN apk add --no-cache curl
EXPOSE 5002
COPY . /test
WORKDIR /test
ENTRYPOINT ["/bin/sh", "-c", "apk add --no-cache curl && chmod +x /test/pong.sh && /test/pong.sh"]

# sudo docker run --rm --name server1 --network="pingpong" ping
# sudo docker run --rm --name server2 --network="pingpong" pong