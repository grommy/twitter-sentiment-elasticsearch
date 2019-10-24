# start with a base image
FROM ubuntu:14.04.4

MAINTAINER Real Python <info@realpython.com>

RUN apt-get update && apt-get install -y apt-transport-https
RUN echo 'deb http://private-repo-1.hortonworks.com/HDP/ubuntu14/2.x/updates/2.4.2.0 HDP main' >> /etc/apt/sources.list.d/HDP.list
RUN echo 'deb http://private-repo-1.hortonworks.com/HDP-UTILS-1.1.0.20/repos/ubuntu14 HDP-UTILS main'  >> /etc/apt/sources.list.d/HDP.list
RUN echo 'deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/azurecore/ trusty main' >> /etc/apt/sources.list.d/azure-public-trusty.list

# install wget, java, and mini-httpd web server
RUN apt-get install -yq wget
RUN apt-get install -yq default-jre-headless
RUN apt-get install -yq mini-httpd

# install elasticsearch
RUN cd /tmp && \
    wget -nv https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.5.tar.gz && \
    tar zxf elasticsearch-1.3.5.tar.gz && \
    rm -f elasticsearch-1.3.5.tar.gz && \
    mv /tmp/elasticsearch-1.3.5 /elasticsearch

# install kibana
RUN cd /tmp && \
    wget -nv https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz && \
    tar zxf kibana-3.1.2.tar.gz && \
    rm -f kibana-3.1.2.tar.gz && \
    mv /tmp/kibana-3.1.2 /kibana

# start elasticsearch
CMD /elasticsearch/bin/elasticsearch -Des.logger.level=OFF & mini-httpd -d /kibana -h `hostname` -r -D -p 8000

# expose ports
EXPOSE 8000 9200