FROM eclipse-temurin:17

WORKDIR /app

COPY target/*.war app.war

ENTRYPOINT ["java", "-jar", "app.war"]

