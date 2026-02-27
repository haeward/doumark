FROM node:20-alpine AS builder

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY src ./src
RUN npm run build

FROM alpine:3.20
COPY --from=builder /app/dist/doumark /bin/doumark
ENTRYPOINT ["doumark"]
