FROM erlang:27-alpine AS builder
WORKDIR /app
COPY . .
RUN rebar3 as prod release

FROM alpine:3.20
RUN apk add --no-cache openssl ncurses-libs libstdc++
COPY --from=builder /app/_build/prod/rel/freeapi /app
EXPOSE 8080
CMD ["/app/bin/freeapi", "foreground"]
