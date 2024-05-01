FROM ruby:2.4-alpine

RUN apk --update add build-base && rm -rf /etc/apk/cache && rm -rf /var/cache/apk

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME

ENV POST_SERVICE_HOST=post POST_SERVICE_PORT=5000 COMMENT_SERVICE_HOST=comment COMMENT_SERVICE_PORT=9292

CMD ["puma"]
