FROM python:3.7.7-alpine AS builder
WORKDIR /app
COPY ./code/requirements.txt /app/
RUN pip install --user --no-binary -r requirements.txt

FROM builder
WORKDIR /app
COPY ./code /app/
CMD [ "python", "run.py" ]
