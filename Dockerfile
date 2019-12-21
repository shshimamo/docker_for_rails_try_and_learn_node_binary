FROM ruby:2.6.1-stretch

# アプリケーションを配置するディレクトリ
WORKDIR /app

# Bundlerでgemをインストールする
ARG BUNDLE_INSTALL_ARGS="-j 4"
COPY Gemfile Gemfile.lock ./
RUN bundle install ${BUNDLE_INSTALL_ARGS}

# インストールするNode.jsとYarnのバージョン
# NODE_SHA256SUMの値はhttps://nodejs.org/dist/${NODE_VERSION}/SHASUM256.txtを参照
# https://nodejs.org/dist/v10.15.3/
ENV \
  NODE_VERSION=v10.15.3 \
  NODE_DISTRO=linux-x64 \
  NODE_SHA256SUM=faddbe418064baf2226c2fcbd038c3ef4ae6f936eb952a1138c7ff8cfe862438 \
  YARN_VERSION=1.15.2

# YarnのインストールでNode.jsのバージョンをチェックしているので先にPATHを通しておく
ENV PATH=/opt/node-${NODE_VERSION}-${NODE_DISTRO}/bin:/opt/yarn-v${YARN_VERSION}/bin:${PATH}

# Node.jsとYarnをインストールする
RUN curl -sSfLO https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-${NODE_DISTRO}.tar.xz \
  && echo "${NODE_SHA256SUM} node-${NODE_VERSION}-${NODE_DISTRO}.tar.xz" | sha256sum -c -\
  && tar -xJ -f node-${NODE_VERSION}-${NODE_DISTRO}.tar.xz -C /opt \
  && rm -v node-${NODE_VERSION}-${NODE_DISTRO}.tar.xz \
  && curl -o - sSfL https://yarnpkg.com/install.sh | bash -s -- --version ${YARN_VERSION} \
  && mv /root/.yarn /opt/yarn-v${YARN_VERSION}

# エントリーポイントを設定する
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# アプリケーションのファイルをコピーする
COPY . ./

# サービスを実行するコマンドとポートを設定する
CMD ["rails", "server", "-b", "0.0.0.0"]
EXPOSE 3000
