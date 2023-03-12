ARG tag=2.387.1-lts-jdk11

# Build base image for Docker
FROM jenkins/jenkins:${tag} AS base
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

# Install PHP 8.1 and dependencies
FROM base
USER root
RUN apt-get install ca-certificates apt-transport-https software-properties-common gnupg2
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
RUN curl -fsSL  https://packages.sury.org/php/apt.gpg| sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg
RUN apt update
RUN apt install php8.1
RUN apt install php8.1-{bcmath,fpm,xml,mysql,zip,intl,ldap,gd,cli,bz2,curl,mbstring,pgsql,opcache,soap,cgi}

# Install Jenkins plugins and configurations
FROM base
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false \ 
    -Dorg.apache.commons.jelly.tags.fmt.timeZone=Asia/Kolkata
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jenkins.yaml
ENV PLUGINS_FILE /usr/share/jenkins/ref/plugins.txt

COPY config/plugins.txt ${PLUGINS_FILE}
COPY config/casc.yaml ${CASC_JENKINS_CONFIG}
RUN jenkins-plugin-cli -f ${PLUGINS_FILE}

USER jenkins
