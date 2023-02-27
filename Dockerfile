FROM golang:1.19-alpine AS builder
WORKDIR /caddy
RUN apk add --no-cache libcap &&\
    go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
    XCADDY_SETCAP=1 XCADDY_GO_BUILD_FLAGS="-ldflags '-w -s'" $GOPATH/bin/xcaddy build \
    --with github.com/caddy-dns/cloudflare  \
    --with github.com/mholt/caddy-webdav    \
    --with github.com/caddy-dns/route53     \
    --with github.com/abiosoft/caddy-exec   \
    --with github.com/greenpau/caddy-trace  \
    --with github.com/caddyserver/replace-response  \
    --with github.com/caddyserver/ntlm-transport    \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/aksdb/caddy-cgi/v2   \
    --with github.com/greenpau/caddy-security   \
    --with github.com/abiosoft/caddy-json-parse \
    --with github.com/mholt/caddy-l4 \
    --with github.com/WingLim/caddy-webhook \
    --with github.com/ueffel/caddy-brotli   \
    --with github.com/mohammed90/caddy-ssh@master  \
    --with github.com/imgk/caddy-trojan \
    --output caddy

FROM alpine:latest
WORKDIR /caddy
RUN apk --no-cache add ca-certificates vim && \
    addgroup -S app && adduser -S app -G app
COPY --from=builder /caddy/caddy /usr/bin/caddy
USER app
CMD ["/usr/bin/caddy","--config","/caddy/Caddyfile","--watch"]