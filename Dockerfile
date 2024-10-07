# Utiliser l'image de base Maven avec JDK 17 pour la phase de build
FROM maven:latest AS build

# Définir le répertoire de travail à l'intérieur du conteneur pour le build Maven
WORKDIR /app

# Copier le fichier POM et les fichiers source dans le conteneur
COPY pom.xml .
COPY src ./src

# Télécharger les dépendances Maven et compiler l'application
RUN mvn clean package -DskipTests

# Étape d'exécution avec JDK 17
FROM openjdk:17-jdk-alpine

# Définir le répertoire de travail à l'intérieur du conteneur
WORKDIR /app

# Copier le fichier JAR généré depuis l'étape de build Maven
COPY --from=build /app/target/patient-management-microservice-0.0.1-SNAPSHOT.jar /app/patient-management-microservice.jar

# Exposer le port 8080 pour que l'application puisse recevoir des requêtes
EXPOSE 8080

# Commande pour lancer l'application Spring Boot
ENTRYPOINT ["java", "-jar", "/app/patient-management-microservice.jar"]
