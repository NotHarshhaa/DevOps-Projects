FROM eclipse-temurin:17-jre-alpine

RUN apk update && apk upgrade

ARG artifact=target/spring-boot-web.jar

WORKDIR /opt/app

COPY ${artifact} app.jar

RUN addgroup -S -g 10001 appgroup && \
    adduser -S -u 10001 -G appgroup appuser

RUN chown -R 10001:10001 /opt/app

USER 10001

ENTRYPOINT ["java", "-jar", "app.jar"]