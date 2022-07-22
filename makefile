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
		-t kdykrg/ardan-service:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		.

gcp-up:
	gcloud compute instances start worker-0 worker-1 worker-2 controller-0 controller-1 controller-2

gcp-shutdown:
	gcloud compute instances stop worker-0 worker-1 worker-2 controller-0 controller-1 controller-2

kube-apply:
	cat zarf/k8s/ardan-service.yaml | kubectl apply -f -

kube-logs:
	kubectl logs -l app=ardan-service -n ardan-service --all-containers=true -f --tail=100
