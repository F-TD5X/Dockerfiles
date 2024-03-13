FROM golang:alpine AS builder
WORKDIR /caddy
RUN apk add --no-cache libcap git &&\
    go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
    XCADDY_SETCAP=1 XCADDY_GO_BUILD_FLAGS="-ldflags '-w -s'" $GOPATH/bin/xcaddy build \
    --with github.com/caddy-dns/cloudflare  \
    --with github.com/mholt/caddy-webdav    \
    --with github.com/caddy-dns/route53     \
    --with github.com/caddyserver/replace-response  \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/aksdb/caddy-cgi/v2   \
    --with github.com/greenpau/caddy-security   \
    --with github.com/abiosoft/caddy-json-parse \
    --with github.com/mholt/caddy-l4 \
    --with github.com/WingLim/caddy-webhook \
    --with github.com/ueffel/caddy-brotli   \
    --with github.com/kadeessh/kadeessh@v0.0.2  \
    --with github.com/imgk/caddy-trojan \
    --with github.com/abiosoft/caddy-yaml \
    --with github.com/techknowlogick/certmagic-s3 \
    --with github.com/abiosoft/caddy-json-schema \
    --with github.com/caddyserver/forwardproxy \
    --output caddy

FROM alpine:latest
WORKDIR /caddy
RUN apk --no-cache add ca-certificates vim && \
    addgroup -S app && adduser -S app -G app \
    && mkdir -p /caddy && chown app:app -R /caddy
COPY --from=builder /caddy/caddy /usr/bin/caddy
USER app
CMD ["/usr/bin/caddy","run","--config","/caddy/Caddyfile","--watch"]
