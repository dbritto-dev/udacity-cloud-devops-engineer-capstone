install-docker-compose:
	wget -O /bin/docker-compose https://github.com/docker/compose/releases/download/1.25.5/docker-compose-Linux-x86_64
	chmod +x /bin/docker-compose

install-hadolint:
	wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.17.5/hadolint-Linux-x86_64
	chmod +x /bin/hadolint

install-kubectl:
	wget -O /bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
	chmod +x /bin/kubectl

install-minikube:
	wget -O /bin/minikube https://github.com/kubernetes/minikube/releases/download/v1.9.2/minikube-linux-amd64
	chmod +x /bin/minikube

test:
	python3 -m coverage run -m pytest -vv ./code/**/*.py
	python3 -m coverage report ./code/**/*.py

test-artifacts:
	python3 -m coverage run -m pytest --junitxml=junit.xml
	python3 -m coverage xml -m

performance-test:
	python3 -m locust -f ./code/tests/performance.py --no-web --print-stats --only-summary -c 100 -r 1 -t 1m

lint:
	docker-compose -f ./etc/docker/docker-compose.yml config
	hadolint ./etc/docker/**/Dockerfile
	python3 -m pylint --disable=R,C,W1202 ./code/**/**.py

run:
	python3 ./code/run.py

run-ci:
	docker rm $(docker ps -aq) -f > /dev/null 2>&1
	docker build -f ./etc/docker/ci/Dockerfile -t app ./etc/docker/ci
	docker run -d --mount "type=bind,source=$(pwd)/code,target=/app" -p 8081:8080 app
