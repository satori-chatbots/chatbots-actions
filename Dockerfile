FROM openjdk:18-alpine
RUN apk update && apk upgrade --available
RUN apk add bash 
RUN apk add zip
RUN apk add jq
ADD https://github.com/SaraPerezSoler/CONGA/releases/download/0.1/CongaReverse3.4_pUML.jar /
ADD https://github.com/SaraPerezSoler/CONGA/releases/download/0.1/CONGA_Validator.jar /
ADD https://github.com/rdavilao/plantUML-encode/releases/download/0.1/plantUML-encode.jar /
ADD https://github.com/ASYM0B/tool/releases/download/v0.2/AsymobJSON.jar /
COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
