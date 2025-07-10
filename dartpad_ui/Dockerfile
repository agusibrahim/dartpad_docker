
FROM instrumentisto/flutter:latest AS builder
USER 1000:1000
WORKDIR /app
RUN git clone https://github.com/dart-lang/dart-pad.git .
ARG DART_SERVICES_IP
COPY patch.dart /app/patch_dartpad_shared_files.dart
RUN dart /app/patch_dartpad_shared_files.dart "$DART_SERVICES_IP"
WORKDIR /app/pkgs/dartpad_ui
RUN flutter pub get
RUN flutter build web --wasm --release
FROM caddy:latest
COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /app/pkgs/dartpad_ui/build/web /usr/share/caddy/html
EXPOSE 80