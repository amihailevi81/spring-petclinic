pipeline {
    agent any
    environment {
        Artifactory_Repo = 'docker'
        Artifactory_Username = credentials('username')
        Artifactory_Password = credentials('password')
        Artifactory_SRV = 'amihai.jfrog.io'
        Image_Name = 'amihaipet'
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
                sh 'docker build . -t ""${Image_Name}""'
                echo 'Docker Image is ready!'
            }
        }
        stage('Publish') {
            steps {
                echo 'Publishing....'
                sh 'docker tag "${Image_Name}" "${Artifactory_SRV}"/"${Artifactory_Repo}"/"${Image_Name}"'
                sh 'docker login -u "${Artifactory_Username}" -p "${Artifactory_Password}" "${Artifactory_SRV}"'
                sh 'docker push "${Artifactory_SRV}"/"${Artifactory_Repo}"/"${Image_Name}"'
                echo 'The image is published.'
            }
        }           
    }
}
