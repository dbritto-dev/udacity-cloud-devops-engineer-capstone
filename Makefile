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
	$(eval CID=$(shell docker run --rm -d capstone-flask:ci))
	docker exec -i ${CID} python -m pytest -vv
	docker stop ${CID}

test-artifacts:
	$(eval CID=$(shell docker run --rm -d capstone-flask:ci))
	docker exec -i ${CID} python -m coverage run -m pytest --junitxml=reports/junit/junit.xml
	docker exec -i ${CID} python -m coverage xml -o reports/junit/coverage.xml
	docker exec -i ${CID} python -m coverage html -d reports/web
	docker cp ${CID}:/app/reports ./reports
	docker stop ${CID}

performance-test:
	$(eval CID=$(shell docker run --rm -d capstone-flask:ci))
	docker exec -i ${CID} python -m locust -H http://127.0.0.1:8080 -f ./tests/performance.py --headless --print-stats --only-summary -u 100 -r 1 -t 1m
	docker stop ${CID}

lint:
	$(eval CID=$(shell docker run --rm -d capstone-flask:ci))
	hadolint ./infra/docker/**/**/*/Dockerfile
	docker exec -i ${CID} python -m pylint capstone/ tests/
	docker stop ${CID}

build:
	docker build -t capstone-nginx:green -f ./infra/docker/green/nginx/Dockerfile .
	docker build -t capstone-flask:green -f ./infra/docker/green/flask/Dockerfile .

build-ci:
	docker build -t capstone-flask:ci -f ./infra/docker/green/flask/ci/Dockerfile .

publish:
	docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}
	docker tag capstone-nginx:green minorpatch/capstone-nginx:green
	docker tag capstone-flask:green minorpatch/capstone-flask:green
	docker push minorpatch/capstone-nginx:green
	docker push minorpatch/capstone-flask:green

deploy:
	kubectl apply -f ./infra/k8s/deployments/green.yaml --kubeconfig=${K8S_CONFIG_FILE}
	kubectl apply -f ./infra/k8s/services/green.yaml --kubeconfig=${K8S_CONFIG_FILE}

run:
	python3 ./code/run.py
