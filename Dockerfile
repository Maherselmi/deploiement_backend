# ---- Stage 1 : Build ----
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copier pom.xml en premier pour profiter du cache des dépendances
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier le code source et builder
COPY src ./src
RUN mvn clean package -DskipTests -B

# ---- Stage 2 : Run ----
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copier le JAR généré
COPY --from=build /app/target/InsureFlow_Back-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=prod", "app.jar"]