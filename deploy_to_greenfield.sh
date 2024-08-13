#!/bin/bash

# Check if gnfd-cmd is installed
if ! command -v gnfd-cmd &> /dev/null
then
    echo "gnfd-cmd could not be found. Please install it first."
    exit 1
fi

# Check if the bundle directory is provided
if [ $# -eq 0 ]; then
    echo "Please provide the path to your bundle directory."
    echo "Usage: $0 <bundle_directory> <bucket_name>"
    exit 1
fi

# Check if the bucket name is provided
if [ $# -eq 1 ]; then
    echo "Please provide the bucket name for Greenfield."
    echo "Usage: $0 <bundle_directory> <bucket_name>"
    exit 1
fi

BUNDLE_DIR=$1
BUCKET_NAME=$2

# Function to determine content type based on file extension
get_content_type() {
    local file=$1
    case ${file##*.} in
        html|htm)
            echo "text/html"
            ;;
        js)
            echo "application/javascript"
            ;;
        css)
            echo "text/css"
            ;;
        svg)
            echo "image/svg+xml"
            ;;
        jpg|jpeg)
            echo "image/jpeg"
            ;;
        png)
            echo "image/png"
            ;;
        *)
            echo "application/octet-stream"
            ;;
    esac
}

# Function to upload files recursively
upload_files() {
    local dir=$1
    local remote_dir=$2
    
    for file in "$dir"/*; do
        if [ -d "$file" ]; then
            # If it's a directory, recurse into it
            upload_files "$file" "$remote_dir/$(basename "$file")"
        elif [ -f "$file" ]; then
            # If it's a file, upload it with the appropriate content type
            local content_type=$(get_content_type "$file")
            echo "Uploading: $file to $BUCKET_NAME$remote_dir/$(basename "$file") (Content-Type: $content_type)"
            gnfd-cmd -p pass.txt object put --contentType "$content_type" $file $BUCKET_NAME$remote_dir/$(basename "$file")
        fi
    done
}

# Start the upload process
echo "Starting upload to Greenfield bucket: $BUCKET_NAME"
upload_files "$BUNDLE_DIR" ""

echo "Upload complete!"