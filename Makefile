.EXPORT_ALL_VARIABLES:
IMAGE = "jahrik/toupee_touche"
TAG := $(shell uname -m)
STACK = tt

all: build

build:
	@docker build -t ${IMAGE}:$(TAG) -f Dockerfile_${TAG} .

push:
	@docker push ${IMAGE}:$(TAG)

test:
	@docker-compose up -d

deploy:
	@docker stack deploy --with-registry-auth -c docker-stack.yml $(STACK)

.PHONY: all build push test deploy
