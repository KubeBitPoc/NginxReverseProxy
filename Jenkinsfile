#!/usr/bin/groovy

podTemplate(label: 'Jenkins', containers: [
   containerTemplate(name: 'jnlp', image: 'lachlanevenson/jnlp-slave:3.10-1-alpine', args: '${computer.jnlpmac} ${computer.name}', workingDir: '/home/jenkins', resourceRequestCpu: '200m', resourceLimitCpu: '300m', resourceRequestMemory: '256Mi', resourceLimitMemory: '512Mi'),
    containerTemplate(name: 'docker', image: 'docker:1.12.0', command: 'cat', ttyEnabled: true),    
	containerTemplate(name: 'kubectl', image: 'pahud/eks-kubectl-docker', command: 'cat', ttyEnabled: true),
	containerTemplate(name: 'helm', image: 'lachlanevenson/k8s-helm:v2.8.2', command: 'cat', ttyEnabled: true)
],volumes:[
	hostPathVolume(mountPath: '/home/gradle/.gradle', hostPath: '/tmp/jenkins/.gradle'),
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),  
]) {
  node('Jenkins') {
   
    checkout scm
  

    //pull the code at this location to build and deploy
    

    stage('Create Docker images') {
      container('docker') {
       
        withCredentials([[$class: 'UsernamePasswordMultiBinding',
          credentialsId: 'dockercredentials',
          usernameVariable: 'DOCKER_HUB_USER',
          passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
          sh """
            echo "Attempting docker login using ${DOCKER_HUB_USER}"
            docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}
            echo "We are currently in directory $pwd"
	    docker build -t anilbb/webapp-proxy:latest .
            docker push anilbb/webapp-proxy:latest
            """
        }
      }
    }
    stage('Run kubectl') {
      container('kubectl') {
        
        try {
            sh "kubectl delete deployment frontend-deployment"
	} catch(error) {}
        
        
        sh "kubectl create -f frontend-deployment.yaml"
        
        try {
            sh "kubectl delete service frontend-service"
        } catch(error) {}
        
        sh "kubectl create -f frontend-service.yaml"
      }
    }
  
  }
}
