FROM ruby:3.2.2

# Set labels for the image
LABEL maintainer="Todo Cartoes"

# Set container environment variables
ENV BUNDLER_VERSION='2.4.14'

# Set container arguments
ARG APP_PATH=/app

# Set default shell call
# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Update Debian NodeJS repository, update OS packages and install mandatory app packages
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
 && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
 && apt-get update -qq \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
        build-essential \
        nodejs \
        postgresql-client \
        net-tools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install bundler (Ruby dependency manager)
RUN gem install bundler --no-document -v '1.17.3'

# Set working directory
WORKDIR $APP_PATH

# Copy Gemfile and Gemfile.lock
COPY Gemfile* $APP_PATH/

# Install ruby dependencies
RUN bundle install

# Copy application files
COPY . $APP_PATH/