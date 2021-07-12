FROM alpine:3.14

RUN apk update && apk add wget
RUN wget https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest
RUN mv ecs-cli-linux-amd64-latest /usr/local/bin/ecs-cli
RUN chmod +x /usr/local/bin/ecs-cli

ENTRYPOINT ["/usr/local/bin/ecs-cli"]

# docker run -it -v ~/.aws:/root/.aws -v ~/.ecs:/root/.ecs
