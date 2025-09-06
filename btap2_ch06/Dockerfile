# ... build stage y như trên ...

FROM tomcat:11.0-jre17-temurin
ENV CATALINA_HOME=/usr/local/tomcat
WORKDIR $CATALINA_HOME
RUN sed -ri 's/port="8005"/port="-1"/' $CATALINA_HOME/conf/server.xml \
 && rm -rf $CATALINA_HOME/webapps/*
RUN sed -ri 's/port="8080"/port="${PORT}"/' $CATALINA_HOME/conf/server.xml
COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
COPY --from=build /app/target/*.war $CATALINA_HOME/webapps/ROOT.war
EXPOSE 8080
CMD ["/usr/local/bin/run.sh"]
