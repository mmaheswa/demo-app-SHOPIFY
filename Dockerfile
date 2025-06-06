# Stage 1: Build Frontend
FROM node:18-alpine AS frontend

WORKDIR /app

# Copy frontend code and env
COPY web/frontend web/frontend
COPY web/frontend/.env web/frontend/.env

WORKDIR /app/web/frontend

RUN npm install && npm run build

# Stage 2: Final backend image
FROM node:18-alpine

WORKDIR /app

# Copy root and backend files
COPY package*.json ./
COPY web web
COPY .env .env
COPY web/.env web/.env
COPY --from=frontend /app/web/frontend/dist web/frontend/dist

# Install root dependencies
RUN npm install

# Expose the port (adjust if different)
EXPOSE 3000

# Run your app
CMD ["node", "web/index.js"]
