FROM alpine:3.14.0
RUN apk update && apk add tzdata
RUN cp /usr/share/zoneinfo/Europe/Brussels /etc/localtime
RUN echo "Europe/Brussels" >  /etc/timezone
CMD date
