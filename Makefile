LOCAL_PATH=$$(pwd)
LOCAL_STACK_NAME=localstack
LOCAL_STACK_TAG=localstack/localstack:2.2.0
TF_NAME=terraform
TF_TAG=local/terraform:1.5
DOCKER_NETWORK_NAME=myapp

build:
	@docker build --tag ${TF_TAG} -f ./Dockerfile . --load

network-up:
	@docker network create ${DOCKER_NETWORK_NAME} || true

network-down:
	@docker network rm ${DOCKER_NETWORK_NAME}

up: build network-up
	@docker run \
    --rm -dt \
    --name ${LOCAL_STACK_NAME} \
    --network ${DOCKER_NETWORK_NAME} \
    -p 4566:4566 \
    -p 4510-4559:4510-4559 \
    -v /var/run/docker.sock:/var/run/docker.sock \
		${LOCAL_STACK_TAG}
	@docker run \
		--rm -dt \
		--name ${TF_NAME} \
		--network ${DOCKER_NETWORK_NAME} \
		--entrypoint tail \
		-v ${LOCAL_PATH}/app:/app \
		${TF_TAG} \
		-f /dev/null

down:
	@docker stop ${LOCAL_STACK_NAME} ${TF_NAME}
	@docker network rm ${DOCKER_NETWORK_NAME}
	@docker rmi ${TF_TAG}

conn:
	@docker exec -it ${TF_NAME} /bin/sh
