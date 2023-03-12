ARG tag=2.387.1-lts-jdk11

# Build base image for Docker
FROM jenkins/jenkins:${tag}
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

# Install Jenkins plugins and configurations
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false \ 
    -Dorg.apache.commons.jelly.tags.fmt.timeZone=Asia/Kolkata
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jenkins.yaml
ENV PLUGINS_FILE /usr/share/jenkins/ref/plugins.txt

COPY config/plugins.txt ${PLUGINS_FILE}
COPY config/casc.yaml ${CASC_JENKINS_CONFIG}
USER jenkins
RUN jenkins-plugin-cli -f ${PLUGINS_FILE}
