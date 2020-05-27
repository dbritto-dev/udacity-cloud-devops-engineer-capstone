FROM python:3.7.7-alpine AS builder
WORKDIR /app
COPY ./code/requirements-dev.txt /app/
RUN pip install --user -r requirements-dev.txt

FROM builder
WORKDIR /app
COPY ./code /app/
CMD python run.py
