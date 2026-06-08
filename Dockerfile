# ==========================================
# STAGE 1: Build (Heavy weight, discarded after build)
# ==========================================
FROM maven:3.9-eclipse-temurin-21-alpine AS builder
WORKDIR /app
# Only copy the POM first to cache dependencies and speed up builds
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code and compile
COPY src ./src
RUN mvn clean package -DskipTests

# ==========================================
# STAGE 2: Runtime (Ultra-lightweight, Secure)
# ==========================================
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# DevSecOps Hardening: Create a non-root user
# Running containers as root is a massive security risk
RUN addgroup -S spring && adduser -S spring -G spring

# Copy only the compiled JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Drop root privileges immediately
USER spring:spring

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]