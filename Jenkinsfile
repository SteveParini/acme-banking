pipeline {
  agent any
  environment {
    /* Tag image using Docker registry and build tag */
    IMAGE_NAME="${DOCKER_REGISTRY}/psc/acme-banking:${BUILD_TAG}"
    IMAGE_ALIAS="${DOCKER_REGISTRY}/psc/acme-banking:latest"
  }
  stages {
    stage('Build'){
        steps{
            sh '/bin/sh -x ${WORKSPACE}/build/npm.sh'
        }
    }
    stage('OWASP Dependency Check'){
        steps{
            sh '/bin/sh -x ${WORKSPACE}/build/dependencycheck.sh'
        }
    }
    stage('ESLint'){
        steps{
            sh '/bin/sh -x ${WORKSPACE}/build/eslint.sh'
        }
    }
    stage('Docker Image'){
        steps{
            withCredentials([string(credentialsId: 'AQUA_TOKEN', variable: 'AQUA_TOKEN')]) {
                sh '/bin/sh -x ${WORKSPACE}/build/dockerimage.sh'
            }
        }
    }
    stage('Docker Clean-up'){
        steps{
            sh '/bin/sh -x ${WORKSPACE}/build/dockercleanup.sh'
        }
    }
    stage ('Docker Deploy & Zap Scan'){
        steps{
            sh '/bin/sh -x ${WORKSPACE}/build/zapscan.sh'
        }
    }
    stage('Threadfix Result'){
        steps{
            withCredentials([string(credentialsId: 'THREADFIX_API_KEY', variable: 'THREADFIX_API_KEY')]) {
                sh '/bin/sh -x ${WORKSPACE}/build/threadfix.sh'
            }
        }
    }
  }
}
