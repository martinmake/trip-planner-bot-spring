#!/bin/sh

set -xeu

cd TripPlannerBot
podman compose up -d --build
sleep 30
podman compose ps
podman compose logs --tail=50 app
curl -f http://localhost:8088/healthcheck || echo "Healthcheck failed"
podman compose down -v
