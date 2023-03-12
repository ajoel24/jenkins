## Local Jenkins Server

Quickly setup a Jenkins server, powered by Docker.

### Installation

#### Option 1: Using Docker Compose

Clone the repository and run the docker-compose.yml file

```sh
docker-compose up -d
```

### Features

- Skip the initial setup by installing plugins during image build.
- Use configuration-as-code plugin to configure the Jenkins automatically.
- Create admin user on the fly using environment variables.

### References

1. [DigitalOcean blog post](https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-setup-with-docker-and-jenkins-configuration-as-code)
2. [Setup Jenkins using Docker](https://www.jenkins.io/doc/book/installing/docker/)
