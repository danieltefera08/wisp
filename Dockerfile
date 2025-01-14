FROM cgr.dev/chainguard/static:latest
USER root

COPY wisp /wisp

ENTRYPOINT ["/wisp"]
