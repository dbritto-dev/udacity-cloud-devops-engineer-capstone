FROM python:3.7.7-alpine AS builder

WORKDIR /app

COPY . requirements.txt /app/

RUN pip install -r requirements.txt




FROM builder

ENTRYPOINT [ "python" ]

CMD [ "run.py" ]
