# 1. Dùng image có Maven + Java để build
FROM maven:3.9.9-eclipse-temurin-11 AS builder

# Copy source code
COPY . /app
WORKDIR /app

# Build JAR
RUN mvn -DskipTests clean package

# 2. Dùng image nhẹ để chạy
FROM eclipse-temurin:11-jre

# Copy JAR từ bước build
COPY --from=builder /app/target/*.jar /app.jar

# Chạy
CMD ["java", "-jar", "/app.jar"]