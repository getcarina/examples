FROM python:3.4

ENV PYTHONUNBUFFERED 1

ADD . /src

WORKDIR /src

RUN pip install -r requirements.txt

EXPOSE 5000

CMD python app.py
