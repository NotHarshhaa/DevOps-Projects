FROM eclipse-temurin:17-jre-alpine

RUN apk update && apk upgrade

ARG artifact=target/spring-boot-web.jar

WORKDIR /opt/app

COPY ${artifact} app.jar

RUN addgroup -S -g 10001 appgroup && \
    adduser -S -u 10001 -G appgroup appuser

RUN chown -R appuser:appgroup /opt/app

USER appuser

ENTRYPOINT ["java", "-jar", "app.jar"]