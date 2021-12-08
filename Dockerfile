FROM squidfunk/mkdocs-material:8.0.5 AS build

COPY ./mkdocs.yml /
COPY ./docs /docs

WORKDIR /

RUN mkdocs build

FROM nginx:1

COPY --from=build /site /usr/share/nginx/html/
