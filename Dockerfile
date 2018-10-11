FROM golang:1.11.1-alpine AS builder
WORKDIR /go/src/topz
RUN apk --no-cache add ca-certificates git upx

COPY pkg  /go/src/topz/pkg
COPY cmd  /go/src/topz/cmd
RUN go get -v ./... && \
    cd /go/src/topz/cmd/server && \
    CGO_ENABLED=0 GOOS=linux go build -v -a -installsuffix cgo -o topz . && \
    upx --ultra-brute -qq topz && \
    upx -t topz

FROM scratch
EXPOSE 8080
WORKDIR /usr/local/bin
COPY --from=builder /go/src/topz/cmd/server/topz .
CMD ["topz"]
