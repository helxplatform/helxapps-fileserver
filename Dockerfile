FROM golang:1.21 as build_fileServer 
ENV CGO_ENABLED 0
ARG BUILD_REF

COPY . /helx 

# Build the Binary, passing in BUILD_REF from the Makefile
WORKDIR /helx/cmd 
RUN go build -ldflags "-X main.embeddedBranch=${BUILD_REF}" -o helxappsfs

FROM alpine:3.18
# Keep these ARGS in the final image
ARG BUILD_DATE
ARG BUILD_REF

# Ensure we have a valid user and group
RUN addgroup -g 1000 -S helx && \
    adduser -u 1000 -h /helx -G helx -S helx

COPY --from=build_fileServer --chown=helx:helx /helx/cmd/helxappsfs /helx

WORKDIR /helx
EXPOSE 8323
CMD ["./helxappsfs"]

LABEL org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="helxappsFS" \
      org.opencontainers.image.authors="Joshua Seals" \
      org.opencontainers.image.source="https://github.com/helxplatform/helxappsFS" \
      org.opencontainers.image.revision="${BUILD_REF}" \
      org.opencontainers.image.vendor="RENCI - Renaissance Computing Institute"
