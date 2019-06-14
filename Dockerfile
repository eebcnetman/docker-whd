FROM centos:latest
ENV CONSOLETYPE=serial \
        VERSION=12.6.0 \
        PRODUCT_NAME=webhelpdesk-12.6.0.738-1.x86_64.rpm.gz \
        GZIP_FILE=webhelpdesk.rpm.gz \
        RPM_FILE=webhelpdesk.rpm \
        WHD_HOME=/usr/local/webhelpdesk
ADD functions /etc/rc.d/init.d/functions 
ADD http://downloads.solarwinds.com/solarwinds/Release/WebHelpDesk/$VERSION/Linux/$PRODUCT_NAME /tmp/$GZIP_FILE
RUN mkdir -p /usr/local/webhelpdesk && \
    gunzip /tmp/$GZIP_FILE && \
    yum clean all && \
    yum update -y && \
    yum install -y iproute python-setuptools unzip && \
    easy_install supervisor && \
    rpm -ivh /tmp/$RPM_FILE  && \
    rm /tmp/$RPM_FILE && \
    yum clean all && \
    cp $WHD_HOME/conf/whd.conf.orig $WHD_HOME/conf/whd.conf && \
    sed -i 's/^PRIVILEGED_NETWORKS=[[:space:]]*$/PRIVILEGED_NETWORKS=0.0.0.0\/0/g' $WHD_HOME/conf/whd.conf && \
    sed -i 's/^DEFAULT_PORT=8081*$/DEFAULT_PORT=80/g' $WHD_HOME/conf/whd.conf && \
    sed -i 's/^HTTPS_PORT=8443*$/#HTTPS_PORT=8443/g' $WHD_HOME/conf/whd.conf
ADD supervisord.conf /opt/supervisord.conf
ADD mysql-connector-java-8.0.13.jar /usr/local/webhelpdesk/bin/jre/lib/ext/mysql-connector-java-8.0.13.jar
ADD start.sh ${WHD_HOME}/start.sh
ADD run.sh ${WHD_HOME}/run.sh
RUN chmod +x ${WHD_HOME}/start.sh &&\
    chmod +x ${WHD_HOME}/run.sh
VOLUME [ "/usr/local/webhelpdesk" ]
EXPOSE 80

ENTRYPOINT ["/usr/local/webhelpdesk/run.sh"]