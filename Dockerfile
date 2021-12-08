FROM python:3-alpine AS build

COPY ./mkdocs.yml /
COPY ./docs /docs

RUN pip install mkdocs mkdocs-material mkdocs-minify-plugin

RUN mkdocs build

FROM nginx:1-alpine

COPY --from=build /site /usr/share/nginx/html/
