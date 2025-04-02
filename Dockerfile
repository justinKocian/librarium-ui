# --- Build Stage ---
FROM node:20-alpine AS builder

WORKDIR /app

# Copy only the package descriptors first (for better caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the full source
COPY . .

# Build the static site
RUN npm run build

# --- Output Stage (used by NGINX container via volume) ---
FROM alpine:3.18 AS output
WORKDIR /dist

# Copy the built site only
COPY --from=builder /app/dist .

# NGINX will mount this folder as a volume
