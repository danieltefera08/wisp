FROM busybox:glibc
USER root

COPY wisp /wisp

ENTRYPOINT ["/wisp"]
