FROM busybox
USER root

COPY wisp /wisp

ENTRYPOINT ["/wisp"]
