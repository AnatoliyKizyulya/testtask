FROM        maven:3.6-jdk-8-slim
RUN         mkdir /myapp
COPY        complete /myapp
WORKDIR     /myapp
RUN         mvn package

FROM        openjdk:11-jdk-slim
WORKDIR     /app
COPY        --from=0 /myapp/target/ping*.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]