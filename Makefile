install-docker-compose:
	wget -O /usr/bin/docker-compose https://github.com/docker/compose/releases/download/1.25.5/docker-compose-Linux-x86_64
	chmod +x /usr/bin/docker-compose

install-hadolint:
	wget -O /usr/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.17.5/hadolint-Linux-x86_64
	chmod +x /usr/bin/hadolint

install-kubectl:
	wget -O /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
	chmod +x /usr/bin/kubectl

install-minikube:
	wget -O /usr/bin/minikube https://github.com/kubernetes/minikube/releases/download/v1.9.2/minikube-linux-amd64
	chmod +x /usr/bin/minikube

test:
	python3 -m coverage run -m pytest -vv ./code/**/*.py
	python3 -m coverage report ./code/**/*.py

test-artifacts:
	python3 -m coverage run -m pytest --junitxml=reports/junit/junit.xml
	python3 -m coverage xml -o reports/junit/coverage.xml
	python3 -m coverage html -d reports/web

performance-test:
	python3 -m locust -f ./code/tests/performance.py --no-web --print-stats --only-summary -c 100 -r 1 -t 1m

lint:
	docker-compose -f ./etc/docker/docker-compose.yml config
	hadolint ./etc/docker/**/Dockerfile
	python3 -m pylint --disable=R,C,W1202 ./code/**/**.py

build:
	docker-compose -f ./etc/docker/docker-compose.yml build

publish:
	docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}
	docker-compose -f ./etc/docker/docker-compose.yml push

run:
	python3 ./code/run.py
