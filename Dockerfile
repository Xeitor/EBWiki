FROM ruby:2.6.5

COPY Gemfile Gemfile.lock /

RUN gem install bundler && \
    bundle install && \
    gem install fakes3 && \
    apt-get update -qq && \
    apt-get install apt-transport-https && \
    wget -q https://artifacts.elastic.co/GPG-KEY-elasticsearch &&\
    apt-key add GPG-KEY-elasticsearch && \
    echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" > \
        /etc/apt/sources.list.d/elastic-6.x.list && \
    apt-get update -qq && \
    apt-get install -qq --no-install-recommends \
        apt-utils \
        build-essential \
        libpq-dev \
        nodejs \
        npm \
        default-jre \
        postgresql  \
        redis-server && \
    apt-get install -qq --no-install-recommends elasticsearch && \
    mkdir /usr/src/ebwiki

WORKDIR /usr/src/ebwiki
EXPOSE 3000
COPY . /usr/src/ebwiki
ENTRYPOINT ["/usr/src/ebwiki/dev_provisions/entrypoint.sh"]
CMD ["bundle","exec","rails","server","-b","0.0.0.0","-e","development"]
