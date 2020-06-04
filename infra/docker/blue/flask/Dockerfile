FROM python:3.7.7-alpine AS builder
WORKDIR /app
COPY ./code/requirements.txt /app/
RUN pip install --no-binary :all: -r requirements.txt

FROM builder
WORKDIR /app
COPY ./code /app/
CMD [ "python", "run.py" ]
