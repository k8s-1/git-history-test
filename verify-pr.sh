#!/bin/bash

# Prompt user for PR number
read -p "Enter the PR number: " PR_NUMBER

# GitHub repository details (modify this)
OWNER="your-org-or-username"
REPO="your-repo"
GITHUB_TOKEN="your-personal-access-token"  # Or use GH CLI for auth

# Get PR details from GitHub API
PR_DATA=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
                -H "Accept: application/vnd.github.v3+json" \
                "https://api.github.com/repos/$OWNER/$REPO/pulls/$PR_NUMBER")

# Check if the PR exists
if echo "$PR_DATA" | grep -q '"message": "Not Found"'; then
    echo "❌ PR #$PR_NUMBER not found!"
    exit 1
fi

# Check if PR is merged
MERGE_DATA=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
                   -H "Accept: application/vnd.github.v3+json" \
                   "https://api.github.com/repos/$OWNER/$REPO/pulls/$PR_NUMBER/merge")

if echo "$MERGE_DATA" | grep -q '"message": "Not Found"'; then
    echo "❌ PR #$PR_NUMBER has NOT been merged!"
    exit 1
fi

# Extract merge commit SHA
MERGE_COMMIT_SHA=$(echo "$PR_DATA" | jq -r '.merge_commit_sha')

if [ "$MERGE_COMMIT_SHA" == "null" ]; then
    echo "❌ Could not find merge commit SHA for PR #$PR_NUMBER!"
    exit 1
fi

echo "✅ PR #$PR_NUMBER was merged. Checking out commit $MERGE_COMMIT_SHA..."

# Fetch and checkout the merged commit
git fetch origin
git checkout $MERGE_COMMIT_SHA

echo "✅ Checked out PR #$PR_NUMBER's merge commit: $MERGE_COMMIT_SHA"
