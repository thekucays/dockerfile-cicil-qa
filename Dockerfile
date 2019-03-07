# if you messed up something (like i did many times)
# and want to delete the container along with the docker image, but getting permission denied
# do this first
# stop container by issuing: docker container stop <container-id>
# check status: sudo aa-status
# shutdown and prevent restart: sudo systemctl disable apparmor.service --now
# unload appamor: sudo service apparmor teardown
# delete your container, and then your image
# your welcome!

#FROM python:2.7.16-slim
FROM ubuntu:16.04

# place where the jenkins.war is placed on the container
WORKDIR /app
COPY . /app

# expose port for outside world
EXPOSE 8081

# environment variable
ENV NAME World

# install java 8 (added script to accept the agreements automatically)
# https://newfivefour.com/docker-java8-auto-install.html
#RUN apt-get update
#RUN apt-get -y install software-properties-common
#RUN add-apt-repository -y ppa:webupd8team/java
#RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
#RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
#RUN apt-get update
#RUN apt-get -y install oracle-java8-installer --allow-unauthenticated

# another way
# https://stackoverflow.com/questions/49914574/install-jdk-8-update-172-in-dockerfile-with-ubuntu-image
RUN apt-get update
RUN apt-get -y install software-properties-common
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer --allow-unauthenticated

# install python (run this if the base is ubuntu)
# https://askubuntu.com/questions/101591/how-do-i-install-the-latest-python-2-7-x-or-3-x-on-ubuntu
RUN apt-get -y install build-essential checkinstall
RUN apt-get -y install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
RUN wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz
RUN tar -xvf Python-2.7.15.tgz

# docker best practice: change working dir instead of calling "cd"
WORKDIR /app/Python-2.7.15
#RUN cd Python-2.7.15

RUN ./configure
RUN make
RUN checkinstall

# install python-pip separately after installing python (still don't know why)
RUN apt-get -y install python-pip

# try install robotframework
RUN pip install robotframework

# verify python and java version
# go back to /app since the file exists there
WORKDIR /app
CMD ["python", "printversion.py"]
