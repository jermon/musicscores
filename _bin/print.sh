#!/bin/bash

# Define the tag name
TAG_NAME="LastPrinted"

# Check if the tag exists
if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
    # List all added or modified files since the tag
    echo "Files added or modified since tag $TAG_NAME:"
    git diff --name-status "$TAG_NAME" HEAD | grep -E '^(A|M)' | awk '{print $2}'
else
    echo "Tag $TAG_NAME does not exist."
    exit 1
fi

# Update the tag to point to the latest commit
echo "Updating tag $TAG_NAME to the latest commit..."
git tag -f "$TAG_NAME"

# Push the updated tag to the remote repository (optional)
# Uncomment the next line if you want to push the tag update to a remote (e.g., 'origin')
# git push origin "$TAG_NAME" --force

echo "Tag $TAG_NAME has been updated to the latest commit."
