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
	docker run --rm -i capstone-flask:ci python -m coverage run -m pytest -vv

test-artifacts:
	docker run --rm -i capstone-flask:ci python -m coverage run -m pytest --junitxml=reports/junit/junit.xml
	docker run --rm -i capstone-flask:ci python -m coverage xml -o reports/junit/coverage.xml
	docker run --rm -i capstone-flask:ci python -m coverage html -d reports/web

performance-test:
	$(eval CID=$(shell docker run --rm -d capstone-flask:ci))
	docker exec -it ${CID} python -m locust -f ./tests/performance.py --headless --print-stats --only-summary -u 100 -r 1 -t 1m
	docker stop ${CID}

lint:
	hadolint ./infra/docker/**/Dockerfile

build:
	docker build -t capstone-nginx:blue -f ./infra/docker/blue/nginx/Dockerfile .
	docker build -t capstone-flask:blue -f ./infra/docker/blue/flask/Dockerfile .

build-ci:
	docker build -t capstone-flask:ci -f ./infra/docker/blue/flask/ci/Dockerfile .

publish:
	docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}
	docker tag capstone-nginx:blue minorpatch/capstone-nginx:blue
	docker tag capstone-flask:blue minorpatch/capstone-flask:blue
	docker push minorpatch/capstone-nginx:blue
	docker push minorpatch/capstone-flask:blue

deploy:
	kubectl apply -f ./infra/k8s/deployments/blue.yaml --kubeconfig=${K8S_CONFIG_FILE}
	kubectl apply -f ./infra/k8s/services/blue.yaml --kubeconfig=${K8S_CONFIG_FILE}

run:
	python3 ./code/run.py
