
FROM instrumentisto/flutter:latest
USER 1000:1000
WORKDIR /app
RUN git clone https://github.com/dart-lang/dart-pad.git .
ARG PUB_PACKAGE
COPY patch.dart /app/modify_packages.dart
RUN dart /app/modify_packages.dart "$PUB_PACKAGE"
WORKDIR /app/pkgs/dart_services
RUN dart pub get
RUN dart tool/grind.dart build-storage-artifacts
RUN dart tool/grind.dart build-project-templates
EXPOSE 8080
CMD ["dart", "bin/server.dart", "--redis-url", "redis://redis:6379"]