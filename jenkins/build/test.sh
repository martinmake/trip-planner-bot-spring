#!/bin/sh

set -xeu

cd TripPlannerBot
docker compose up -d --build
sleep 30
docker compose ps
docker compose logs --tail=50 app
curl -f http://localhost:8080/healthcheck || echo "Healthcheck failed"
docker compose down -v
