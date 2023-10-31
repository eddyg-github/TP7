pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'eddyedged/appweb'
        DOCKER_IMAGE_TAG = 'v1' // cambiar entre prueba y prueba para que no haya conflicto al subirlo a Dockerhub
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_id')
        
    }

    stages {
        stage('Verificación') {
            steps {
                checkout scm
            }
        }

        stage('Build y despliegue') {
            steps {
                script {
                    
                    sh "docker build -t \${DOCKER_IMAGE_NAME}:\${DOCKER_IMAGE_TAG} ."
                }
            }
        }

        stage('Ejecución del contenedor') {
            steps {
                script {
                    sh "docker ps -q --filter name=appweb | xargs docker stop || true"
                    sh "docker ps -aq --filter name=appweb | xargs docker rm || true"
                    sh "docker run -d --name appweb -p 8080:80 --name eddyedged/appweb \${DOCKER_IMAGE_NAME}:\${DOCKER_IMAGE_TAG}"
                }
            }
        }

        stage('Pruebas de contenedor') {
            steps {
                script {
                    sh "docker exec appweb ls /usr/share/nginx/html/saludo.html"
                    sh "curl -I http://localhost:8080/saludo.html" 
                }
            }
        }

        stage('Subir la imagen a DockerHub') {
            steps {
                script {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'

                    sh 'docker tag \${DOCKER_IMAGE_NAME}:\${DOCKER_IMAGE_TAG} eddyedged/appweb:\${DOCKER_IMAGE_TAG}'
                    
                    sh "docker push eddyedged/appweb:\${DOCKER_IMAGE_TAG}"

                    }
                }
            }
        }
    
    post {
        success {
            echo 'Pipeline ejecutado con éxito: Imagen Docker construida, contenedor en ejecución y prueba de acceso a la página web exitosa.'
        }
        failure {
            error 'Error en la ejecución del pipeline: Error al construir la imagen Docker, ejecutar el contenedor o realizar la prueba de acceso a la página web.'
        }
    }
}
