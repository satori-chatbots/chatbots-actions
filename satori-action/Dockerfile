FROM openjdk:18-alpine
RUN apk update && apk upgrade --available
RUN apk add --update python3
RUN apk add bash  # Be careful, because alpine doesn't have bash
ADD https://github.com/SaraPerezSoler/CONGA/releases/download/0.1/CongaReverse.jar /
ADD https://github.com/ASYM0B/tool/releases/download/v0.2/AsymobJSON.jar /
COPY entrypoint.sh /entrypoint.sh
COPY python/metrics_to_html.py /metrics_to_html.py
ENTRYPOINT ["/entrypoint.sh"]
