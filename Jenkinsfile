pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                // Clean workspace before cloning (optional)
                deleteDir()

                // Clone the Git repository
                git branch: 'main',
                    url: 'https://github.com/rahulwagh/devops-project-1.git'

                sh "ls -lart"
            }
        }
    }

    stage('Terraform Init') {
                steps {
                    script {
                        // Run 'terraform init' command
                        sh 'cd infra'
                        sh 'terraform init'
                    }
            }
    }

}