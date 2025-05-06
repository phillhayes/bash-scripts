#!/bin/bash

# Stop and remove all Docker containers
docker rm -f $(docker ps -aq)

# Navigate to your Laravel project directory
cd ~/projects/kloodle-original

# Start Laravel Sail
./vendor/bin/sail up -d
