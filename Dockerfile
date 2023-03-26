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
RUN apt-get update && apt-get install -y docker-ce-cli wget

# Install SonarQube Scanner
WORKDIR /opt/sonarqube
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip
RUN unzip sonar-scanner-cli-4.8.0.2856-linux.zip
RUN rm -rf sonar-scanner-cli-4.8.0.2856-linux.zip
RUN mv sonar-scanner-4.8.0.2856-linux sonar-scanner-cli

# Install Snyk Scanner
RUN curl https://static.snyk.io/cli/latest/snyk-linux -o snyk-linux
RUN chmod +x ./snyk-linux
RUN mv ./snyk-linux /usr/local/bin/

WORKDIR /
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false \ 
    -Dorg.apache.commons.jelly.tags.fmt.timeZone=Asia/Kolkata
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jenkins.yaml
ENV PLUGINS_FILE /usr/share/jenkins/ref/plugins.txt
ENV SONAR_RUNNER_HOME /opt/sonarqube/sonar-scanner-cli

COPY config/plugins.txt ${PLUGINS_FILE}
COPY config/casc.yaml ${CASC_JENKINS_CONFIG}
USER jenkins
RUN jenkins-plugin-cli -f ${PLUGINS_FILE}
