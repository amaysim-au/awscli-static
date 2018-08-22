ifdef GO_PIPELINE_LABEL
	ENV_RM_REQUIRED?=rm_env
	BUILD_VERSION:=$(GO_PIPELINE_LABEL)
endif
ifdef AWS_ROLE
	ASSUME_REQUIRED?=assumeRole
endif
ifdef DOTENV
  DOTENV_TARGET=dotenv
else
  DOTENV_TARGET=.env
endif

DOCKER_NAMESPACE=634961025262.dkr.ecr.ap-southeast-2.amazonaws.com
IMAGE_NAME ?= $(DOCKER_NAMESPACE)/devops/alpine-awscli
BUILD_VERSION ?= local

dockerBuild:
	docker-compose run buildAwsCli cp /usr/local/bin/aws /dist
	docker-compose build distAwsCli
.PHONY: dockerBuild

dockerTag:
	docker tag $(IMAGE_NAME):dist-local $(IMAGE_NAME):latest
	docker tag $(IMAGE_NAME):dist-local $(IMAGE_NAME):$(BUILD_VERSION)
.PHONY: dockerTag

ecrLogin:
	$(shell aws ecr get-login --no-include-email --region ap-southeast-2)
.PHONY: ecrLogin

dockerPush: ecrLogin dockerTag
	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):$(BUILD_VERSION)
.PHONY: dockerPush

assumeRole: $(DOTENV_TARGET)
	docker run --rm -e "AWS_ACCOUNT_ID" -e "AWS_ROLE" amaysim/aws:1.2.0 assume-role.sh >> $(DOTENV_TARGET)
.PHONY: assumeRole

###################
# OTHERS          #
###################
# Removes the .env file before each deploy to force regeneration without cleaning the whole environment
rm_env:
	rm -f .env

.env:
	@echo "Create .env with .env.template"
	cp .env.template .env

# Create/Overwrite .env with $(DOTENV)
dotenv:
	@echo "Overwrite .env with $(DOTENV)"
	cp $(DOTENV) .env
