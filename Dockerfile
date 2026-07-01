ARG CENTRIFUGO_VERSION=6.2.5
FROM centrifugo/centrifugo:v${CENTRIFUGO_VERSION}

USER root
RUN apk add --no-cache gomplate==4.2.0-r5 dumb-init==1.2.5-r3

ENV CENTRIFUGO_SECRET="secret"
ENV CENTRIFUGO_ALLOWED_ORIGIN=""
ENV CENTRIFUGO_ADMIN_PASSWORD="password"
ENV CENTRIFUGO_HTTP_SERVER_PORT=6080
ENV CENTRIFUGO_PERSONAL_NAMESPACE="personal"
ENV CENTRIFUGO_ADDITIONAL_PERSONAL_NAMESPACES=""

COPY config-template.json /centrifugo
COPY entrypoint.sh /centrifugo

USER centrifugo

WORKDIR /centrifugo
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["./entrypoint.sh"]
