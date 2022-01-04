#!/bin/sh
set -x

# Set environment variables
echo NEXT_PUBLIC_APP_URL $NEXT_PUBLIC_APP_URL
find \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i "s#APP_NEXT_PUBLIC_APP_URL_VAR#$NEXT_PUBLIC_APP_URL#g"
find \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i "s#APP_NEXT_PUBLIC_LICENSE_CONSENT_VAR#$NEXT_PUBLIC_LICENSE_CONSENT#g"

/app/scripts/wait-for-it.sh ${DATABASE_HOST} -- echo "database is up"
npx prisma migrate deploy
yarn start
