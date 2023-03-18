FROM golang:alpine AS builder
ADD . /app
WORKDIR /app
ARG TARGETOS
ARG TARGETARCH
RUN apk add --no-cache gcc musl-dev

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -a -ldflags "-linkmode external -extldflags -static" -o /usr/local/bin/supervisord

FROM scratch

COPY --from=builder /usr/local/bin/supervisord /usr/local/bin/supervisord

ENTRYPOINT ["/usr/local/bin/supervisord"]
