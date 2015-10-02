FROM ubuntu:14.04

ADD ./app /opt/app/

RUN apt-get update
RUN apt-get install -y -q python-all python-pip
RUN pip install -qr /opt/app/requirements.txt

EXPOSE 5000

WORKDIR /opt/app
CMD ["python", "app.py"]
