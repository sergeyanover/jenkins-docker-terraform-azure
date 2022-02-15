FROM jenkins/jenkins:lts-alpine

USER root

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
 
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY jenkins-user /run/secrets/jenkins-user
COPY jenkins-pass /run/secrets/jenkins-pass

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /bin/jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt




