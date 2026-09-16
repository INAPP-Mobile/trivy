FROM aquasec/trivy:latest
USER root
EXPOSE 4954
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:4954/healthz || exit 1
ENTRYPOINT ["trivy"]
CMD ["server", "--listen", "0.0.0.0:4954"]
