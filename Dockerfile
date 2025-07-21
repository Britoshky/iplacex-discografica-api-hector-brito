# 🏗️ Etapa 1: Construcción con Gradle
FROM gradle:8.5-jdk21 AS build
WORKDIR /app

# Copiamos solo los archivos necesarios para cachear dependencias
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
COPY src ./src

# Compilar el proyecto y generar el .jar
RUN gradle build --no-daemon

# 🚀 Etapa 2: Imagen ligera con OpenJDK para ejecutar el .jar
FROM openjdk:21-slim
WORKDIR /app

# Copiar el JAR desde la etapa anterior
COPY --from=build /app/build/libs/*.jar app.jar

# Puerto expuesto (según server.port)
EXPOSE 8080

# Comando para ejecutar el jar
ENTRYPOINT ["java", "-jar", "app.jar"]
