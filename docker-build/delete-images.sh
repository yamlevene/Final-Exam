#!/bin/bash

# Get list of docker images (excluding the header line and removing duplicates)
images=$(docker images --format "{{.Repository}}:{{.Tag}}:{{.ID}}" | sort -u)

# Check if there are any images
if [ -z "$images" ]; then
    echo "No Docker images found."
    exit 0
fi

# Iterate through each image
for image in $images; do
    image_id=$(echo $image | awk -F':' '{print $3}')
    while true; do
        echo -e "\nCurrent image: $image"
        read -p "Do you want to delete this image? (y/n/q to quit): " choice
        
        case $choice in
            [Yy]*)
                echo "Deleting $image..."
                docker rmi -f "$image_id"
                break
                ;;
            [Nn]*)
                echo "Keeping $image"
                break
                ;;
            [Qq]*)
                echo "Stopping the script..."
                exit 0
                ;;
            *)
                echo "Please enter y (yes), n (no), or q (quit)"
                ;;
        esac
    done
done

echo "Finished processing all images."