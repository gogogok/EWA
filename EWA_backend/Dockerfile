FROM gradle:8.14.3-jdk17 AS build
WORKDIR /app
COPY . .
RUN gradle bootJar --no-daemon

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
CMD ["sh", "-c", "java -Dserver.port=$PORT -jar app.jar"]