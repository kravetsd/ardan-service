SHELL := /bin/bash

run:
	go run main.go

build: 
	go build -ldflags "-X main.build=local"



# ==============================================================================
# Building containers

VERSION := 1.0

all: sales-api

sales-api:
	docker build \
		-f zarf/docker/dockerfile.sales-api\
		-t kdykrg/sales-api:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		.

gcp-up:
	gcloud compute instances start worker-0 worker-1 worker-2 controller-0 controller-1 controller-2

gcp-shutdown:
	gcloud compute instances stop worker-0 worker-1 worker-2 controller-0 controller-1 controller-2

kube-apply:
	kustomize build zarf/k8s/gcp/sales-api | kubectl apply -f -

kube-logs:
	kubectl logs -l app=sales-api -n sales-api --all-containers=true -f --tail=100

kube-restart:
	kubectl rollout restart deployment sales-api-pod -n sales-api

kube-status:
	kubectl get pods -n sales-api --watch

kube-load:
	docker push kdykrg/sales-api:$(VERSION)

kube-update: all kube-load kube-apply kube-restart

tidy:
	go mod tidy
	go mod vendor