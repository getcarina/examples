FROM python:3

ADD ./app /opt/app/

RUN pip install -qr /opt/app/requirements.txt

EXPOSE 5000

WORKDIR /opt/app
CMD ["python", "app.py"]
