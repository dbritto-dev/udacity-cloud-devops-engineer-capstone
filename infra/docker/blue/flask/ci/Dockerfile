FROM python:3.7.7-alpine AS builder
RUN apk --no-cache add build-base=0.5-r1
WORKDIR /app
COPY ./code/requirements.txt ./code/requirements-ci.txt /app/
RUN pip install --user -r requirements-ci.txt

FROM builder
WORKDIR /app
COPY ./code /app/
EXPOSE 8080
CMD [ "python", "run.py" ]
