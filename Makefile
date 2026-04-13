# Makefile for building, running, and pushing the Python Lambda container image to AWS ECR.

# If a .env file exists, load environment variables from it.
ifneq (,$(wildcard .env))
include .env
export
endif

IMAGE_NAME ?= python-lambda-template
IMAGE_TAG ?= latest
AWS_PROFILE ?=

# Construct the AWS CLI command with optional profile argument.
AWS_CLI = aws $(if $(AWS_PROFILE),--profile $(AWS_PROFILE),)

build:
	# Build the Lambda container image locally.
	docker build -t $(IMAGE_NAME) .

run:
	# Run the Lambda container in foreground mode on local port 9000.
	docker run -p 9000:8080 $(IMAGE_NAME)

rund:
	# Run the Lambda container in detached mode on local port 9000.
	docker run -d -p 9000:8080 $(IMAGE_NAME)

invoke:
	# Invoke the local Lambda endpoint with the sample event payload.
	curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
	-d @events/test_event.json

ecr-login:
	# Authenticate Docker to the target AWS ECR registry.
	$(AWS_CLI) ecr get-login-password --region $(AWS_REGION) | \
	docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

tag:
	# Tag the local image with the fully qualified ECR repository tag.
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME):$(IMAGE_TAG)

push:
	# Push the tagged image to AWS ECR.
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME):$(IMAGE_TAG)