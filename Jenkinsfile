pipeline {

    triggers {
        pollSCM('H/5 * * * *')
    }

    agent any

    stages {
        stage('checkout') {
            checkout scm
        }

        stage('test') {
            
        }

        stage('Aceptación') {
            parallel {
                stage('Aceptación team 1') {
                    agent { label 'master' }
                    steps{
                        sh 'rm -Rf target'
                        unstash 'obe-server'
                        unstash 'obe-client'
                        withCredentials([usernamePassword(credentialsId: 'flyway-creds-ci', usernameVariable: 'FLYWAY_USER', passwordVariable: 'FLYWAY_PASS')]) {
                            sh "./desplegar.sh ci --skip-shutdown"
                            sh "./pipeline/aceptacion.sh ci"
                        }
                    }
                    post {
                        always {
                            stash includes: 'target/site/**/*', allowEmpty: true, name: 'acceptancetest1'
                            stash includes: 'target/failsafe/**/*', allowEmpty: true, name: 'obe-server-test-results1'
                        }
                    }
                }
                stage('Aceptación team 2') {
                    agent { label 'slave' }
                    steps {
                        sh 'rm -Rf target'
                        unstash 'obe-server'
                        unstash 'obe-client'
                        withCredentials([usernamePassword(credentialsId: 'flyway-creds-ci2', usernameVariable: 'FLYWAY_USER', passwordVariable: 'FLYWAY_PASS')]) {
                            sh "./desplegar.sh ci2 --skip-shutdown"
                            sh "./pipeline/aceptacion.sh ci2"
                        }
                    }
                    post {
                        always {
                            stash includes: 'target/site/**/*', allowEmpty: true, name: 'acceptancetest2'
                            stash includes: 'target/failsafe/**/*', allowEmpty: true, name: 'obe-server-test-results2'
                        }
                    }
                }
                stage('Aceptación team 3') {
                    agent { label 'ci3' }
                    steps {
                        sh 'rm -Rf target'
                        unstash 'obe-server'
                        unstash 'obe-client'
                        withCredentials([usernamePassword(credentialsId: 'flyway-creds-ci3', usernameVariable: 'FLYWAY_USER', passwordVariable: 'FLYWAY_PASS')]) {
                            sh "./desplegar.sh ci3 --skip-shutdown"
                            sh "./pipeline/aceptacion.sh ci3"
                        }
                    }
                    post {
                        always {
                            stash includes: 'target/site/**/*', allowEmpty: true, name: 'acceptancetest3'
                            stash includes: 'target/failsafe/**/*', allowEmpty: true, name: 'obe-server-test-results3'
                        }
                    }
                }
            }
        }

        stage('Publicar artefactos') {
            agent { label 'master' }
            steps {
                sh 'rm -Rf target'
                unstash 'obe-server'
                unstash 'obe-client'
                withCredentials([string(credentialsId: 'ARTIFACTORY_CREDENTIALS', variable: 'ARTIFACTORY_CREDENTIALS')]) {
                    sh "./pipeline/publicar-artefactos.sh"
                }
            }
        }

        stage('Publicar Pactos') {
            agent { label 'ci3' }
            steps {
                unstash 'pactos'
                sh "./pipeline/publicar-pactos.sh"
            }
        }

        stage('Despliegue a Demo') {
            agent { label 'master' }
            steps {
                sh 'rm -Rf target'
                unstash 'obe-server'
                withCredentials([string(credentialsId: 'ARTIFACTORY_CREDENTIALS', variable: 'ARTIFACTORY_CREDENTIALS')]) {
                    sh """
                        WAR_FILE=`ls target/*.war | sed 's/target\\///'`
                        VERSION=`echo \${WAR_FILE} | sed 's/obe-server-//' | sed 's/.war//'`

                        ./pipeline/obtener-artefactos.sh \${VERSION} snapshot
                    """
                }
                withCredentials([usernamePassword(credentialsId: 'flyway-creds-demo', usernameVariable: 'FLYWAY_USER', passwordVariable: 'FLYWAY_PASS')]) {
                    sh """
                        WAR_FILE=`ls target/*.war | sed 's/target\\///'`
                        export VERSION=`echo \${WAR_FILE} | sed 's/obe-server-//' | sed 's/.war//'`

                        ./desplegar.sh demo --skip-shutdown
                    """
                }
            }
        }
    }

    post {
        failure {
            mail(to: "OBE-EquipoTecnico@supervielle.com.ar,obe-desarrollo@grupoesfera.com.ar",
                 subject: "Falló en #${BUILD_NUMBER}",
                 body: "${env.BUILD_URL}",
                 from: "obe-pipeline <JenkinsAdmin@supervielle.com.ar>",
                 mimeType: "text/html"
            )
        }

        fixed {
            mail(to: "OBE-EquipoTecnico@supervielle.com.ar,obe-desarrollo@grupoesfera.com.ar",
                 subject: "Se arregló en #${BUILD_NUMBER}",
                 body: "${env.BUILD_URL}",
                 from: "obe-pipeline <JenkinsAdmin@supervielle.com.ar>",
                 mimeType: "text/html"
            )
        }

        always {
            unstash 'obe-client-test-results'
            unstash 'obe-server-test-results'
            unstash 'obe-server-test-results1'
            unstash 'obe-server-test-results2'
            unstash 'obe-server-test-results3'
            junit allowEmptyResults: true, testResults:'target/surefire-reports/*.xml, target/failsafe-reports/*.xml, src/main/frontend/ember_test_results.xml'

            unstash 'acceptancetest1'
            unstash 'acceptancetest2'
            unstash 'acceptancetest3'

            sh 'mvn serenity:aggregate'
            publishHTML target: [
                reportName: 'Serenity',
                reportFiles: 'index.html',
                reportDir: 'target/site/serenity',
                keepAll: true,
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                includes: '**/*'
            ]
        }
    }
}
