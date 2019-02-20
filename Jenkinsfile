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
            npm install
        }
    }
    stage('OWASP Dependency Check'){
        steps{
            bat '/bin/sh -x ${WORKSPACE}/bin/dependencycheck.sh'
        }
    }
    stage('ESLint'){
        steps{
            bat '/bin/sh -x ${WORKSPACE}/bin/eslint.sh'
        }
    }
    stage('Docker Image'){
        steps{
            withCredentials([string(credentialsId: 'AQUA_TOKEN', variable: 'AQUA_TOKEN')]) {
                bat '/bin/sh -x ${WORKSPACE}/bin/dockerimage.sh'
            }
        }
    }
    stage('Docker Clean-up'){
        steps{
            bat '/bin/sh -x ${WORKSPACE}/bin/dockercleanup.sh'
        }
    }
    stage ('Docker Deploy & Zap Scan'){
        steps{
            bat '/bin/sh -x ${WORKSPACE}/bin/zapscan.sh'
        }
    }
    stage('Threadfix Result'){
        steps{
            withCredentials([string(credentialsId: 'THREADFIX_API_KEY', variable: 'THREADFIX_API_KEY')]) {
                bat '/bin/sh -x ${WORKSPACE}/bin/threadfix.sh'
            }
        }
    }
  }
}
