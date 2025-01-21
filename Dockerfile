FROM tomcat 

RUN mkdir -p /home/java-app

COPY build/libs/docker-exercises-project-1.0-SNAPSHOT.jar /home/java-app

WORKDIR /home/java-app 

CMD ["java", "-jar", "docker-exercises-project-1.0-SNAPSHOT.jar"]
