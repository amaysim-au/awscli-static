FROM alpine:3.8

# Install PreReq's
RUN apk --no-cache update && \
    apk --no-cache add groff less && \
    rm -rf /var/cache/apk/*

ADD ./bin/aws /usr/local/bin
