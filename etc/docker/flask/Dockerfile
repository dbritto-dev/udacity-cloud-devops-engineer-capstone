FROM python:3.7.7-alpine

WORKDIR /app

RUN pip3 install -e .

ENTRYPOINT python3

CMD ["uswgi", "uswgi.ini"]
