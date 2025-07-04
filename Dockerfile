```docker
# Dockerfile - Instructions to build the Node.js application image

# Use an official Node.js runtime as a parent image
FROM node:16-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied where available.
# CI systems caching will benefit from this separate step.
RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

# Your app binds to port 8080, so expose that port
EXPOSE 8080

# Define the command to run your app
CMD [ "node", "server.js" ]
