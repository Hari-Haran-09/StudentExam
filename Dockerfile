FROM eclipse-temurin:17

WORKDIR /app

COPY target/*.war app.war

EXPOSE 4049

ENTRYPOINT ["java", "-jar", "app.war"]
