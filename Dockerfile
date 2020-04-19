FROM google/dart

EXPOSE 8080
WORKDIR /app

COPY pubspec.yaml ./
COPY ./lib ./lib
COPY ./bin ./bin
RUN pub get

CMD [ "dart", "./bin/main.dart" ]
