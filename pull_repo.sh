#!/bin/bash

# Directory where your repositories are located
REPOS_DIR="/path/to/your/repos"

# Get all directories in the repositories directory
REPOS=$(ls -d $REPOS_DIR/*/)

# Pull the latest changes for each repository
for REPO in $REPOS; do
  cd "$REPO" || continue
  echo "Pulling latest changes for $(basename $REPO)"
  git pull https://username:password@repository/file.git --all
  cd "$REPOS_DIR" || exit
done
