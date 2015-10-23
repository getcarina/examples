FROM python:3.4.3

COPY whwatch.py /usr/local/src/whwatch.py

RUN pip install flask simplejson docker-py

EXPOSE 5000

ENTRYPOINT python /usr/local/src/whwatch.py
