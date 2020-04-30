FROM python:3.7.7-alpine

WORKDIR /app

COPY /opt/capstone.io/code/requirements*.txt /app/

ENTRYPOINT python3

CMD ["uswgi", "uswgi.ini"]
