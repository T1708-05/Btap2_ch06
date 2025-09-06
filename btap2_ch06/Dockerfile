# ===== Build stage =====
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# Cache deps
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

# Build WAR
COPY src ./src
RUN mvn -B -q -DskipTests package

# ===== Run stage (Tomcat 11 / Jakarta) =====
FROM tomcat:11.0-jre17-temurin

ENV CATALINA_HOME=/usr/local/tomcat
WORKDIR $CATALINA_HOME

# Tắt cổng shutdown & xóa webapps mẫu
RUN sed -ri 's/port="8005"/port="-1"/' $CATALINA_HOME/conf/server.xml \
 && rm -rf $CATALINA_HOME/webapps/*

# Đổi connector 8080 -> ${PORT} để Tomcat đọc từ System property PORT
# (Tomcat hỗ trợ property substitution trong server.xml)
RUN sed -ri 's/port="8080"/port="${PORT}"/' $CATALINA_HOME/conf/server.xml

# Tạo script start (KHÔNG dùng heredoc)
RUN /bin/sh -c 'echo "#!/bin/sh"                       >  /usr/local/bin/run.sh \
 && /bin/sh -c   "echo \": \${PORT:=8080}\"            >> /usr/local/bin/run.sh" \
 && /bin/sh -c   "echo \"export CATALINA_OPTS=\\\"\\$CATALINA_OPTS -DPORT=\\${PORT}\\\"\" >> /usr/local/bin/run.sh" \
 && /bin/sh -c   "echo \"exec catalina.sh run\"        >> /usr/local/bin/run.sh" \
 && chmod +x /usr/local/bin/run.sh

# Deplo
