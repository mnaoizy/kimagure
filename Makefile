DATABASE_URL ?= 
# DATABASE_URL ?= postgres://postgres:postgres@localhost:5432/chinese_app?sslmode=disable

.PHONY: help migrate-up migrate-down migrate-force docker-up docker-down docker-build buf-generate sqlc-generate seed run-server

help:
	@echo "Available targets:"
	@echo "  migrate-up       - Apply all database migrations"
	@echo "  migrate-down     - Roll back all database migrations"
	@echo "  migrate-force    - Force a specific migration version"
	@echo "  docker-up        - Start docker containers"
	@echo "  docker-down      - Stop docker containers"
	@echo "  docker-build     - Build docker images"
	@echo "  deploy           - Deploy the application"
	@echo "  deploy-jobs      - Deploy the jobs"
	@echo "  invoke-tts       - Invoke the TTS job"
	@echo "  buf-generate     - Generate protobuf code"
	@echo "  sqlc    		  - Generate SQL code"
	@echo "  seed             - Seed the database with initial data"
	@echo "  test-mobile	  - Run mobile tests"
	@echo "dev"               - Run mobile in development mode

migrate-up:
	migrate -path db/migrations -database "$(DATABASE_URL)" up

migrate-down:
	migrate -path db/migrations -database "$(DATABASE_URL)" down

migrate-force:
	migrate -path db/migrations -database "$(DATABASE_URL)" force $(version)

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-build:
	docker-compose build

deploy:
	cd server && gcloud builds submit --config cloudbuild.yaml .

deploy-jobs:
	cd server && gcloud builds submit --config cloudbuild.job.yaml .

invoke-tts:
	gcloud run jobs execute tts-job --region asia-northeast1

buf-generate:
	buf generate

sqlc:
	sqlc generate

seed:
	cd server/cmd/seed && go run main.go

test-mobile:
	cd mobile && flutter test

dev:
	cd mobile && flutter run --device-id 00008101-0016494A3A30001E