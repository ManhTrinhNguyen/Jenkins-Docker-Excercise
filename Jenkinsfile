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
          sh 'gradle patchVersionUpdate'
          sh 'gradle writeVersionToFile'
          def version = readFile("version.txt").trim()
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
    stage ('Commit version update'){
      steps {
        script {
          withCredentials([usernamePassword(credentials:'github-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]){
            sh 'git config --global user.email jenkins@example.com'
            sh 'git config --global user.name "Jenkins"'

            sh 'git status'
            sh 'git branch'
            sh 'git config --list'

            sh "git remote set-url origin https://${USER}:${PASS}@github.com/ManhTrinhNguyen/Jenkins-Docker-Excercise.git"
            sh 'git add .'
            sh 'git commit -m "ci: version bump"'
            sh 'git push origin HEAD:Using-Shared-Library'
          }
        }
      }
    }
  }
}
