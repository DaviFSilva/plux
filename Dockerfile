# Multi-stage Dockerfile for Flutter web on Railway.
# Stage 1: build the static web bundle with the Flutter SDK.
# Stage 2: serve it with nginx (smaller image, faster cold starts).
#
# Flutter version pinned via ARG so Railway's build cache is stable.

ARG FLUTTER_VERSION=3.41.9

FROM ghcr.io/cirruslabs/flutter:${FLUTTER_VERSION} AS build

WORKDIR /app

# Cache pub dependencies separately from source code.
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Now copy the rest of the source.
COPY . .

# Build for web. --release is implicit when --no-source-maps is set.
# --web-renderer html keeps the bundle small for a prototype.
RUN flutter build web --release

# Stage 2: nginx to serve the static bundle.
FROM nginx:1.27-alpine AS runtime

# SPA fallback: any unknown path falls back to /index.html so Flutter's
# router can take over (essential once we add navigation routes).
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]