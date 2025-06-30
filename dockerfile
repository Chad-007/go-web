FROM golang:1.22 AS builder
WORKDIR /app

COPY go.mod .
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o main .
FROM gcr.io/distroless/static-debian11

WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/static ./static

EXPOSE 8085
CMD ["./main"]
