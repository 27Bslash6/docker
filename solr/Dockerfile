FROM funkygibbon/openjdk

MAINTAINER Ray Walker <hello@raywalker.it>

RUN apt-get -y install wget curl && \
	apt-get clean

ENV SOLR_VERSION 4.10.4
ENV SOLR solr-$SOLR_VERSION

RUN mkdir -p /opt && \
    curl -SL http://mirror.easyname.ch/apache/lucene/solr/$SOLR_VERSION/$SOLR.tgz \
    | tar -xvzC /opt && \
    ln -s /opt/$SOLR /opt/solr

# RUN wget -q https://raw.githubusercontent.com/jeroenvermeulen/magento-solarium/master/app/code/community/JeroenVermeulen/Solarium/docs/schema.xml -O /opt/solr/example/solr/collection1/conf/schema.xml && \
#     wget -q https://raw.githubusercontent.com/jeroenvermeulen/magento-solarium/master/app/code/community/JeroenVermeulen/Solarium/docs/solrconfig.xml -O /opt/solr/example/solr/collection1/conf/solrconfig.xml && \
#     sed -i -r "s#<dataDir>.+</dataDir>#<dataDir>/opt/solr_data</dataDir>#" /opt/solr/example/solr/collection1/conf/solrconfig.xml

COPY schema.xml /opt/solr/example/solr/collection1/conf/schema.xml
COPY solrconfig.xml /opt/solr/example/solr/collection1/conf/solrconfig.xml

RUN mkdir -p /etc/service/solr

COPY run.sh /etc/service/solr/run

RUN chmod +x /etc/service/solr/run

VOLUME /opt/solr/example/solr/collection1/data

EXPOSE 8983

CMD ["/sbin/my_init"]