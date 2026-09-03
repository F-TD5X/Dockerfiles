FROM --platform=$BUILDPLATFORM golang:alpine AS builder
ARG TARGETOS
ARG TARGETARCH
WORKDIR /caddy
RUN apk add --no-cache libcap git
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    GOOS=$TARGETOS GOARCH=$TARGETARCH XCADDY_SETCAP=1 XCADDY_GO_BUILD_FLAGS="-ldflags '-w -s'" $GOPATH/bin/xcaddy build \
    --with github.com/caddy-dns/cloudflare  \
    --with github.com/caddyserver/replace-response  \
    --with github.com/ueffel/caddy-markdown-ex \
    --with github.com/mholt/caddy-l4 \
    --with github.com/ueffel/caddy-brotli   \
    --with github.com/imgk/caddy-trojan \
    --with github.com/abiosoft/caddy-json-schema \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/caddyserver/forwardproxy=github.com/klzgrad/forwardproxy@naive \
    --with github.com/sjtug/cerberus@dist \
    --output caddy

FROM alpine:latest
COPY --from=builder /caddy/caddy /usr/bin/caddy
RUN apk --no-cache add ca-certificates \
    && apk --no-cache add --virtual .setcap-deps libcap \
    && setcap cap_net_bind_service=+ep /usr/bin/caddy \
    && apk del .setcap-deps \
    && mkdir -p /caddy \
    && addgroup -g 10001 app \
    && adduser -h /caddy -D -H -g "" -u 10001 -G app app \
    && chown -R app:app /caddy
WORKDIR /caddy
USER app
CMD ["/usr/bin/caddy","run","--config","/caddy/Caddyfile","--watch"]
