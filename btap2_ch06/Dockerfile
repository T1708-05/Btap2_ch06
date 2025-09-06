# ===== Build stage =====
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q -DskipTests package

# ===== Run stage (Tomcat 11 / Jakarta) =====
FROM tomcat:11.0-jre17-temurin
ENV CATALINA_HOME=/usr/local/tomcat
WORKDIR $CATALINA_HOME

# Tắt shutdown port, xoá apps mẫu
RUN sed -ri 's/port="8005"/port="-1"/' $CATALINA_HOME/conf/server.xml \
 && rm -rf $CATALINA_HOME/webapps/*

# Để Tomcat bind theo biến môi trường PORT do Render cấp
# (Tomcat 10+/11 hỗ trợ ${env.VAR} trong server.xml)
RUN sed -ri 's/port="8080"/port="${env.PORT}"/' $CATALINA_HOME/conf/server.xml

# Deploy WAR làm ROOT.war
COPY --from=build /app/target/*.war $CATALINA_HOME/webapps/ROOT.war

# Gợi ý RAM
ENV CATALINA_OPTS="-Xms128m -Xmx384m"

EXPOSE 8080
CMD ["catalina.sh","run"]
