# Use the specified Rust version and base OS as the base image
ARG BASE_OS
ARG RUST_VERSION
FROM rust:${RUST_VERSION}-${BASE_OS}

# Nodejs installation

RUN ["mkdir", "/usr/local/nvm"]
WORKDIR /usr/local/node

ARG NODE_VERSION

## Download the Node.js standelone binary archive && extract it && clean files

RUN ["/bin/sh", "-c", "wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz"]
RUN ["/bin/sh", "-c", "tar xf node-v${NODE_VERSION}-linux-x64.tar.xz --strip-components 1"]
RUN ["/bin/sh", "-c", "rm node-v${NODE_VERSION}-linux-x64.tar.xz"]

# Ensure Node.js binaries are available in the PATH
ENV PATH /usr/local/node/bin:$PATH

# create container user with same rights than host user

RUN groupadd -g 1000 appuser && \
    useradd -m -u 1000 -g 1000 -s /bin/bash appuser

# global configuration done ! let's focus on the project itself

WORKDIR /app
RUN chown -R appuser:appuser /app

COPY --chown=appuser:appuser . .

USER appuser