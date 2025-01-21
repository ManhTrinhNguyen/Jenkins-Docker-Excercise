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
