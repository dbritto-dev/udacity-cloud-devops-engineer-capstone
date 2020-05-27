FROM python:3.7.7-alpine AS builder-ci
WORKDIR /app
COPY ./code/requirements-ci.txt /app/requirements-ci.txt
RUN ls -la && pwd && pip install -r /app/requirements-ci.txt
# RUN pip install --user -r ./requirements-ci.txt

FROM builder-ci
WORKDIR /app
COPY ./code /app/
CMD python run.py
