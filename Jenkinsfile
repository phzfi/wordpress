def CHANGELOG
def PROJECT_NAME = "debian-nginx"
def SLACK_CHANNEL = "#marketing"
pipeline {
  agent {
    label 'docker && slave'
  }

  environment {
    BRANCH_NAME = "${GIT_BRANCH}"

    //Multibranch pipeline
    BUILD_ENV = [master: 'prod', develop: 'stg'].get(env.BRANCH_NAME, 'dev')
    VERSION = "${currentBuild.id}"

    SERVICE_NAME = "${PROJECT_NAME}-${BUILD_ENV}"
  }

  options {
    ansiColor('xterm')
    //set default pipeline timeout to 3hours if there is a jam, it will abort automatically
    timeout(time: 180, unit: 'MINUTES')
  }

  triggers {
    gitlab(triggerOnPush: true, triggerOnMergeRequest: true, branchFilterType: 'All')
    pollSCM('H/5 8-20 1-6 * *')
  }

  stages {
    stage("Prepare") {
      steps {
        checkout scm

        //If building custom branch, the BUILD_ENV setting above returns null, revert to dev
        script {
          if (BUILD_ENV == null) {
            BUILD_ENV = 'dev'
          }
        }

        script {
          echo "Parse changelog"
          def changeLogSets = currentBuild.rawBuild.changeSets
          CHANGELOG = ""
          for (int i = 0; i < changeLogSets.size(); i++) {
            def entries = changeLogSets[i].items
            for (int j = 0; j < entries.length; j++) {
              def entry = entries[j]
              CHANGELOG = CHANGELOG + "${entry.author}: ${entry.msg}\n"
            }
          }

          //prevent Jenkins double builds, check if changelog is empty, skip
          if (CHANGELOG && CHANGELOG.trim().length() == 0) {
            currentBuild.result = 'SUCCESS'
            return
          }
        }
        echo "Changelog:\n${CHANGELOG}"
      }
    }

    stage("Clean") {
      steps {
        script {
          sh "./down.sh > /dev/null 2>&1 || true"
          sh "./clean.sh > /dev/null 2>&1 || true"
        }
      }
    }

    stage("Provision") {
      steps {
        echo "Provision Branch ${BRANCH_NAME} with Env ${BUILD_ENV}"
        timeout(30) {
          echo "Start provisioning"
        }
      }
    }

    stage("Build") {
      when {
        expression {[master: true, develop: true].get(BRANCH_NAME, false)}
      }
      steps {
        withCredentials([
          [$class: 'UsernamePasswordMultiBinding', credentialsId: 'DOCKER_HUB', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD']
        ]) {
          timeout(400) {
            sh script:"./docker/build.sh prod ${VERSION} ${DOCKER_HUB_USERNAME} ${DOCKER_HUB_PASSWORD}", returnStatus:true
          }
        }
      }
    }

    stage("Quality") {
      steps {
        echo "Running Code Quality checks"
//        timeout(15) {
//          sh script:"docker-compose -f docker-compose.prod.yml up -d", returnStatus:true
          //sh script:"./up.sh", returnStatus:true
          //sh script:"docker-compose run web syntax-check.sh", returnStatus:true
//        }
      }
    }

    stage("Test") {
      steps {
        echo "Running unit tests"       
//        timeout(15) {
//          sh script:"docker-compose -f docker-compose.prod.yml run test", returnStatus:true
//          junit 'reports/TEST-default.xml'
//        }
      }
    }

    stage("Tag") {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'git-ssh-ci', keyFileVariable: 'SSH_KEY')]) {
          script {
            if (env.BUILD_ENV != 'dev') {
              sshagent(credentials: ['git-ssh-ci']) {
                sh('set +x && '
                + 'TAG_NAME="' + env.BUILD_ENV + '-' + env.VERSION + '" && '
                + 'git tag -d $TAG_NAME || true && ' // delete 'exists' tag from local git repository. (if previous push failed)
                + 'git tag -a $TAG_NAME -m Jenkins && '   // create new tag.
                + 'git push origin $TAG_NAME --no-verify' // push the new tag.
                )
              }
            } else {
              echo "Skipping Git Tag for git development branches..."
            }
          }
        }
      }
    }

  }

  post {
    always {
      script {
      script {
        //See https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/troubleshooting-guides/how-to-troubleshoot-hudson-filepath-is-missing-i>
        if (getContext(hudson.FilePath)) {
          sh "./clean.sh > /dev/null 2>&1 || true"
        }
      }
      script {
        sh "./down.sh > /dev/null 2>&1 || true"
      }
      // Workaround to the clean issue, can't delete folder as folder is owned by docker user 'root'.
      sh "sudo chown -R jenkins:jenkins ${workspace}"
      }
    }

    success {
      slackSend channel: "${env.SLACK_CHANNEL}", color: "good", message: "Deployed ${env.JOB_NAME}#${env.BUILD_NUMBER} successfully to ${env.BUILD_ENV}.\nPlease Smoke Tests (see README.md #4.1). Add Reaction thumbsup or thumbsdown to indicate Smoke Test cases pass or not.\n${CHANGELOG}"

      emailext (
        subject: "Deployed ${env.JOB_NAME} to ${env.BUILD_ENV} [${env.BUILD_NUMBER}]",
        body: """<p>New build completed and deployed successfully: '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
          <p>Please Smoke Tests (see README.md #4.1). Add Reaction thumbsup or thumbsdown on Slack to indicate Smoke Test cases pass or not.</p>
          <p>${CHANGELOG}""",
        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
      )
    }

    unstable {
      slackSend channel: "${env.SLACK_CHANNEL}", color: "warning", message: "Unstable build ${env.JOB_NAME}#${env.BUILD_NUMBER} to ${env.BUILD_ENV}.\nPlease fix: ${env.BUILD_URL}console#footer\n${CHANGELOG}"

      emailext (
        subject: "Unstable build ${env.JOB_NAME} to ${env.BUILD_ENV} [${env.BUILD_NUMBER}]",
        body: """<p>Unstable build: '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
          <p>Check console output at &QUOT;<a href='${env.BUILD_URL}console#footer'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>
          <p>${CHANGELOG}""",
        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
      )
    }

    failure {
      slackSend channel: "${env.SLACK_CHANNEL}", color: "danger", message: "FAIL ${env.JOB_NAME}#${env.BUILD_NUMBER} to ${env.BUILD_ENV}.\nPlease fix: ${env.BUILD_URL}console#footer\n${CHANGELOG}"

      emailext (
        subject: "Failed to build ${env.JOB_NAME} to ${env.BUILD_ENV} [${env.BUILD_NUMBER}]",
        body: """<p>Build failed: '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
          <p>Check console output at &QUOT;<a href='${env.BUILD_URL}console#footer'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>
          <p>${CHANGELOG}""",
        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
      )
    }
  }
}

