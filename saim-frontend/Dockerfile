# Stage 1: Build the Flutter app
FROM ghcr.io/cirruslabs/flutter:latest AS build

# Set the working directory
WORKDIR /app

# Copy the app source code
COPY . .

# Get Flutter dependencies
RUN flutter pub get

# Build the web version
RUN flutter build web --release

# Stage 2: Serve the app with Nginx
FROM nginx:alpine

# Copy the build output to replace the default nginx contents.
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
