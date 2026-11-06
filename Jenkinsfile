pipeline {
    agent { label 'podman' }

    options {
        disableConcurrentBuilds()
    }

    triggers {
        pollSCM('H/2 * * * *')
    }

    environment {
        REGISTRY = 'registry.assign.117484261.300.ops:5000'
        IMAGE    = 'bind-secondary'
    }

    stages {
        stage('Build') {
            steps {
                sh '''
                    SHORT_SHA=$(git rev-parse --short HEAD)
                    podman build \
                        -t ${REGISTRY}/${IMAGE}:${BUILD_NUMBER} \
                        -t ${REGISTRY}/${IMAGE}:${SHORT_SHA} .
                '''
            }
        }

        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'registry-creds',
                                                  usernameVariable: 'REG_USER',
                                                  passwordVariable: 'REG_PASS')]) {
                    sh '''
                        SHORT_SHA=$(git rev-parse --short HEAD)
                        echo "$REG_PASS" | podman login --username "$REG_USER" --password-stdin ${REGISTRY}
                        podman push ${REGISTRY}/${IMAGE}:${BUILD_NUMBER}
                        podman push ${REGISTRY}/${IMAGE}:${SHORT_SHA}
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'podman logout ${REGISTRY} || true'
        }
    }
}
