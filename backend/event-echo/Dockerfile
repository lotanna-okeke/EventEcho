FROM adoptopenjdk:11-jre-hotspot
VOLUME /tmp
COPY build/libs/event-echo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
