FROM ubuntu:latest AS build-env

RUN apt-get update
RUN apt-get install -yqq curl git unzip ssh

ARG FLUTTER_SDK=/usr/local/flutter
ARG FLUTTER_VERSION=3.16.5
ARG APP=/app/

RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK
RUN cd $FLUTTER_SDK && git fetch && git checkout $FLUTTER_VERSION

ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v
RUN mkdir $APP
COPY . $APP
WORKDIR $APP

RUN flutter clean
RUN flutter pub get
RUN flutter pub run build_runner build --delete-conflicting-outputs
RUN flutter build web

FROM nginx:1.25.2-alpine

COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]