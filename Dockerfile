FROM golang:1.21 as build_fileServer 
ENV CGO_ENABLED 0 

COPY . /helx 

# Build the Binary
WORKDIR /helx/cmd 
RUN go build -o helxappsfs

FROM alpine:3.18

# Ensure we have a valid user and group
RUN addgroup -g 1000 -S helx && \
    adduser -u 1000 -h /helx -G helx -S helx

COPY --from=build_fileServer --chown=helx:helx /helx/cmd/helxappsfs /helx

WORKDIR /helx
EXPOSE 8323
CMD ["./helxappsfs"]

