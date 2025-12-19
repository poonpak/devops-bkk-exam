pipeline {
    agent any

    tools {
       nodejs "node-lts"
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
                withCredentials([sshUserPrivateKey(credentialsId: 'my-private-key', keyFileVariable: 'MY_KEY_FILE', usernameVariable: 'MY_USER')]) {
                    script {
                        sh "scp -o StrictHostKeyChecking=no -i ${MY_KEY_FILE} index.js package.json laborant@target:~"
                        sh "scp -i ${MY_KEY_FILE} -o StrictHostKeyChecking=no main laborant@target:~"
                        sh "scp -i ${MY_KEY_FILE} -o StrictHostKeyChecking=no myexam.service laborant@target:~"
                        sh """
                                ssh -o StrictHostKeyChecking=no -i ${MY_KEY_FILE} laborant@target '
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
}
