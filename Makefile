.PHONY: test registry
registry:
		-docker network rm hola
		-docker network create hola
		-docker stop myregistrydomain.com
		-docker rm myregistrydomain.com
		docker run -d --publish-all -p 5000:5000 --network=hola --restart always --name myregistrydomain.com -v `pwd`/test/fixtures/certs:/certs -v `pwd`/test/fixtures/auth:/auth -e "REGISTRY_AUTH=htpasswd" -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key registry:2

test:
	-docker stop test-builder-job
	-docker rm test-builder-job
	-docker stop test-builder-job-checkdockerd-sock
	-docker rm test-builder-job-checkdockerd-sock
	docker build -t bithavoc/git-builder:latest .
	docker run --privileged --network=hola --name test-builder-job-checkdockerd-sock -e "DOCKER_USER=testuser" -e "DOCKER_PASS=testpass" -e "DOCKER_ENDPOINT=myregistrydomain.com:5000" -e "SSH_KEY=$(shell cat test/fixtures/deploy_key.key.base64)" -e "GIT_REPO=git@github.com:bithavoc/git-builder-private-hello.git" -e "IMAGE_TAG=myregistrydomain.com:5000/git-builder-private-hello:latest" -e "DOCKERD_MODE=sock" -e "ONLY_CHECK_DOCKERD=1" -v /var/run/docker.sock:/var/run/docker.sock bithavoc/git-builder:latest
	docker run --privileged --network=hola --name test-builder-job -e "DOCKER_USER=testuser" -e "DOCKER_PASS=testpass" -e "DOCKER_ENDPOINT=myregistrydomain.com:5000" -e "SSH_KEY=$(shell cat test/fixtures/deploy_key.key.base64)" -e "GIT_REPO=git@github.com:bithavoc/git-builder-private-hello.git" -e "IMAGE_TAG=myregistrydomain.com:5000/git-builder-private-hello:latest" bithavoc/git-builder:latest
