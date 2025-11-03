# Ép xóa cache mỗi lần build (tránh dùng JAR cũ)
ARG CACHEBUST=$(date +%s)

# Giai đoạn 1: Build với Maven (ép chạy shade)
FROM maven:3.9.9-eclipse-temurin-11 AS builder
WORKDIR /app
COPY . .
# Ép chạy shade rõ ràng
RUN mvn clean package shade:shade -DskipTests

# Giai đoạn 2: Chạy JAR (dùng JAR shaded)
FROM eclipse-temurin:11-jre
COPY --from=builder /app/target/*.jar /app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]