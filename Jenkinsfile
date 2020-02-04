@Library('jenkings') _

def getNodeHostname() {
  script {
    sh 'hostname -f'
  }
}

def getGitTag() {
  echo 'trying to get git tag'
  GIT_TAG = sh(script: 'git tag -l --contains HEAD', returnStdout: true).trim()
  echo "detected tag : ${GIT_TAG}"
  GIT_COMMIT_DESCRIPTION = sh(script: 'git log -n1 --pretty=format:%B', returnStdout: true).trim()
  echo "current description : ${GIT_COMMIT_DESCRIPTION}"
}

def buildDockerImage(image, arch, tag) {
  return docker.build("${image}:${arch}-${tag}", "--pull --build-arg ARCH=${arch} -f docker/Dockerfile .")
}

def pushDockerImage(img, arch, tag) {
  def githubImage = "docker.pkg.github.com/majorcadevs/docker-icecast-$arch:$tag"
  script {
    docker.withRegistry('https://registry.hub.docker.com', 'bobthabuilda') { 
      img.push("${arch}-${tag}")  
    }

    docker.withRegistry('https://docker.pkg.github.com', 'amgxv-github-token') {
      sh "docker image tag ${img.id} ${githubImage}"
      docker.image(githubImage).push()  
    }
  }
}

pipeline {
  agent { label '!docker-qemu' }
  environment {
    image = 'majorcadevs/icecast'
    chatId = credentials('amgxv-telegram-chatid')
    GIT_COMMIT_DESCRIPTION = ''
    GIT_TAG = ''
  }

  stages {
    stage('Preparation') {
      steps {
        telegramSend 'icecast is being built [here](' + env.BUILD_URL + ')... ', chatId
      }
    }

    stage ('Build Docker Images') {
      parallel {
        stage ('docker-amd64') {
          agent {
            label 'docker-qemu'
          }

          environment {
            arch = 'amd64'
            tag = 'latest'
            img = null
          }

          stages {
            stage ('Current Node') {
              steps {
                getNodeHostname()
              }
            }

            stage ('Build') {
              steps {
                script {
                  img = buildDockerImage(image, arch, tag)
                }
              }
            }

            stage ('Push') {
              when { branch 'master' }
              steps {
                pushDockerImage(img, arch, tag)
              }
            }
          }
        }

        stage ('docker-arm64') {
          agent {
            label 'docker-qemu'
          }

          environment {
            arch = 'arm64v8'
            tag = 'latest'
            img = null
          }

          stages {
            stage ('Current Node') {
              steps {
                getNodeHostname()
              }
            }

            stage ('Build') {
              steps {
                script {
                  img = buildDockerImage(image, arch, tag)
                }
              }
            }

            stage ('Push') {
              when { branch 'master' }              
              steps {
                pushDockerImage(img, arch, tag)
              }
            }
          }
        }

        stage ('docker-arm32') {
          agent {
            label 'docker-qemu'
          }

          environment {
            arch = 'arm32v7'
            tag = 'latest'
            img = null
          }

          stages {
            stage ('Current Node') {
              steps {
                getNodeHostname()
              }
            }

            stage ('Build') {
              steps {
                script {
                  img = buildDockerImage(image, arch, tag)
                }
              }
            }

            stage ('Push') {
              when { branch 'master' }              
              steps {
                pushDockerImage(img, arch, tag)
              }
            }
          }
        }
      }
    }

    stage('Update manifest (Only Dockerhub)') {
      agent {
        label 'docker-qemu'
      }
      when { branch 'master' }

      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', 'bobthabuilda') {
            getNodeHostname()  
            sh 'docker manifest create majorcadevs/icecast:latest majorcadevs/icecast:amd64-latest majorcadevs/icecast:arm32v7-latest majorcadevs/icecast:arm64v8-latest'
            sh 'docker manifest push -p majorcadevs/icecast:latest'
          }        
        }
      }
    }

  stage ('Get Git Tag') {
    agent { label 'majorcadevs' }
    when { branch 'master' }
    steps {
      getGitTag()
    }
  }

  stage('Upload Release to Github') {
      agent { label 'majorcadevs' }
      when {
        branch 'master'
        expression {
          GIT_TAG != null && GIT_TAG != ''
        }
      }

      steps {
        uploadArtifacts()
      }
    }
  }    
    
  post {
    success {
      cleanWs()
      telegramSend 'icecast has been built successfully. ', chatId
    }

    failure {
      cleanWs()
      telegramSend 'icecast could not have been built.\n\nSee [build log](' + env.BUILD_URL + ')... ', chatId
    }
  }
}