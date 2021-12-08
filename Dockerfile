FROM python:3-alpine AS build

# Install requirements.
COPY ./requirements.txt /
RUN pip install --requirement /requirements.txt

# Copy source.
COPY ./mkdocs.yml /
COPY ./docs /docs

# Build static files.
RUN mkdocs build

# Second stage
FROM nginx:1-alpine

# Replace nginx' default configuration with ours.
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy built static files to HTTP root.
COPY --from=build /site /usr/share/nginx/html/
