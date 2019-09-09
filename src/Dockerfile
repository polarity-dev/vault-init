FROM vault:1.2.2

RUN apk update

RUN apk add --no-cache --virtual .build-deps
RUN apk -Uuv --no-cache add groff less python py-pip jq
RUN pip install awscli
RUN apk --purge -v del py-pip
RUN rm /var/cache/apk/*

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY plugins/aws-secretsmanager-store.sh /usr/local/bin/aws-secretsmanager-store.sh
COPY plugins/aws-secretsmanager-retrieve.sh /usr/local/bin/aws-secretsmanager-retrieve.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/aws-secretsmanager-store.sh
RUN chmod +x /usr/local/bin/aws-secretsmanager-retrieve.sh
COPY admin-policy.hcl /tmp/admin-policy.hcl

ENTRYPOINT "/usr/local/bin/docker-entrypoint.sh"
