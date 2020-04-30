FROM python:3.7.7-alpine AS builder

WORKDIR /app

COPY . requirements.txt /app/

RUN pip3 install -r requirements.txt




FROM builder

RUN ls -la /app

CMD ["python3", "run.py"]
