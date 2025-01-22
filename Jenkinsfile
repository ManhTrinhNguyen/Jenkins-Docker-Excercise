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
