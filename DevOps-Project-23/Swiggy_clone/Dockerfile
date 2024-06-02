# Use Node.js 16 slim as the base image
FROM node:16

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Expose port 3000 (or the port your app is configured to listen on)
EXPOSE 3000

# Start your Node.js server (assuming it serves the React app)
CMD ["npm", "start"]
