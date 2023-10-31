pipeline {
    agent any

    stages {
        stage('Verificación') {
            steps {
                script {
                    // Clonar el repositorio de GitHub con las credenciales
                    git branch: 'master', credentialsId: 'github_id', url: 'https://github.com/eddyg-github/TP7.git'
                }
            }
        }

        stage('Build y despliegue') {
            steps {
                script {
                    // Nombre de la imagen en DockerHub
                    def dockerImageName = "eddyedged/appweb"
                    // Versión de la imagen en DockerHub
                    def dockerImageTag = "v1"
                    // Construir la imagen Docker
                    sh "docker build -t ${dockerImageName}:${dockerImageTag} ."
                }
            }
        }




        stage('Ejecución del contenedor') {
            steps {
                script {
                    // Detener y eliminar contenedor si existe
                    sh "docker ps -q --filter name=appweb | xargs docker stop || true"
                    sh "docker ps -aq --filter name=appweb | xargs docker rm || true"

                    // Ejecutar el contenedor con la imagen recién creada
                    sh "docker run -d --name appweb -p 8080:80 ${dockerImageTag}" // Cambia 8080 al puerto deseado
                }
            }
        }

        stage('Pruebas de contenedor') {
            steps {
                script {
                    // Ejecutar pruebas
                    sh "docker exec appweb ls /usr/share/nginx/html/saludo.html"
                    sh "curl http://localhost:8080/saludo.html" // Verificar acceso al archivo HTML
                }
            }
        }

        stage('Subir la imagen a DockerHub') {
            steps {
                script {
                    // Subir la imagen a DockerHub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "echo \${PASSWORD} | docker login -u \${USERNAME} --password-stdin"
                        sh "docker tag ${dockerImageTag} eddyedged/appweb:v1"
                        sh "docker push eddyedged/appweb:v1"
                    }
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
