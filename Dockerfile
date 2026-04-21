FROM ruby:3.3

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app


COPY rails_bookshop ./rails_bookshop
WORKDIR /usr/src/app/rails_bookshop

RUN bundle install
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
