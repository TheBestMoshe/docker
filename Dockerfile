FROM node:14 as deps

WORKDIR /app
COPY calendso/package.json calendso/yarn.lock ./
COPY calendso/prisma prisma
RUN yarn install --frozen-lockfile

FROM node:14 as builder

WORKDIR /app

COPY calendso .

COPY --from=deps /app/node_modules ./node_modules
RUN NEXT_PUBLIC_APP_URL=APP_NEXT_PUBLIC_APP_URL_VAR \
    NEXT_PUBLIC_LICENSE_CONSENT=APP_NEXT_PUBLIC_LICENSE_CONSENT_VAR \
    yarn build && \
    yarn install --production --ignore-scripts --prefer-offline

FROM node:14 as runner
WORKDIR /app
ENV NODE_ENV production

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/scripts ./scripts
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/next-i18next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/package.json ./package.json
COPY  scripts scripts

EXPOSE 3000
CMD ["/app/scripts/start.sh"]
