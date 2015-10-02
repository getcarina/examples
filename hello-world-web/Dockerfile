FROM ubuntu:14.04

ADD ./web /opt/web/

RUN apt-get update
RUN apt-get install -y -q python-all python-pip
RUN pip install -qr /opt/web/requirements.txt

EXPOSE 5000

WORKDIR /opt/web
CMD ["python", "web.py"]
