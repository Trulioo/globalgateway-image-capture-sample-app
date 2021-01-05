FROM node:14.11.0-alpine3.10

# Set up env variables
ARG IMAGECAPTURE_SDK_NPM_AUTH_TOKEN
ENV IMAGECAPTURE_SDK_NPM_AUTH_TOKEN=$IMAGECAPTURE_SDK_NPM_AUTH_TOKEN

# Create app directory
WORKDIR /app

# Add bash for easy access
RUN apk add bash

# Install app dependencies
COPY ./package.json ./
COPY ./package-lock.json ./
COPY ./.npmrc ./
COPY ./setup.sh ./

RUN mkdir -p ./public/GlobalGatewayImageCaptureSDK
RUN npm run update-gg-capture
RUN npm ci

# Copy remaining files
COPY ./ ./

# Remove Cache files
RUN rm -rf /var/cache/apk/*

CMD ["npm", "start"]