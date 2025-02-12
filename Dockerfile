FROM golang:1.15-alpine as builder

# Download and install dependencies
RUN apk update && apk add --no-cache git
RUN go get github.com/prometheus/client_golang/prometheus

# Copy the code from the host
WORKDIR $GOPATH/src/github.com/maesoser/tplink_exporter
COPY . .

# Compile it
ENV CGO_ENABLED=0
RUN GOOS=linux go build -a -installsuffix cgo -ldflags '-s -w -extldflags "-static"' .

# Create docker
FROM alpine
COPY --from=builder /go/src/github.com/maesoser/tplink_exporter/tplink_exporter /app/
RUN adduser -D tplink
USER tplink
ENTRYPOINT ["/app/tplink_exporter"]
