FROM python:3-alpine AS build

COPY ./requirements.txt /

RUN pip install --requirement /requirements.txt

COPY ./mkdocs.yml /
COPY ./docs /docs

RUN mkdocs build

FROM nginx:1-alpine

COPY --from=build /site /usr/share/nginx/html/
