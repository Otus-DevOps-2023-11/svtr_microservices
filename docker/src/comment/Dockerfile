FROM ruby:2.4-alpine

RUN apk --update add build-base && rm -rf /etc/apk/cache && rm -rf /var/cache/apk

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME

ENV COMMENT_DATABASE_HOST=comment_db COMMENT_DATABASE=comments

CMD ["puma"]
