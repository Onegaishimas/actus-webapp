# Start with a base image (using Alpine Linux)
FROM alpine:3.14

# Set environment variables for locale
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Install necessary packages
RUN apk add --no-cache \
    openjdk11 \
    curl \
    tar \
    wget \
    unzip \
    nodejs \
    npm \
    mongodb

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk \
    PATH=$PATH:/usr/lib/jvm/java-11-openjdk/bin

# Install Maven
ARG MAVEN_VERSION=3.8.4
ARG USER_HOME_DIRECTORY=/root
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME=/usr/share/maven
ENV MAVEN_CONFIG=/root/.m2

# Install Gradle
ARG GRADLE_VERSION=7.2
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions
RUN wget ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip -O gradle.zip \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv gradle-${GRADLE_VERSION} /opt/gradle \
    && ln -s /opt/gradle/bin/gradle /usr/bin/gradle

ENV GRADLE_HOME=/opt/gradle
ENV PATH=$PATH:/opt/gradle/bin

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Build steps (adjust as needed for your project)
RUN mvn clean package
RUN gradle build
RUN npm install

# Expose port
EXPOSE 8083

# Create volume for MongoDB data
VOLUME ["/data/db"]

# Set the entrypoint
CMD ["./gradlew", "bootRun"]