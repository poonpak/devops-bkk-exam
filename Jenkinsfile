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
                        sh "scp -i ${MY_KEY_FILE} -o StrictHostKeyChecking=no myapp.service laborant@target:~"
                        sh """
                                ssh -o StrictHostKeyChecking=no -i ${MY_KEY_FILE} laborant@target '
                                    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
                                    sudo apt-get install -y nodejs
                                    npm install --production
                                    sudo mv ~/myapp.service /etc/systemd/system/myapp.service
                                    sudo systemctl daemon-reload
                                    sudo systemctl restart myapp.service
                                    exit 0
                                '
                            """
                    }
                }
            }
        }
        stage ('Docker Build') {
            steps {
                sh 'docker build -t ttl.sh/myapp-poonpak-p:1h .'
                sh 'docker push ttl.sh/myapp-poonpak-p:1h'
            }
        }
        stage('Deploy to docker') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'my-private-key', keyFileVariable: 'MY_KEY_FILE', usernameVariable: 'MY_USER')]) {
                    script {
                        sh """
                                ssh -o StrictHostKeyChecking=no -i ${MY_KEY_FILE} laborant@docker '
                                    docker run -d -p 4444:4444 ttl.sh/myapp-poonpak-p:1h
                                '
                            """
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                 withKubeConfig([credentialsId: 'my-private-key', serverUrl: 'https://kubernetes:6443']) {
                  sh 'kubectl apply -f deployment.yaml'
                  sh 'kubectl apply -f service.yaml'
                }
            }
        }
    }
}
