@Library(['ist-switch-jenkins-pipeline-library@stable-1', 'common-lib@2-stable']) _

pipeline {
    agent any

    environment {
        PARAM_FILE = 'params.yaml'
        RELEASE_INFO_FILE = 'release-info.yaml'
        NODE_NAME = 'IST_GUI'
        DEFAULT_BUILD_COMPONENT = 'guiscan'
        CODESCAN_BUILD_COMPONENT = 'gui'
    }

    stages {
        stage('Setup') {
            steps {
                script {
                    // Get the branch name
                    def branchName = env.GIT_BRANCH ?: sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
                    echo "Branch name: ${branchName}"
                    
                    // Determine the build component based on the branch name
                    def buildComponent = branchName.endsWith('Codescan') ? CODESCAN_BUILD_COMPONENT : DEFAULT_BUILD_COMPONENT
                    echo "Build component: ${buildComponent}"
                    
                    // Call the PipelineRouter with the appropriate parameters
                    PipelineRouter(
                        buildParamsYAML: PARAM_FILE,
                        buildcomponent: buildComponent,
                        node: NODE_NAME,
                        releaseInfoYAML: RELEASE_INFO_FILE
                    )
                }
            }
        }
    }
}
