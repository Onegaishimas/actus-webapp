# Start with a base image (assuming Alpine Linux based on the apk command)
FROM alpine:latest

# Set environment variables for locale
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Install necessary packages
RUN apk add --no-cache

# Set Java version
ENV JAVA_VERSION=jdk-11.0.11+9

# Copy necessary files
COPY multi:da97b7f42d52b404e495fa140e92a22c92d31d4502eef244047de8e9f26d61c1 /usr/local/bin/

# Install Java
RUN set -eux;

# Set Java environment variables
ENV JAVA_HOME=/opt/java/openjdk \
    PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Set default command
CMD ["jshell"]

# Add label
LABEL Francis=Parr <fnparr@gmail.com>

# Add Alpine package repository
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/main' >> /etc/apk/repositories

# Set Maven arguments and install Maven
ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIRECTORY=/root
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/3.6.3/binaries
RUN apk add --no-cache curl tar \
    && mkdir -p /usr/share/maven /usr/share/maven/ref \
    && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME=/usr/share/maven
ENV MAVEN_CONFIG=/.m2

# Set Gradle arguments and install Gradle
ARG GRADLE_VERSION=4.8.1
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions
RUN apk add --no-cache wget unzip \
    && wget ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip -O gradle.zip \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv gradle-${GRADLE_VERSION} /usr/bin/gradle \
    && ln -s /usr/bin/gradle/bin/gradle /usr/bin/gradle

ENV GRADLE_VERSION=4.8.1
ENV GRADLE_HOME=/usr/bin/gradle
ENV GRADLE_USER_HOME=/cache
ENV PATH=${PATH}:/usr/bin/gradle/bin

# Create volume for Gradle cache
VOLUME ["/cache"]

# Set working directory
WORKDIR /home/app

# Copy application files
COPY app .

# Build steps (placeholders, adjust as needed)
RUN mvn clean package
RUN gradle build
RUN npm install

# Expose port
EXPOSE 8083

# Create volume for MongoDB data
VOLUME ["/data/db"]

# Install MongoDB (placeholder, adjust as needed)
RUN apk add --no-cache mongodb

# Final setup steps (placeholders, adjust as needed)
RUN chmod +x run.sh

# Set the entrypoint
CMD ["./run.sh"]