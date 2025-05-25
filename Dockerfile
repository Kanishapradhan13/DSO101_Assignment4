# Use official Node.js runtime as base image
FROM node:18-alpine

# Create a non-root user (SECURITY BEST PRACTICE #1)
RUN adduser -D appuser

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user (SECURITY BEST PRACTICE #1)
USER appuser

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]