FROM eclipse-temurin:17-jre-alpine

RUN apk update && apk upgrade

ARG artifact=target/spring-boot-web.jar

WORKDIR /opt/app

COPY ${artifact} app.jar

# Create non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Give the user ownership of the application
RUN chown -R appuser:appgroup /opt/app

# Run container as non-root user
USER appuser

ENTRYPOINT ["java", "-jar", "app.jar"]
