FROM python:3.7.7-alpine

WORKDIR /app

COPY /opt/capstone.io/code /app/

RUN make install

CMD ["make", "run"]
