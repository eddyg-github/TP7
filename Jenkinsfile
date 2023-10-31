pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'eddyedged/appweb'
        DOCKER_IMAGE_TAG = 'v1' 
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_id')
        
    }

    stages {
        stage('Verificación') {
            steps {
                checkout scm
            }
        }

        stage('Build de la imagen') {
            steps {
                script {
                    
                    sh "docker build -t \${DOCKER_IMAGE_NAME}:\${DOCKER_IMAGE_TAG} ."
                }
            }
        }

        stage('Ejecución del contenedor') {
            steps {
                script {
                    sh 'docker ps -f name=tpn7 -q | xargs --no-run-if-empty docker container stop'
                    sh 'docker container ls -a -fname=tpn7 -q | xargs -r docker container rm'
                    sh "docker run -d -p 9090:80 --name tpn7 \${DOCKER_IMAGE_NAME}:\${DOCKER_IMAGE_TAG}"
                }
            }
        }

    stage('Pruebas de contenedor') {
            steps {
                script {
                    sh 'cat /var/www/html/index.html'
                    sh "curl -I http://192.168.56.10:9090/index.html"
                }
            }
        }    
    
        stage('Pushear a Dockerhub') {
            steps {
                script {

                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'

                    sh 'docker tag \${DOCKER_IMAGE_NAME}:\${DOCKER_IMAGE_TAG} eddyedged/appweb:\${DOCKER_IMAGE_TAG}'

                    sh "docker push eddyedged/appweb:\${DOCKER_IMAGE_TAG}"
                    
                    
                }
            }
        }

    }

    post ('Resultado'){
        success {
            echo 'Imagen Docker construida, contenedor en ejecución y prueba de acceso a la página web exitosa.'
        }
        failure {
            error 'Error al construir la imagen Docker, ejecutar el contenedor o realizar la prueba de acceso a la página web.'
    
        }
    }
}
