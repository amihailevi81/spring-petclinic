pipeline {
    agent any
    stages {
        stage('Compile') {
            steps {
                sh './mvnw compile'
                echo 'Done compiling'
            }
        }
        stage('Test') {
            steps {
                '
                sh './mvnw test'
                echo 'Test are complete.'
            }
        }    
        stage('Package') {
            steps {
                sh 'docker build -t amihaipet .'
                echo 'Docker Image is ready!'
            }
        }
        stage('Publish') {
            steps {
                echo 'Publishing....'
                sh 'docker tag amihai amihai.jfrog.io/docker/amihai'
                sh 'docker login -u amihai.levi81@gmail.com -p Hardwork1 amihai.jfrog.io'
                sh 'docker push amihai.jfrog.io/docker/amihai'
                echo 'The image is published.'
            }
        }           
    }
}
