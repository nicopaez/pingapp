FROM ruby:2.2.0

LABEL maintainer nicopaez

RUN mkdir -p /apps/pingapp

ADD . /apps/pingapp

WORKDIR /apps/pingapp

RUN bundle install

RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser && \
    chown -R appuser /apps

USER appuser

EXPOSE 4567

CMD ["ruby", "app.rb", "-o", "0.0.0.0"]