# Configure and run the application with Mysql database on a server using docker-compose
## 🚀 Technologies Used
- **Docker, Dockerfile, Docker-Compose**
- **DigitalOcean**
- **Linux**
- **Mysql**
- **phpmyadmin Mysql GUI**
## Using a Enviroment for Database and Credentials inside the Application
1. Don't want to hardcode into the App .
2. These value may change based on the Enviroment . I want to be able to dynamically when deploying the application instead of hardcode them

## Install Docker 
1. In Linux OS : `apt install docker.io`
2. In Mac or Window : Download Docker Desktop `https://docs.docker.com/desktop/setup/install/mac-install/`

## Start Mysql container
1. **Run MySql as the Docker container using official Docker image**: `docker run -d -p 3306:3306 --name mysql -v mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secrect-password -e MYSQL_USER=my-user-name -e MYSQL_PASSWORD=my-user-password -e MYSQL_DATABASE=database-name mysql`
   1. **--name mysql**: name of the container
   2. **-v mysql-data:/var/lib/mysql** : Set volume name as mysql-data to persist data
   3. **-e MYSQL_ROOT_PASSWORD=my-secrect-password**: Set root password Environment
   4. **-e MYSQL_USER=my-user-name** : Set user Environment
   5. **-e MYSQL_PASSWORD=my-user-password** : Set user password Environment
   6. **-e MYSQL_DATABASE=database-name** : Set database name Environment
   7. **mysql** : Image of mysql from Docker
   8. **-p 3306:3306** : mysql run on port 3306
      - I can have 2 Container listen on the same port as long as I bind them from 2 different port from the Host OS
   9. **--network your-network**: If I not start container from Docker-Compose i need to network the connect container
2. **Set Variable Env in Local or Server depend on where My App running** : If My app run on a server i have to set Variable ENV in my Server

 ## Start GUI Mysql Container (phpmyadmin)
 1. **Run phpmyadmin as the Docker container using official Docker image**: `docker run -d --network mysql-network --name phpmyadmin --link mysql:db -p 8080:80 phpmyadmin`
    1. **--name phpmyadmin** : Create name for phpmyadmin container
    2. **--link mysql:db**: Link to mysql database by mysql name
    3. **-p 8080:80**: create port
    4. **phpmyadmin**: phpmyadmin image
    5. **--network mysql-network**: connect to mysql network
    6. Using mysql username and password to access Bcs the container already link to mysql

##  Use docker-compose for Mysql and Phpmyadmin
- **If I use docker-compose to run Mysql and Phpmyadmin I don't need to create network**
- Instead of run Mysql like this in CLI: `docker run -d -p 3306:3306 --name mysql -v mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secrect-password -e MYSQL_USER=my-user-name -e MYSQL_PASSWORD=my-user-password -e MYSQL_DATABASE=database-name mysql` :
- And instead of run phpmyadmin like this : `docker run -d --network mysql-network --name phpmyadmin --link mysql:db -p 8080:80 phpmyadmin` **use docker-compose**
1. **Create Docker-Compose file**: Docker-compose is create in yaml file
2. **Version of docker compose** :Using version 3
3. **Services Section**: Service to run (example: Mysql , Mongodb .... etc)
   1. **MySql Image name**: my-mysql (I can put any name as long as I understand that is mysql)
      1. **Image**: `image:mysql` (Actual image from Docker hub)
      2. **ports** : `ports: - 3306:3306`
      3. **enviroment***: `enviroment : - MYSQL_ROOT_PASSWORD=my-secrect-password, - MYSQL_USER=my-user-name, -MYSQL_PASSWORD=my-user-password -MYSQL_DATABASE=database-name`
      4. **volumes**: - mysql-data:/var/lib/mysql
   2. **phpmyadmin Image name** phpmyadmin (I can put any name as long as I understand that is mysql)
      1. **Image**: `image:phpmyadmin` (Actual image from Docker hub)
      2. **restart**: `restart: alway` **Because phpmyadmin need Mysql to be ready to connect . Sometime it faile bcs mysql not ready yet so if it failed just need to restart until mysql ready**
      3. **ports**: `ports: - 8080:80`
      4. **enviroment**: `enviroment : - PMA_ARBITRARY=1 - PMA_HOST=my-mysql - PMA_PORT=3306`
4. **Volume**:
      1. **db-name**: mysql
         - driver: local **This is a additional infomation for Docker to create that physical storage on the local file system**      
```
version: '3'
services:
  mysql:
    image: mysql
    ports:
      - 3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=rootpassword
      - MYSQL_USER=admin
      - MYSQL_PASSWORD=password
      - MYSQL_DATABASE=java-app 

    volumes:
      - mysql-data:/var/lib/mysql 
  phpmyadmin:
    image: phpmyadmin
    restart: always
    ports:
      - 8081:80
    environment:
      - PMA_ARBITRARY=1
      - PMA_HOST=mysql 
      - PMA_PORT=3306
volumes:
  mysql-data:
    driver: local
```

## Create Docker Image (Dockerfile)
1. **FROM** : Image Name from Dockerhub (Base on another Image in Docker hub to create another Image)
  - If I have Java Application I will use jdk image or other that support Java
  - If I have Node Application I will use node image 
  - The main point is I don't need to install jdk or node again in the server . It already install in the image
2. **ENV** : Optional | to define your app enviroment. 
  - It is better to create enviroment in external docker-compose file ... 
  - If something change I don't need to recreate Image 
3. **RUN** : Using RUN to run any linux command 
  - `RUN mkdir -p /home/app`: /home/app will create inside of the container 
4. **COPY** : This Copy command will execute from the Host .
  - `COPY . /home/app`  from source in the host to target in the container
5. **CMD** : Execute an entry point from linux command 
  - `CMD ['java', '-jar', 'docker-exercises-project-1.0-SNAPSHOT.jar']`
6. **WORKDIR** : set the working directory 
  - `WORKDIR /home/app`

```
FROM openjdk:17.0.2-jdk

RUN mkdir -p /home/java-app

COPY build/libs/docker-exercises-project-1.0-SNAPSHOT.jar /home/java-app

WORKDIR /home/java-app 

CMD ["java", "-jar", "docker-exercises-project-1.0-SNAPSHOT.jar"]
```
## Add Java App Image to Docker-Compose
```
version: '3.8'
services:
  java-app:
      image: java-app:1.1
      ports:
        - 8080:8080
      environment:
        - DB_USER=${DB_USER}
        - DB_PWD=${DB_PWD}
        - DB_SERVER=${DB_SERVER}
        - DB_NAME=${DB_NAME}
      depends_on:
        - mysql

  mysql:
    image: mysql
    ports:
      - 3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_USER=${DB_USER}
      - MYSQL_PASSWORD=${DB_PWD}
      - MYSQL_DATABASE=${DB_NAME}
    volumes:
      - mysql-data:/var/lib/mysql 
    
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: always

  phpmyadmin:
    image: phpmyadmin
    restart: always
    ports:
      - 8081:80
    environment:
      - PMA_ARBITRARY=1
      - PMA_HOST=${PMA_HOST}
      - PMA_PORT=${PMA_PORT}
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
    container_name: phpmyadmin
    depends_on: 
        - mysql
volumes:
  mysql-data:
    driver: local
```
- **Security Practice** : I put everything in ${} `${DB_PWD}` .... etc . When i need to run this Docker-compose I will configure in the specific ENV of the Server . No one can see my DB password via my docker-compose 
- **Heathy check service** : `test: [ "CMD", "mysqladmin", "ping", "-h", "localhost" ]`
  - Ensure Docker check health of Mysql Container 
  - If the health check fails, the service is marked as unhealthy, and dependent services wait until it becomes healthy.
    - Runs the `mysqladmin ping` command inside the container to check if the MySQL server is running and reachable.
    - `h "localhost"` specifies the target hostname, which is the MySQL container itself.
    - If the command returns mysqld is alive, the service is considered healthy.
    - `interval` : Specific how often Docker check service health
    - `timeout`: Specifies the maximum time the health check can take before it's considered failed (5 seconds).
    - `retries: 5`: Specifies the number of times the health check can fail before the container is marked as unhealthy. 

## Create a Pipeline Jenkins to auto test build and push the image to Repo Manager 
### Push Docker Image to Nexus 
1. **Rent a Server on Digital Ocean**
2. **Install Nexus**
  - Run Nexus as a Docker Container: 
    - Create nexus volumn to persist data: `$ docker volume create --name nexus-data`
    - Run Nexus: `$ docker run -d -p 8081:8081 -p 8083:8083 --name nexus -v nexus-data:/nexus-data sonatype/nexus3`
      - **-d**: Detach mode
      - **-p 8081:8081 -p 8083:8083** : Nexus run on port 8081. To connect with docker use port 8083 
      - **--name** : Create a name
      - **-v nexus-data:/nexus-data**: Create nexus volume . First part is name of nexus volume. Second part is where nexus data is stored in Nexus Container .
      - **sonatype/nexus3**: Nexus Image
  - Create new docker-hosted Repo 
    - In oder to start pushing Docker Image to Nexus Repo I first have to login to Nexus using a Nexus User which have access to docker-hosted Repo
  - Create a new User for Docker Repo on nexus 
  - Create Role for that User 
  - Configure to connect to Nexus : 
    - Docker client can not use Nexus endpoint to connect to the Repo bcs that endpoin is Nexus running itself . So I need to create a new port for docker-repo specificlly . 
    - Configure Realms : When I do Docker login I have a token of authentication from Nexus Docker-Repo for client . That token will be store on my local machine /.docker/config.json
3. **Install Jenkins**
  - **Run Jenkins as a Docker container** 
    - Run Jenkins Images : `docker run -d -p 8080:8080 -p 50000:50000 -v jenkins-home:/var/jenkins-home -v /var/run/docker.sock:/var/run/docker.sock jenkins/jenkins`
      - **-d**: Detach mode
      - **-p 8080:8080** : Jenkins run on port 8080
      - **-v jenkins-home:/var/jenkins-home**: Create jenkins volumn to persist data 
      - **-v /var/run/docker.sock:/var/run/docker.sock**: This will mount docker CLI to Jenkins container so docker CLI will available in jenkins container 
      - **jenkins/jenkins**: Jenkins Image
  - **Install docker inside Jenkins container** :  `curl https://get.docker.com/ > dockerinstall && chmod 777 dockerinstall && ./dockerinstall`
  - **Inside get inside jenkins container as root**: `chmod o=rw /var/run/docker.sock` to make other user can use docker CLI in the container
4. **Create Pipelines to build and push Docker image to Nexus**
  - Configure Github and Nexus Credentials on Jenkins 
  - **Create Pipeline** 
    - Add Jenkinsfile in the project
    - **Configure Webhook Trigger pipeline job automatically**
      - From pipeline Enable : `GitHub hook trigger for GITScm polling`
      - From Github : In the Repo go to : Setting -> Webhook -> Add Web Hook
    - **Create Jenkinsfile**:
      ```
      pipeline {
        agent any 
        tools {
          gradle 'gradle-8.13'
        }

        stages {
          stage ('test java maven app') {
            steps {
              script {
                echo 'Testing .....'
              }
            }
          }
          stage ('build java maven app') {
            steps {
              script {
                echo 'Build Java maven app ....'
                sh 'gradle clean build'
              }
            }
          }
          stage('build and push Docker image'){
            steps {
              script {
                withCredentials([usernamePassword(credentialsId: 'nexus-credentials', usernameVariable: 'USER', passwordVariable:'PWD')]){
                  sh 'docker build -t 143.110.228.135:8083/java-app:2.0 .'
                  sh "echo ${PWD} | docker login -u ${USER} --password-stdin 143.110.228.135:8083"
                  sh 'docker push 143.110.228.135:8083/java-app:2.0'
                }
              }
            }
          }
          stage ('deploy java maven app') {
            steps {
              script {
                echo 'Deploying Application ..'
              }
            }
          }
        }
      }
    ```

## Dynamic Increment Application version in Jenkins Pipeline 
1. **Dynamic Increment Gradle Application** : https://theekshanawj.medium.com/gradle-automate-application-version-management-with-gradle-4b97e1df84a3
2. **Create Increment version Stage on the top of every stage** : 
  1. **Increment version (major, minor, or patch)**: `sh 'gradle patchVersionUpdate'`
  2. **Write version to version.txt file**: `sh 'gradle writeVersionToFile'`
  3. **Readfile from version.txt**: `def version = readFile("version.txt").trim()`
3. **Make Jenkins commit the Increment**: 
  1. **Add the commit stage at the last**: 
  2. **Need access credentials to connect to Git**  
  3. **Set the Remote URL** : `sh "git remote set-url origin https://${USER}:${PASS}@github.com/ManhTrinhNguyen/Jenkins-Docker-Excercise.git"`
  4. **Add, Commit and Push**: `sh 'git add .' | sh 'git commit -m "ci: version bump"' | sh 'git push origin HEAD:Using-Shared-Library'` 
`

