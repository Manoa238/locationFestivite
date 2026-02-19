FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/Tomcat/webapps/*

COPY ROOT.war /usr/local/Tomcat/webapps/ROOT.war

EXPOSE 8081

CMD ["catalina.sh", "run"]