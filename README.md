# docker_for_rails_try_and_learn_node_binary
 Get node.js and yarn by binary archive

Node.jsもYarnもtarballからインストールできる。

https://github.com/nodejs/help/wiki/installation
https://yarnpkg.com/ja/docs/install#alternatives-stable

Node.jsのインストールではファイルのSHA256ハッシュを計算して検証している
Yarnのインストールはインストールスクリプトを使用している

(インストールの確認)
まずはビルドする
```
$ docker-compose build
```
コンテナ内で`node`と`yarn`のバージョンを確認する
```
$ docker-compose run --rm app bash
```
```
# node --version
# yarn --version
```
