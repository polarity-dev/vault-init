FROM vault

ARG VAULT_ENDPOINT
ENV VAULT_ENDPOINT $VAULT_ENDPOINT
ARG VAULT_ADMIN_PASSWORD
ENV VAULT_ADMIN_PASSWORD $VAULT_ADMIN_PASSWORD
ARG VAULT_ADMIN_USERNAME
ENV VAULT_ADMIN_USERNAME $VAULT_ADMIN_USERNAME

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY admin-policy.hcl /tmp/admin-policy.hcl

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
