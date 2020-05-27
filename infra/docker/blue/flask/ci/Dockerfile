FROM python:3.7.7-alpine AS builder
RUN apk update && apk add gcc build-base libffi-dev python3-dev
WORKDIR /app
COPY ./code/requirements.txt ./code/requirements-ci.txt /app/
RUN pip install --user -r requirements-ci.txt

FROM builder
WORKDIR /app
COPY ./code /app/
CMD python run.py
