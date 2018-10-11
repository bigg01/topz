FROM golang:1.11.1-alpine AS builder

#ENV GOPATH /usr/src/app

CMD echo $GOPATH

WORKDIR /go/src/topz

RUN apk --no-cache add ca-certificates git

ADD pkg cmd  /go/src/topz/
RUN go get -v ./... && \
    cd /go/src/topz/cmd/server && \
    CGO_ENABLED=0 GOOS=linux go build -v -a -installsuffix cgo -o topz .

FROM scratch


#EXPOSE 8080
# Since we started from scratch, we'll copy the SSL root certificates from the builder
WORKDIR /usr/local/bin

COPY --from=builder /go/src/topz/cmd/server/topz .

# bind localhost
CMD ["topz"]
