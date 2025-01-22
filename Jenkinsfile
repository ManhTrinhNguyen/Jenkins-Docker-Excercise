@Library('jenkins-shared-library')

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
          buildDockerImage()
          dockerLoginToNexus()
          pushDockerImage()
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
