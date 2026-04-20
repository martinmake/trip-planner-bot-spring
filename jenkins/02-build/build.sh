#!/bin/sh

set -xe

cd TripPlannerBot
./gradlew clean shadowJar --no-daemon
