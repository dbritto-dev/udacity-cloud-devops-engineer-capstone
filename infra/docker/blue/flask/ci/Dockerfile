FROM python:3.7.7-alpine AS builder
RUN apk --no-cache add build-base=0.5-r1 libffi-dev=3.2.1-r6
WORKDIR /app
RUN pwd
RUN ls -la
COPY code/requirements.txt code/requirements-ci.txt .
RUN pip install --user -r requirements-ci.txt

FROM builder
WORKDIR /app
COPY code /app/
EXPOSE 8080
CMD [ "python", "run.py" ]
