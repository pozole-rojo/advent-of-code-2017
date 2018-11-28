PACKAGE = advent-of-code-2017
DOCKER_IMAGE = $(PACKAGE)-env
DOCKER_HOST_USER_PERMS = -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro
DOCKER_VOLUMES := -v $(PWD):/tmp/build $(DOCKER_HOST_USER_PERMS)
DOCKER_ENVIRONMENT_VARS = -e PYTEST_ARGS='$(PYTEST_ARGS)' -e HOME='$(PWD)'
DOCKER_USER := -u $(shell id -u):$(shell id -g)
DOCKER_RUN_FLAGS = --rm $(DOCKER_VOLUMES) $(DOCKER_USER) -w /tmp/build
DOCKER_INTERACTIVE := $(shell test -t 0 && echo "-it")
DOCKER_COMMAND_BASE = docker run $(DOCKER_INTERACTIVE) $(DOCKER_RUN_FLAGS) $(DOCKER_ENVIRONMENT_VARS) $(DOCKER_IMAGE)
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

.PHONY: all-docker
all-docker: build-docker $(DOCKER_ENVIRONMENT_METAS)
	$(DOCKER_COMMAND_BASE) tox

.PHONY: $(DOCKER_ENVIRONMENTS)
$(DOCKER_ENVIRONMENTS): build-docker
	$(DOCKER_COMMAND_BASE) tox -e $(ENVIRONMENT)

clean:
	@find . -regextype posix-egrep -regex "(.*__pycache__$$)|(.*\.py[oc]$$)" -delete
	@rm -rf $(PACKAGE).egg-info .tox .python_scaffold_meta* dist/ build/
