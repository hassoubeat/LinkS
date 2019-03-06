# README
* 本システムの概要<br>
本システムはクラウド型のブックマーク管理アプリケーションです。
特定用途にまとめたリンクを気軽に共有できるようにすることを目的としています。

* Rubyバージョン<br>
2.5.3

* システム環境(動作確認環境)<br>
OS AmazonLinux<br>
ミドルウェア<br>
・実行環境 Nginx(1.15.6) + PhusionPassenger<br>
・データベース   MySQL(5.7.23)
フレームワーク<br>
・RubyOnRails(5.2.2)

* 設定<br>
1.環境変数の設定<br>
本システムが利用するデータベースの接続情報、メールサーバの情報はプロジェクト内の設定ファイルには記載せず、Nginxの環境変数にて定義しています。<br>
<br>
vim /path/to/nginx.conf (VH毎に設定ファイルを分ける場合は、適宜読み替えてください)
<br>
server内に以下の情報を定義してください。<br>
定義後、Nginxを再起動してください。

    ~~~
    # Turn on Passenger
    passenger_enabled on; (PhusionPassengerの利用有無)
    passenger_app_env development;　(Railsの環境 development,test,productionを適宜切り替える)

    # Environment variable
    passenger_env_var DB_USER 【MySQLのユーザ情報】;
    passenger_env_var DB_PASSWORD 【MySQLのユーザのパスワード】;
    passenger_env_var DB_IP_ADDRESS 【MySQLが配置されているサーバのIP】;
    passenger_env_var MAIL_ADDRESS 【アカウント登録時の確認メールを配信するメールアドレス】;
    passenger_env_var MAIL_PASSWORD 【メールアドレスのパスワード】;

* データベースの構築<br>
mkdir project_directory<br>
cd project_directory<br>
git clone https://github.com/hassoubeat/LinkS.git<br>
rails db:create<br>
rails db:migrate<br>

* データベースの初期データ投入<br>
特に必要なデータ投入はありません。
