FROM golang:1.23-alpine as builder
RUN adduser -D -g '' --shell /bin/false domain-exporter
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o bin/domain_exporter .

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /app/bin/domain_exporter /bin/domain-exporter
COPY --from=builder /etc/passwd /etc/passwd
USER domain-exporter
ENTRYPOINT ["/bin/domain-exporter"]
