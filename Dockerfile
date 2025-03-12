FROM golang:alpine AS builder
WORKDIR /caddy
RUN apk add --no-cache libcap git &&\
    go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
    XCADDY_SETCAP=1 XCADDY_GO_BUILD_FLAGS="-ldflags '-w -s'" $GOPATH/bin/xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare  \
    --with github.com/mholt/caddy-webdav    \
    --with github.com/caddy-dns/route53     \
    --with github.com/caddyserver/replace-response  \
    --with github.com/ueffel/caddy-markdown-ex \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/aksdb/caddy-cgi/v2   \
    --with github.com/greenpau/caddy-security   \
    --with github.com/abiosoft/caddy-json-parse \
    --with github.com/mholt/caddy-l4 \
    --with github.com/WingLim/caddy-webhook \
    --with github.com/ueffel/caddy-brotli   \
    --with github.com/imgk/caddy-trojan \
    --with github.com/abiosoft/caddy-yaml \
    --with github.com/ss098/certmagic-s3 \
    --with github.com/abiosoft/caddy-json-schema \
    --with github.com/caddyserver/forwardproxy \
    --output caddy

FROM alpine:latest
RUN apk --no-cache add ca-certificates sudo \
    && mkdir -p /caddy \
    && addgroup -g 1000 app \
    && adduser -h /caddy -D -H -g "" -u 1000 -G app app \
    && echo "app ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers \
    && chown -R app:app /caddy
COPY --from=builder /caddy/caddy /usr/bin/caddy
WORKDIR /caddy
USER app
CMD ["/usr/bin/caddy","run","--config","/caddy/Caddyfile","--watch"]
