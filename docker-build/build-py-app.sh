#!/bin/bash

IMAGE_NAME="flask-builder-app"

# Check if the Docker image already exists
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "Docker image '$IMAGE_NAME' not found. Building the image..."
    docker build -t $IMAGE_NAME .
else
    echo "Docker image '$IMAGE_NAME' already exists. Skipping build."
fi


# Prompt user for the port number
read -p "Enter the port number to find and stop the Docker container: " TARGET_PORT

# Find the container ID using the given port
CONTAINER_ID=$(docker ps --filter "publish=$TARGET_PORT" --format "{{.ID}}")

if [ -n "$CONTAINER_ID" ]; then
    echo "Found container $CONTAINER_ID using port $TARGET_PORT. Stopping it..."
    docker stop $CONTAINER_ID
    docker rm $CONTAINER_ID
    echo "Container $CONTAINER_ID stopped and removed."
else
    echo "No container is using port $TARGET_PORT."
fi

# Run the Docker container
echo "Running the Docker container..."
docker run -d -p $TARGET_PORT:$TARGET_PORT \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    flask-builder-app


# Wait for the container to start up
echo "Waiting for the container to start..."
sleep 5

# Prompt user for IP address to test
read -p "Enter the server IP address to test with curl: " SERVER_IP

# Perform curl to the running container
echo "Testing the application on http://$SERVER_IP:$TARGET_PORT/"
curl http://$SERVER_IP:$TARGET_PORT/