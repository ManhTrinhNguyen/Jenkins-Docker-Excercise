@Library('jenkins-shared-library')_

pipeline {
 
  agent any 
  tools {
    gradle 'gradle-8.13'
  }

  stages {
    stage ('Increment Version'){
      steps {
        script {
          echo 'Incrementing Patch Version....'
          gradlePatchVersionUpdate()
          def matcher = readFile('build.gradle') =~ /version\s*=\s*['"](.+?)['"]/
          def version = matcher
          env.IMAGE_NAME = version
        }
      }
    }

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
          buildDockerImage "143.110.228.135:8083/java-app:$IMAGE_NAME"
          dockerLoginToNexus()
          pushDockerImage "143.110.228.135:8083/java-app:$IMAGE_NAME"
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
