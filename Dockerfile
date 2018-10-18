FROM debian:buster-slim

RUN apt-get update
RUN apt-get install -y \
    build-essential \
    curl \
    gnupg \
    hugo=0.47.1-2

# Install node.js 8.x (LTS at time of writing) from official package.
RUN curl --silent --location https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y update
RUN apt-get install -y nodejs

COPY . /src
WORKDIR /src

ARG HUGO_BASEURL="http://localhost:1313"
ENV HUGO_BASEURL ${BUILD_COMMAND}

# The entrypoint script supports commands "build", "server", or pass-through to sh.
ENTRYPOINT ["/src/entrypoint.sh"]

# Default operation
CMD ["build"]
