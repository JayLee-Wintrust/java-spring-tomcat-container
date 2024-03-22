ARG ARTIFACT_ID=SampleApp
ARG ARTIFACT_VERSION=1.0.2-SNAPSHOT
ARG TOMCAT_CONF_DIR=tomcat-conf

FROM docker.io/maven:3.8.8-amazoncorretto-8-al2023 as maven-builder

COPY . /usr/src/app
WORKDIR /usr/src/app
RUN mvn clean package


#SampleApp-1.0.2-SNAPSHOT.war

FROM docker.io/tomcat:8-jdk8
ARG ARTIFACT_ID
ARG ARTIFACT_VERSION
ARG TOMCAT_CONF_DIR
ENV CATALINA_OPTS="-Xms1024m -Xmx4096m -XX:MetaspaceSize=512m -XX:MaxMetaspaceSize=512m -Xss512k"

#COPY --from=maven-builder /usr/src/app/target/${ARTIFACT_ID}-${ARTIFACT_VERSION}.war ${CATALINA_BASE}/webapps/ROOT.war
COPY --from=maven-builder /usr/src/app/target/${ARTIFACT_ID}-${ARTIFACT_VERSION}.war ${CATALINA_HOME}/webapps/ROOT.war
COPY ${TOMCAT_CONF_DIR}/* ${CATALINA_HOME}/conf/

