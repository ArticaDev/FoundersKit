FROM ruby:3.2.0 

WORKDIR /app

COPY . ./

RUN gem install bundler  &&\
  bundle config set path /usr/local/bundle/
RUN bundle install

EXPOSE 3000 3000

CMD bundle exec rails s -p 3000 -b '0.0.0.0'