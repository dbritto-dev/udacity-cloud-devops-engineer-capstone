FROM python:3.7.7

WORKDIR /app

COPY . src/ /app/

RUN make install

CMD ["make", "run"]
