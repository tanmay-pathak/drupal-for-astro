#!/bin/bash
set -e

echo "Starting database initialization..."

MAX_TRIES=100
WAIT_SECONDS=2

echo "Testing database connection..."
for i in $(seq 1 $MAX_TRIES); do
    if drush sql:query "SELECT 1" > /dev/null 2>&1; then
        break
    fi
    echo "Waiting for database connection... ($i/$MAX_TRIES)"
    if [ $i -eq $MAX_TRIES ]; then
        echo "Database connection failed after $MAX_TRIES attempts"
        exit 1
    fi
    sleep $WAIT_SECONDS
done

echo "Database connection successful!"

echo "Running drush deploy..."
drush deploy

echo "Clearing Drupal cache..."
drush cr

echo "Database initialization complete!"
