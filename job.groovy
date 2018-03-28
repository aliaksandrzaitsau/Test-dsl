def git = "aliaksandrzaitsau/Test-dsl"
def repo = "azaitsau"

def gitURL = "https://github.com/aliaksandrzaitsau/Test-dsl.git"
def command = "git ls-remote -h $gitURL"

def proc = command.execute()
proc.waitFor()

if ( proc.exitValue() != 0 ) {
    println "Error, ${proc.err.text}"
    System.exit(-1)
}

def branches = proc.in.text.readLines().collect {
    it.replaceAll(/[a-z0-9]*\trefs\/heads\//, '')
}

job("MNTLAB-azaitsau-main-build-job") {
    parameters {
	choiceParam('BRANCH_NAME', ['azaitsau', 'master'], '')
        activeChoiceParam('BUILDS_TRIGGER') {
            choiceType('CHECKBOX')
            groovyScript {
                script('["MNTLAB-azaitsau-child1-build-job", "MNTLAB-azaitsau-child2-build-job", "MNTLAB-azaitsau-child3-build-job", "MNTLAB-azaitsau-child4-build-job"]')
            }
        }
    }
    scm {
        github(git, '$BRANCH_NAME')
    }
    triggers {
        scm('H/1 * * * *')
    }
    steps {
        downstreamParameterized {
            trigger('$BUILDS_TRIGGER') {
                block {
                    buildStepFailure('FAILURE')
                    failure('FAILURE')
                    unstable('UNSTABLE')
                }
               parameters {
                    currentBuild()
		}
	    }
	}	
        shell('chmod +x script.sh && ./script.sh >> output.log && tar -czf ${BRANCH_NAME}_dsl_script.tar.gz output.log')
    }
    publishers { 
	archiveArtifacts('output.log')
    }

}

1.upto(4) {
job("MNTLAB-azaitsau-child${it}-build-job") {
    parameters {
	choiceParam('BRANCH_NAME', branches, '')
    }
    scm {
        github(git, '$BRANCH_NAME')
    }
    steps {
        shell('chmod +x script.sh && ./script.sh >> output.log && tar -czf  child${it}_${BUILD_NUMBER}_dsl_script.tar.gz output.log job.groovy script.sh')
    }
    publishers { 
        archiveArtifacts {
            pattern('output.log')
            pattern('${BRANCH_NAME}_dsl_script.tar.gz')
            onlyIfSuccessful()
   }
  }
 }
}
