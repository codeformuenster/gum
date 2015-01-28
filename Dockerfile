FROM golang:1.4.1-wheezy

RUN mkdir -p /go/src/app
WORKDIR /go/src/app
COPY . /go/src/app

RUN go get -d ./...
RUN go build -o gum cmd/gum/main.go

CMD ["sh", "run.sh"]
