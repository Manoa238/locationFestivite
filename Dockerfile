FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
# Désactive le port shutdown pour éviter les warnings inutiles dans Docker/Render
RUN sed -i 's/<Server port="8005" shutdown="SHUTDOWN">/<Server port="-1" shutdown="SHUTDOWN">/g' /usr/local/tomcat/conf/server.xml

CMD ["catalina.sh", "run"]