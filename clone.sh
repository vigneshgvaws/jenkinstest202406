#!/bin/bash

# Check if release.info file exists
RELEASE_FILE="release.info"
if [ ! -f "$RELEASE_FILE" ]; then
    echo "Error: $RELEASE_FILE not found."
    exit 1
fi

# Read repository URLs and branch names from release.info
mapfile -t REPO_BRANCHES < "$RELEASE_FILE"

# Function to clone a repository and check out a specific branch
clone_and_checkout_branch() {
    REPO_URL="$1"
    REPO_NAME=$(basename "$REPO_URL" ".git")
    BRANCH_NAME="$2"
    
    echo "Cloning $REPO_URL and checking out $BRANCH_NAME..."
    git clone "$REPO_URL" --branch "$BRANCH_NAME" --single-branch "$REPO_NAME"
}

# Clone repositories and check out branches
for REPO_BRANCH in "${REPO_BRANCHES[@]}"; do
    REPO_URL=$(echo "$REPO_BRANCH" | cut -d' ' -f1)
    BRANCH_NAME=$(echo "$REPO_BRANCH" | cut -d' ' -f2)
    clone_and_checkout_branch "$REPO_URL" "$BRANCH_NAME"
done

# Create a zip file for checked-out branches
echo "Creating zip file for checked-out branches..."
zip -r checked_out_branches.zip */
