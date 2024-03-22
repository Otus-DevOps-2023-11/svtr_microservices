FROM ruby:2.2
#FROM ubuntu:20.04
RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list && \
    apt-get update -qq && apt-get install -y build-essential
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install
#RUN apt-get update -qq && apt-get install -y ruby build-essential && gem install bundler -v 1.17.2
COPY . $APP_HOME
ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments
CMD ["puma"]
