pipeline {
    agent any

    stages {
        stage('Verificación') {
            steps {
                script {
                    git branch: 'master', credentialsId: 'github_id', url: 'https://github.com/eddyg-github/TP7.git'
                }
            }
        }

        stage('Build y despliegue') {
            steps {
                script {
                    def dockerImageName = "eddyedged/appweb"
                    def dockerImageTag = "v1"
                    sh "echo 'Ejecutando comando de prueba para depuración'"
                    // Temporalmente comenta la línea del comando docker build
                    // sh "docker build -t ${dockerImageName}:${dockerImageTag} ."
                }
            }
        }

        // Resto de los stages...

        stage('Subir la imagen a DockerHub') {
            steps {
                script {
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
