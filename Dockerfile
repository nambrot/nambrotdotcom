FROM ruby:2.2.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install --path vendor
ADD . /myapp
RUN bundle exec rake assets:clean
RUN bundle exec rake assets:precompile
CMD bundle exec rails server -b 0.0.0.0
