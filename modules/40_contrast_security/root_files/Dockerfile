# Intermediate container for packaging WebGoat 7.x Lessons
FROM maven:3.6.1-jdk-8 AS lesson-builder
WORKDIR /webgoat-lessons
COPY ./WebGoat-Lessons /webgoat-lessons
RUN mvn clean package

# Intermediate container for packaging WebGoat 7.x WAR executable
FROM maven:3.6.1-jdk-8 AS webgoat-builder
WORKDIR /webgoat
COPY ./WebGoat /webgoat
COPY --from=lesson-builder /webgoat-lessons/target/plugins /webgoat/webgoat-container/src/main/webapp/plugin_lessons
RUN mvn clean compile install package

# Get the Contrast Agent from Maven
FROM busybox:1.31.0 AS contrast-downloader
WORKDIR /opt/contrast
ARG CONTRAST_AGENT_VERSION=3.6.8.10823
RUN wget -O contrast.jar https://repo1.maven.org/maven2/com/contrastsecurity/contrast-agent/$CONTRAST_AGENT_VERSION/contrast-agent-$CONTRAST_AGENT_VERSION.jar

# Build final image for running WebGoat application with Contrast
FROM openjdk:8-alpine3.9
WORKDIR /app
COPY --from=webgoat-builder /webgoat/webgoat-container/target/webgoat-container-7.1-war-exec.jar ./webgoat-container-7.1-war-exec.jar
COPY --from=contrast-downloader /opt/contrast/contrast.jar /opt/contrast/contrast.jar
COPY ./contrast_security.yaml.tpl /opt/contrast/contrast_security.yaml.tpl
COPY ./entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["--httpPort", "80"]
