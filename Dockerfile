# ===== Build stage =====
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# cache dependencies
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

# build WAR
COPY src ./src
RUN mvn -B -q -DskipTests package

# ===== Run stage (Tomcat 11 / Jakarta) =====
FROM tomcat:11.0-jre17-temurin

# stop shutdown port & clean default apps
RUN sed -ri 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml \
 && rm -rf /usr/local/tomcat/webapps/*

# deploy WAR as ROOT.war
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# memory hint (optional, good for free plans)
ENV CATALINA_OPTS="-Xms128m -Xmx384m"

# honor PORT if provided by platform (e.g. Render)
COPY <<'EOF' /usr/local/bin/run.sh
#!/bin/sh
: ${PORT:=8080}
# patch server.xml connector to use $PORT at runtime
sed -ri "s/port=\"8080\" protocol=\"HTTP\/1.1\"/port=\"${PORT}\" protocol=\"HTTP\/1.1\"/" \
  "$CATALINA_HOME/conf/server.xml"
exec catalina.sh run
EOF
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8080
CMD ["/usr/local/bin/run.sh"]
