FROM golang:alpine as build

COPY . /src

WORKDIR /src
RUN go build -o trauth

# final image
FROM golang:alpine

ENV UID=1000 \
  GID=1000 \
  USER=trauth

RUN addgroup -S $USER -g $GID && adduser -D -S $USER -G $USER -u $UID

RUN apk add --no-cache \
        tini

COPY --from=build --chown=$UID:$GID /src/trauth /

VOLUME ["/config"]

USER $USER
EXPOSE 8080

ENTRYPOINT ["/sbin/tini", "--", "/trauth"]
