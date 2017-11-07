FROM ruby:2.2.0

RUN mkdir -p /var/www/pingapp

ADD . /var/www/pingapp

WORKDIR /var/www/pingapp

RUN bundle install --system --without test development

EXPOSE 4567

CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
