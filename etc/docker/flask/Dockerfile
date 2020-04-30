FROM python:3.7.7-alpine AS builder

WORKDIR /app

COPY . requirements.txt /app/

RUN apk add python3-dev gcc libc-dev &&\
    pip3 install -r requirements.txt




FROM builder

CMD ["python3", "-m", "uswgi", "/opt/capstone.io/etc/uwsgi/uwsgi.ini"]
