FROM debian:stable
USER root

COPY wisp /wisp

ENTRYPOINT ["/wisp"]
