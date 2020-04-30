FROM python:3.7.7-alpine AS builder

WORKDIR /app

COPY . requirements.txt /app/

RUN pip3 install -r requerirements.txt




FROM builder

CMD ["python3", "-m", "uswgi", "/opt/capstone.io/code/uswgi.ini"]
