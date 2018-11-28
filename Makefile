PACKAGE = advent-of-code-2017
DOCKER_IMAGE = $(PACKAGE)-env
DOCKER_COMMAND_BASE = docker run --rm -v $(PWD):/tmp -w /tmp $(DOCKER_IMAGE)
ENVIRONMENTS = py3-test
DOCKER_ENVIRONMENTS = $(patsubst %,%-docker,$(ENVIRONMENTS))
ENVIRONMENT = $(patsubst %-docker, %, $@)

all:
	tox

.PHONY: build-docker
build-docker:
	docker build --tag $(DOCKER_IMAGE) .

.PHONY: $(ENVIRONMENTS)
$(ENVIRONMENTS):
	tox -e $(ENVIRONMENT)

.PHONY: $(DOCKER_ENVIRONMENTS)
$(DOCKER_ENVIRONMENTS): build-docker
	$(DOCKER_COMMAND_BASE) tox -e $(ENVIRONMENT)
