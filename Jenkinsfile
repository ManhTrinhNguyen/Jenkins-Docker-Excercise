@Library('jenkins-shared-library')_

pipeline {
 
  agent any 
  tools {
    gradle 'gradle-8.13'
  }

  stages {
    stage ('test java gradle app') {
      steps {
        script {
          echo 'Testing .....'
        }
      }
    }
    stage ('build java gradle app') {
      steps {
        script {
          echo 'Build Java Gradle app ....'
          buildGradleJar()
        }
      }
    }
    stage('build and push Docker image'){
      steps {
        script {
          buildDockerImage '143.110.228.135:8083/java-app:2.2'
          dockerLoginToNexus()
          pushDockerImage '143.110.228.135:8083/java-app:2.2'
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
