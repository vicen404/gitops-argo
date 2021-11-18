FROM registry.access.redhat.com/ubi8/ubi:latest

ENV workdirectory /data
ENV source https://github.com/mailslurper/mailslurper/releases/download/1.14.1/mailslurper-1.14.1-linux.zip

WORKDIR $workdirectory

RUN yum install -y wget && yum install -y unzip
RUN wget -O mail.zip $source && unzip -o mail.zip

ADD config.json .

EXPOSE 8080
EXPOSE 8085
EXPOSE 2500
