FROM ubuntu:16.04
ENV DEBIAN_FRONTEND=noninteractive

## install apps
RUN \
  apt-get update && \
  apt-get install -y vim iputils-ping wget apt-transport-https software-properties-common python-software-properties git

## install java 8
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
RUN java -version

## install maven 3
RUN \
  cd /opt/ && \
  wget http://www-eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
  tar -xvzf apache-maven-3.3.9-bin.tar.gz && \
  mv apache-maven-3.3.9 maven && \
  rm -rf /opt/apache-maven-3.3.9-bin.tar.gz
ENV M2_HOME /opt/maven 
ENV PATH ${M2_HOME}/bin:${PATH}
RUN mvn -v

## install jenkins 2
RUN \
  wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add - && \
  sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && \
  apt-get update && \
  apt-get install -y jenkins
ENV JENKINS_HOME /devtools/jenkins_home
RUN ls -al /usr/share/jenkins
#RUN cat /devtools/jenkins_home/secrets/initialAdminPassword

RUN apt-get clean

CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]

