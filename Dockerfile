# This is a multi-stage Dockerfile (build and run)

# Remember to target specific version in your base image,
# because you want reproducibility (in a few years you will thank me)
FROM alpine:3.9 AS build

# The Hugo version
ARG VERSION=0.87.0

ADD https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz /hugo.tar.gz
RUN tar -zxvf hugo.tar.gz
RUN /hugo version

# We add git to the build stage, because Hugo needs it with --enableGitInfo
RUN apk add --no-cache git

# The source files are copied to /site
COPY . /site
WORKDIR /site

RUN mkdir themes
WORKDIR /site/themes
RUN git clone https://github.com/themefisher/dot-hugo

# And then we just run Hugo
WORKDIR /site/LiveSite
RUN pwd
RUN ls
RUN /hugo --minify --gc --themesDir /site/themes
