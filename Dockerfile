# Giai đoạn 1: Build JAR với Maven
FROM maven:3.9.9-eclipse-temurin-11 AS builder
WORKDIR /app
COPY . .
RUN mvn -DskipTests clean package

# Giai đoạn 2: Chạy JAR
FROM eclipse-temurin:11-jre
COPY --from=builder /app/target/*.jar /app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]