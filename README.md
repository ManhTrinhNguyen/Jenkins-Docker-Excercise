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
 2.      
   

