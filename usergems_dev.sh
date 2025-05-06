#!/bin/bash

cd ~/projects/kloodle-original
./vendor/bin/sail down
cd ~/projects/usergems-webapp
docker compose up -d
