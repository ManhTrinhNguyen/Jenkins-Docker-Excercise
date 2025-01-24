FROM openjdk:17.0.2-jdk
EXPOSE 8080
RUN mkdir /opt/app
COPY build/libs/docker-exercises-project-*.jar /opt/app
WORKDIR /opt/app

CMD java -jar docker-exercises-project-*.jar
