pipeline {
    agent any
    environment {
        APP_SERVER = 'ubuntu@172.31.24.189'
    }
    stages {
        stage('Set Target Repo') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'master') {
                        env.IMAGE = 'ajayrag/prod'
                    } else {
                        env.IMAGE = 'ajayrag/dev'
                    }
                    echo "Branch ${env.BRANCH_NAME} -> image ${env.IMAGE}"
                }
            }
        }
        stage('Build Image') {
            steps {
                sh './build.sh ${IMAGE} ${BUILD_NUMBER}'
                sh 'docker tag ${IMAGE}:${BUILD_NUMBER} ${IMAGE}:latest'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
                    sh 'echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin'
                    sh 'docker push ${IMAGE}:${BUILD_NUMBER}'
                    sh 'docker push ${IMAGE}:latest'
                }
            }
        }
        stage('Deploy to Server') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
                    sh 'echo "$DH_PASS" | ssh ${APP_SERVER} "docker login -u $DH_USER --password-stdin"'
                }
                sh 'ssh ${APP_SERVER} "bash -s -- ${IMAGE} latest" < deploy.sh'
            }
        }
    }
}
