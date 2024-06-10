
p




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
