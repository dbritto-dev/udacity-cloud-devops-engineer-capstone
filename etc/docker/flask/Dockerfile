FROM python:3.7.7-alpine

WORKDIR /app

COPY /opt/capstone.io/Makefile /app/

RUN make install

CMD ["python3", "-m", "uswgi", "uswgi.ini"]
