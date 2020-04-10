FROM ruby:2.6.3

ENV APP_ROOT /rails_sample_apps

WORKDIR ${APP_ROOT}
RUN apt-get update && \
    apt-get install -y mysql-client \
                       --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sL https://deb.nodesource.com/setup_13.x | bash && \
    apt-get install -y nodejs

COPY ./Gemfile ${APP_ROOT}
COPY ./Gemfile.lock ${APP_ROOT}

# gemインストールの高速化
#   gem: --nodocument, --global jobs 4
RUN echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    bundle config --global jobs 4 && \
    bundle install  --without=production

COPY . ${APP_ROOT}/

EXPOSE 3000

CMD ["puma", "-t", "5:5", "-p", "3000", "-e", "development", "-C", "config/puma.rb"]
