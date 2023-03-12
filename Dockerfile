ARG tag=2.387.1-lts-jdk11

# Build base image for Docker
FROM jenkins/jenkins:${tag}
USER root
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false \ 
    -Dorg.apache.commons.jelly.tags.fmt.timeZone=Asia/Kolkata
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jenkins.yaml
ENV PLUGINS_FILE /usr/share/jenkins/ref/plugins.txt

COPY config/plugins.txt ${PLUGINS_FILE}
COPY config/casc.yaml ${CASC_JENKINS_CONFIG}
USER jenkins
RUN jenkins-plugin-cli -f ${PLUGINS_FILE}
