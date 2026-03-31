FROM golang:1.21-alpine AS build-env

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -v -a -ldflags "-s -w" -o /go/bin/qcloud_exporter ./cmd/qcloud-exporter/

FROM alpine:3.19
COPY --from=build-env /go/bin/qcloud_exporter /usr/bin/qcloud_exporter
RUN apk add --no-cache curl tcpdump
ENTRYPOINT ["qcloud_exporter"]
