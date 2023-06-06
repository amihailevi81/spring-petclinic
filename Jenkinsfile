pipeline {
    agent any
    environment {
        RT_SRV =        'amihai.jfrog.io'
        RT_USER =       credentials('username')
        RT_PASS =       credentials('password')
        RT_TRG_REPO =   'default-docker'
        IMG_NAME =      'amihai'
    }
    stages {
        stage('Compile') {
            steps {
                echo 'Start compiling'
                sh './mvnw compile'
                echo 'Done compiling'
            }
        }
        stage('Test') {
            steps {
                echo 'Start Test.'
                sh './mvnw test'
                echo 'Test are complete.'
            }
        }    
        stage('Package') {
            steps {
                echo 'Start Docker Package'
                sh 'docker build -t amihaipet .'
                echo 'Docker Image is ready!'
            }
        }
        stage('Publish') {
            steps {
                echo 'Publishing....'
                sh 'docker tag "${IMG_NAME}" "${RT_SRV}"/"${RT_TRG_REPO}"/"${IMG_NAME}"'
                sh 'docker login -u "${RT_USER}" -p "${RT_PASS}" "${RT_SRV}"'
                sh 'docker push "${RT_SRV}"/"${RT_TRG_REPO}"/"${IMG_NAME}"'
                echo 'The image is published.'
            }
        }           
    }
}
