FROM tomcat:8
MAINTAINER zack

ADD target/cse.war /usr/local/tomcat/webapps/
ADD access/docker.ps1 /usr/local/access/
ADD access/cert.pem /usr/local/access/
ADD access/key.pem /usr/local/access/

CMD ["catalina.sh", "run"]
