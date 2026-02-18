FROM tomcat:10.1-jdk17-temurin   # Change jdk17 en jdk11 ou jdk8 si ton projet est plus ancien

# Nettoie Tomcat pour éviter les pages par défaut
RUN rm -rf /usr/local/tomcat/webapps/*

# Copie ton .war (gardé tel quel, sans renommer)
COPY LocationFestivite.war /usr/local/tomcat/webapps/LocationFestivite.war

# Port standard pour Render
EXPOSE 8081

# Démarre Tomcat
CMD ["catalina.sh", "run"]