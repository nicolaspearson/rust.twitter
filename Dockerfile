FROM ekidd/rust-musl-builder:latest AS builder
COPY --chown=rust:rust Cargo.lock .
COPY --chown=rust:rust Cargo.toml .
COPY --chown=rust:rust migrations migrations
COPY --chown=rust:rust src src
RUN cargo build --release

FROM alpine:latest
RUN apk --no-cache add ca-certificates
RUN addgroup -g 1000 app
RUN adduser -D -s /bin/sh -u 1000 -G app app
WORKDIR /home/app/bin/
USER app
COPY --chown=app:app --from=builder \
    /home/rust/src/target/x86_64-unknown-linux-musl/release/rust-twitter \
    /home/app/bin/
CMD /home/app/bin/rust-twitter
