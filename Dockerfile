FROM golang:1.12 as builder

RUN mkdir -p $GOPATH/src/github.com/Visteras/mikrotik-exporter
COPY ./ $GOPATH/src/github.com/Visteras/mikrotik-exporter
WORKDIR $GOPATH/src/github.com/Visteras/mikrotik-exporter
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o mikrotik-exporter .

FROM alpine

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/* && mkdir -p /app
COPY --from=builder /go/src/github.com/Visteras/mikrotik-exporter/mikrotik-exporter /app/mikrotik-exporter
COPY --from=builder /go/src/github.com/Visteras/mikrotik-exporter/scripts/start.sh /app/
RUN chmod 755 /app/*

EXPOSE 9436
ENTRYPOINT ["/app/start.sh"]