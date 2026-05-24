#!/usr/bin/env bash
# Deploy to S3 + invalidate CloudFront.
# Requires: aws CLI configured, CF_DIST_ID env var set.
# Usage: CF_DIST_ID=EXXXXXXXXXXXXX ./deploy.sh
set -euo pipefail

BUCKET="dayanraj.com"
DIST_ID="${CF_DIST_ID:-}"

if [ -z "$DIST_ID" ]; then
  echo "Error: CF_DIST_ID environment variable is not set."
  echo "Usage: CF_DIST_ID=EXXXXXXXXXXXXX ./deploy.sh"
  exit 1
fi

echo "Syncing to s3://$BUCKET ..."
aws s3 sync . "s3://$BUCKET" \
  --delete \
  --exclude ".git/*" \
  --exclude ".gitignore" \
  --exclude "scripts/*" \
  --exclude "*.sh" \
  --exclude "*.md" \
  --exclude ".DS_Store" \
  --exclude "*.pdf"

echo "Invalidating CloudFront distribution $DIST_ID ..."
aws cloudfront create-invalidation \
  --distribution-id "$DIST_ID" \
  --paths "/*"

echo ""
echo "Done. Site is live at https://dayanraj.com"
