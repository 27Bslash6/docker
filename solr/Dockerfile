FROM funkygibbon/openjdk

MAINTAINER Ray Walker <hello@raywalker.it>

RUN apt-get -y install wget curl unzip && \
	apt-get clean

ENV SOLR_VERSION 4.10.4
ENV SOLR solr-$SOLR_VERSION

RUN mkdir -p /opt && \
    curl -SL http://mirror.easyname.ch/apache/lucene/solr/$SOLR_VERSION/$SOLR.tgz \
    | tar -xvzC /opt && \
    ln -s /opt/$SOLR /opt/solr

COPY schema.xml /opt/solr/example/solr/collection1/conf/schema.xml
COPY solrconfig.xml /opt/solr/example/solr/collection1/conf/solrconfig.xml

RUN mkdir -p /etc/service/solr

COPY run.sh /etc/service/solr/run

RUN chmod +x /etc/service/solr/run

VOLUME /opt/solr/example/solr/collection1/data

EXPOSE 8983

CMD ["/sbin/my_init"]