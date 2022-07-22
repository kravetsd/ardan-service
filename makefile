SHELL := /bin/bash

run:
	go run main.go

build: 
	go build -ldflags "-X main.build=local"



# ==============================================================================
# Building containers

VERSION := 1.0

all: ardan-service

ardan-service:
	docker build \
		-f zarf/docker/dockerfile\
		-t sales-api-amd64:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		.

gcp-up:
	gcloud compute instances start worker-0 worker-1 worker-2 controller-0 controller-1 controller-2

gcp-shutdown:
	gcloud compute instances stop worker-0 worker-1 worker-2 controller-0 controller-1 controller-2