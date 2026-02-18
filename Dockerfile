FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY LocationFestivite.war /usr/local/tomcat/webapps/LocationFestivite.war

EXPOSE 8080

CMD ["catalina.sh", "run"]