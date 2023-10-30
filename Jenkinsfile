pipeline {
    agent any

    stages {
        stage('Build y despliegue') {
            steps {
                script {
                    def dockerImageTag = "eddyedged/appweb:v1" // Nombre de la imagen

                    // Construir la imagen Docker
                    sh "docker build -t ${dockerImageTag} ."

                    // Detener y eliminar contenedor si existe
                    sh "docker ps -q --filter name=appweb | xargs docker stop || true"
                    sh "docker ps -aq --filter name=appweb | xargs docker rm || true"

                    // Ejecutar el contenedor con la imagen recién creada
                    sh "docker run -d --name appweb -p 8080:80 ${dockerImageTag}" // Cambia 8080 al puerto deseado

                    // Ejecutar pruebas
                    sh "docker exec appweb ls /usr/share/nginx/html/saludo.html"
                    sh "curl http://localhost:8080/saludo.html" // Verificar acceso al archivo HTML

                    // Subir la imagen a DockerHub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "echo Inflames21! | docker login -u eddyedged --password-stdin"
                        sh "docker tag ${dockerImageTag} eddyedged/appweb:v1"
                        sh "docker push eddyedged/appweb:v1"
                    }
                }
            }
        }
    }
}
