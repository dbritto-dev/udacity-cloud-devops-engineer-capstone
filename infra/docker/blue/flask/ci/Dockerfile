FROM python:3.7.7-alpine AS builder-ci
WORKDIR /app
COPY ./code/requirements-ci.txt /app/
RUN pip install --user -r requirements-ci.txt

FROM builder
WORKDIR /app
COPY ./code /app/
CMD python run.py
