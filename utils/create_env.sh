#!/bin/bash

# Define the output script filename
OUTPUT_FILE="pattern_env.sh"

# Check if the output script already exists
if [ -f "$OUTPUT_FILE" ]; then
  echo "The file '$OUTPUT_FILE' already exists. Exiting."
  exit 1
fi

# Prompt for environment variables
read -p "Enter value for S3_BACKEND_BUCKET: " S3_BACKEND_BUCKET
read -p "Enter value for S3_BACKEND_KEY [default: terraform.tfstate]:" S3_BACKEND_KEY
read -p "Enter value for S3_BACKEND_REGION: " S3_BACKEND_REGION
read -p "Enter value for ENVIRONMENT_NAME: " ENVIRONMENT_NAME
read -p "Enter value for TARGET_REGION: " TARGET_REGION

# Set default for S3_BACKEND_KEY if empty
S3_BACKEND_KEY=${S3_BACKEND_KEY:-terraform.tfstate}

# Create the output script with export commands
cat <<EOF > "$OUTPUT_FILE"
#!/bin/bash
export S3_BACKEND_BUCKET="$S3_BACKEND_BUCKET"
export S3_BACKEND_KEY="$S3_BACKEND_KEY"
export S3_BACKEND_REGION="$S3_BACKEND_REGION"
export ENVIRONMENT_NAME="$ENVIRONMENT_NAME"
export TARGET_REGION="$TARGET_REGION"
EOF

# Make the script executable
chmod +x "$OUTPUT_FILE"

echo "Environment variables script '$OUTPUT_FILE' has been created."

