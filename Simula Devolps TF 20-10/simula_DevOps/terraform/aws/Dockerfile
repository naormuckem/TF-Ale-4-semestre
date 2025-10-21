# Stage 1 - build
FROM node:18-alpine AS builder

WORKDIR /app

# copy package files first for caching
COPY package*.json ./

# install deps
RUN npm ci

# copy source
COPY . .

# Stage 2 - runtime
FROM node:18-alpine

WORKDIR /app

ENV NODE_ENV=production

# create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

COPY --from=builder /app /app

EXPOSE 3000

CMD ["npm", "start"]
