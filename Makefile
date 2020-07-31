.EXPORT_ALL_VARIABLES:
IMAGE = "jahrik/toupee_touche"
TAG := $(shell uname -m)
STACK = tt

define node_npm
	@docker run --rm \
    -v $$PWD/v2:/v2 \
		-w /v2 \
    --user $(shell id -u):$(shell id -g) \
		node $(1)
endef

all: build

npm:
	$(call node_npm,npm install)

build:
	@docker build -t ${IMAGE}:$(TAG) -f Dockerfile_${TAG} .

push:
	@docker push ${IMAGE}:$(TAG)

up:
	@docker-compose up -d

deploy:
	@docker stack deploy --with-registry-auth -c docker-stack.yml $(STACK)

clean:
	-rm -rf node_modules

.PHONY: all build push test deploy
