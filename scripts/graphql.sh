#!/bin/bash
# GraphQL helper script
ENDPOINT=$(grep BACKEND_BASE_URL .env 2>/dev/null | cut -d'=' -f2 | tr -d ' "'"'"'')
echo "Downloading schema from: $ENDPOINT"
npx -y get-graphql-schema "$ENDPOINT" > lib/core/services/graphql/queries/schema.graphql
echo "✓ Schema downloaded"
dart run build_runner build