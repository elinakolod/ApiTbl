FROM ruby:2.5.3-slim

USER root

RUN apt-get update -qq && apt-get install -y \
   build-essential \
   libpq-dev \
   libxml2-dev \
   libxslt1-dev \
   cmake \
   pkg-config \
   git \
   imagemagick \
   apt-transport-https \
   curl \
   nano \
   wget \
   unzip

ENV APP_USER app
ENV APP_USER_HOME /home/$APP_USER
ENV APP_HOME /home/www/todoapi

RUN useradd -m -d $APP_USER_HOME $APP_USER

RUN mkdir /var/www && \
    chown -R $APP_USER:$APP_USER /var/www && \
    chown -R $APP_USER $APP_USER_HOME

WORKDIR $APP_HOME

USER $APP_USER

COPY .ruby-version ./
COPY Gemfile Gemfile.lock ./

RUN bundle install --without development test --jobs $(nproc) --retry 5 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

USER root

COPY --chown=root:root . .

ARG RAILS_ENV
ENV RAILS_ENV $RAILS_ENV

ARG MASTER_KEY
ENV MASTER_KEY $MASTER_KEY

RUN echo $MASTER_KEY > $APP_HOME/config/$RAILS_ENV.key

CMD bundle exec puma -C config/puma.rb
