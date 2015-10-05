FROM python:3

ADD ./web /opt/web/

RUN pip install -qr /opt/web/requirements.txt

EXPOSE 5000

WORKDIR /opt/web
CMD ["python", "web.py"]
