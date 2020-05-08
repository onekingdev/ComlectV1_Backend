FROM ruby:2.5.7

RUN apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
      postgresql-client \
      build-essential \
      nodejs \
      libreoffice \
      wkhtmltopdf \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists

# Install Yarn
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version 1.13.0 && \
  ln -sf $HOME/.yarn/bin/yarn /usr/local/bin/yarn && \
  ln -sf $HOME/.yarn/bin/yarnpkg /usr/local/bin/yarnpkg

RUN gem install bundler

#Install gems
RUN mkdir /gems
WORKDIR /gems
COPY Gemfile* ./
RUN bundle install  --without development test

ARG INSTALL_PATH=/var/www/complect/current
ENV INSTALL_PATH $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY . .
RUN bundle exec rake assets:precompile

#CMD bundle exec unicorn -p 3000
CMD bundle exec puma -C config/puma.rb
