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
	python3 -m coverage run -m pytest --junitxml=reports/junit/junit.xml
	python3 -m coverage xml -o reports/junit/coverage.xml
	python3 -m coverage html -d reports/web

performance-test:
	python3 -m locust -f ./code/tests/performance.py --no-web --print-stats --only-summary -c 100 -r 1 -t 1m

lint:
	hadolint ./infra/docker/**/Dockerfile

build:
	docker build -t capstone-nginx:blue -f ./infra/docker/blue/Dockerfile

publish:
	docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}
	docker tag capstone-nginx:blue minorpatch/capstone-nginx:blue
	docker push minorpatch/capstone-nginx:blue

deploy:
	kubectl version --token=${K8S_TOKEN} --server=${K8S_API_SERVER} --insecure-skip-tls-verify=true
	kubectl apply -f ./infra/k8s/deployments/blue.yaml --token=${K8S_TOKEN} --server=${K8S_API_SERVER} --insecure-skip-tls-verify=true
	kubectl apply -f ./infra/k8s/services/blue.yaml --token=${K8S_TOKEN} --server=${K8S_API_SERVER} --insecure-skip-tls-verify=true

run:
	python3 ./code/run.py
