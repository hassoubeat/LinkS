# LinkS README
## 本システムの概要
本システムはRubyOnRails製のブックマーク共有WEBアプリです。  
特定用途にまとめたリンクを気軽に共有できるようにすることを目的としています。

## Rubyバージョン
**2.5.5**

## システム環境(動作確認環境)
- **OS** `AmazonLinux`
- **実行環境** `Puma` (**3.12.0**)
- **データベース** `MySQL` (**5.7.23**)
- **インメモリデータストア** `Redis` (**5.0.5**)
- **フレームワーク** `RubyOnRails` (**5.2.2**)

## 設定
### 1. 事前準備
本アプリは**Docker**を利用して構築しています。  
事前に導入を行っておいてください。

### 2. dockerコンテナの起動
本プロジェクトの`docker`ディレクトリで以下コマンドを実行  
**※ 以後指定がない限り`docker`ディレクトリ内での操作**

```bash
docker-compose up -d
```

アプリを実行するのに必要な3つのコンテナが起動します。  

- **app**   ... アプリ本体を実行するコンテナ
- **db**    ... MySQLを実行するコンテナ
- **redis** ... Redisを実行するコンテナ

### 3. 初回セットアップ
まだこの段階では必要なセットアップが行われていないため、アプリは利用できません。  
正常にアプリを実行するのには、以下のセットアップが必要になります。

```bash
# appコンテナに接続
docker exec -it app sh

# 実行に必要なGemのインストール
bundle install

# データベース作成
bundle exec rails db:create

# データベースのテーブル作成
bundle exec rails db:migrate

# 接続終了
exit
```

### 4. 環境変数の設定
`docker`フォルダ内の`docker-compose.yml`に環境変数を定義します。  

```bash
environment:
  DB_USER:
  DB_PASSWORD:
  DB_HOST:
  REDIS_URL:
  APP_MAIL_ADDRESS:
  APP_MAIL_PASSWORD:
  HOST_URL:
```
基本デフォルトで動作しますが、ユーザ登録時の確認メールの送信元アドレスとして`APP_MAIL_ADDRESS`と`APP_MAIL_PASSWORD`は設定しないと、ユーザ登録が行えないため、自身の利用している適当なアドレスとそのパスワードを設定してください。  

`TODO`  
現在はGmail以外は利用できない設定になっている。  
ドメインに応じて設定を動的に変更するように改修予定。

### 5. コンテナの再起動
```bash
# コンテナ群の停止・削除
docker-compose down

# コンテナ群の生成・起動
docker-compose up -d
```

`localhost:3000`にアクセスすることでアプリが動作します。  
※ 実行環境の性能によって、アプリが起動するまで1分ほどかかることもあります  
  `docker-compose logs -f`コマンドで状況を確認することが可能です。