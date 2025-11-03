# Dùng image Java 11 chính thức
FROM openjdk:11-jre-slim

# Copy JAR vào container
COPY target/*.jar app.jar

# Chạy JAR
CMD ["java", "-jar", "/app.jar"]