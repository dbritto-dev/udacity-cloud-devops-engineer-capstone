FROM python:3.7.7-alpine

WORKDIR /app

RUN pip3 install -r requirements-dev.txt

ENTRYPOINT python3

CMD ["uswgi", "uswgi.ini"]
