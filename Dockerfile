FROM gradle:8.6-jdk21-alpine AS build
WORKDIR /app

# Copiar archivos de construcción
COPY build.gradle .
COPY settings.gradle .
RUN gradle dependencies --no-daemon || true

# Copiar código fuente
COPY src ./src

# Construir la aplicación
RUN gradle build --no-daemon -x test

# Fase de ejecución con JRE 21
FROM eclipse-temurin:21-jre-alpine
EXPOSE 8761
COPY --from=build /app/build/libs/*.jar /app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]