FROM nginx:alpine

## Install Packages
RUN apk add --no-cache \
    python3 \
    py3-pip \
    git \
## Install Build dependencies (for some mkdocs requirements)
  && apk add --no-cache --virtual .build-deps \
      build-base \
      curl \
      wget \
      make \
      python3-dev \
  && pip3 install \
      wheel \
## Install mkdocs
  && pip3 install \
      mkdocs \
      pygments \
      mkdocs-material \
      mkdocs-safe-text-plugin \
      git+https://github.com/jldiaz/mkdocs-plugin-tags.git \
      mkdocs-markdownextradata-plugin \
      mkdocs-codeinclude-plugin \
      mkdocs-git-revision-date-localized-plugin \
      mkdocs-git-authors-plugin \
      mkdocs-blog-plugin \
      mkdocs-img2fig-plugin \
      mkdocs-mermaid2-plugin \
      mkdocs-awesome-pages-plugin \
      git+https://github.com/andyoakley/mkdocs-navtitles \
      mkdocs-redirects \
## Delete possible PIP cache
  && rm -rf "$HOME/.cache" \
## Remove build-dep packages
  && apk del .build-deps

## Expose the web port used by nginx
EXPOSE 80

## By default, use this project's own git repo for the wiki
ENV DOC_REPO github.com/gadkins/uffizzi-docs
## To use with a private repository, you need an access token
ENV ACCESS_TOKEN ''

## Args used by labels
ARG BUILD_DATE
ARG VCS_REF

## Label the image
LABEL maintainer="Nicholas Westerhausen"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="Simple mkdocs Site"
LABEL org.label-schema.description="Build and serve an mkdocs site pulled from a git repo."
LABEL org.label-schema.url="https://github.com/nwesterhausen/docker-nginx-mkdocs-material"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vcs-url="https://github.com/nwesterhausen/docker-nginx-mkdocs-material"
LABEL org.label-schema.cmd="docker run -d -p 127.0.0.1:80:80 -e DOC_REPO=https://github.com/nwesterhausen/docker-nginx/mkdocs-material nwesterhausen/static-mkdocs-material"
LABEL org.label-schema.schema-version="1.0"

## run.sh is executed when running the docker image
COPY run.sh /run.sh
RUN chmod +x /run.sh \
  && mkdir /docs

CMD /run.sh