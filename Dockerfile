FROM crystallang/crystal:0.23.1

# Install Dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install -y --no-install-recommends libpq-dev libsqlite3-dev libmysqlclient-dev libreadline-dev git curl vim netcat

# Install Node
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs yarn


# Install Amber
ENV PATH /app/bin:$PATH
WORKDIR /app
COPY shard.yml shard.lock /app/
RUN shards build amber

# Add Project
ADD . /app

# Set config
CMD amber watch
