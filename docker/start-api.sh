#!/bin/bash

echo "====>> Starting API in development mode"
bundle exec rails server -p 3000 -b 0.0.0.0
