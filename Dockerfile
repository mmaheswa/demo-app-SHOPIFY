# Stage 1: Build frontend
FROM node:18-alpine AS frontend

WORKDIR /app/frontend

# Copy frontend source and .env
COPY web/frontend/package*.json ./
COPY web/frontend/.env .env
COPY web/frontend ./

RUN npm install && npm run build

# Stage 2: Backend
FROM node:18-alpine

WORKDIR /app

# Copy backend & root config
COPY package*.json ./
COPY .env .env
COPY web web
COPY web/.env web/.env

# Copy built frontend
COPY --from=frontend /app/frontend/dist web/frontend/dist

RUN npm install

EXPOSE 3000

CMD ["node", "web/index.js"]
