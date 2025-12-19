pipeline {
    agent any

    tools {
       go "node-lts"
    }

    stages {
        stage('Test') {
            steps {
                sh 'npm install'
                sh 'npm test' 
            }
        }
        stage('Deploy to target') {
            steps {
                withCredentials([string(credentialsId: 'my-private-key', variable: 'SSH_KEY')]) {
                    script {
                        sh 'echo "$SSH_KEY" > deploy.key && chmod 600 deploy.key'
                        sh "scp -o StrictHostKeyChecking=no -i deploy.key index.js package.json laborant@target:~"
                    }
                }
            }
            steps {
                withCredentials([file(credentialsId: 'my-key-file', variable: 'KEY_PATH')]) {
                    sh "chmod 400 ${KEY_PATH}"
                    sh "scp -i ${KEY_PATH} -o StrictHostKeyChecking=no main laborant@target:~"
                    sh "scp -i ${KEY_PATH} -o StrictHostKeyChecking=no myexam.service laborant@target:~"
                    sh """
                            ssh -o StrictHostKeyChecking=no -i deploy.key laborant@target '
                                npm install --production
                                sudo mv ~/myexam.service /etc/systemd/system/myexam.service
                            sudo systemctl daemon-reload
                            sudo systemctl restart myexam.service
                            exit 0
                            '
                        """
                }
            }
        }
    }
}
