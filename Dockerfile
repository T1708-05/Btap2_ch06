# ===== Build stage =====
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
# cache deps
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
# build WAR
COPY src ./src
RUN mvn -B -q -DskipTests package

# ===== Run stage (Tomcat 11 / Jakarta) =====
FROM tomcat:11.0-jre17-temurin

# Tắt cổng shutdown để khỏi spam log & xóa webapps mặc định
RUN sed -ri 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml \
 && rm -rf /usr/local/tomcat/webapps/*

# Deploy WAR thành ROOT.war để chạy ở "/"
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# (Tuỳ chọn) hạn chế RAM cho plan Free của Render
ENV CATALINA_OPTS="-Xms128m -Xmx384m"
ENV PORT=8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
