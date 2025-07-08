# FureAi - その時のあなたに寄り添う、ふれあい AI

メンタル管理 × カスタマイズ可能な AI チャット。その日の調子を記録しつつ、その時のあなたに寄り添う、AI チャットにより、いつでも気軽に相談できる場所を提供します。

## 🌟 サービス概要

FureAi は、24 時間いつでも気軽に相談できる AI チャット機能と、メンタル管理機能を組み合わせた Web アプリケーションです。

### 想定ユーザー

- 仕事で大変な時に、気軽に相談しづらい会社員
- 孤独を感じる人
- 自分の気持ちを外に吐き出したい人
- イライラやモヤモヤを感じやすい人
- 自分のメンタルを管理したい人

### 解決する課題

- 仕事で大変な時に、気軽に相談しづらい。また、24 時間いつでも相談しづらい
- ChatGPT だと無機質な UI や返答で、人間のような温かみがない
- 一般に出ている相談アプリだと高い
- 自分の気分の変化を直感的に記録したい
- 記録を習慣化するための仕組みがほしい

## ✨ 主な機能

### 🤖 AI チャット機能

- **カスタマイズ可能な AI キャラクター**: 相談者の性格や求めることに応じて返答をコントロール
- **複数チャット**: チャットの新規作成で相談相手を分ける機能
- **リアルタイム応答**: Turbo Streams による自然な会話体験
- **背景カスタマイズ**: チャット画面の背景画像を設定可能

### 📊 メンタル管理機能

- **日別記録**: 気持ちと体調を簡単に選択して記録
- **グラフ表示**: 記録をグラフで見返して変化を可視化
- **継続サポート**: リマインド・継続で経験値のような続く仕組み

### 👤 ユーザー機能

- **Google ログイン**: 簡単な認証で初回利用のハードルを下げる
- **プロフィール設定**: 自分の推しやリラックス方法を設定
- **画像管理**: アバター画像と背景画像のアップロード機能

## 🛠 技術スタック

### フロントエンド

- **Rails 7.2.2** (Hotwire: Turbo / Stimulus)
- **JavaScript** (esbuild)
- **Tailwind CSS** + **daisyUI**
- **Material Symbols** (アイコン)

### バックエンド

- **Ruby 3.2.8** (Rails)
- **PostgreSQL** (データベース)
- **Redis** (キャッシュ・セッション)

### 認証・API

- **Devise** + **OmniAuth** (Google ログイン対応)
- **OpenAI API** (GPT-4o-mini)

### インフラ・環境構築

- **Docker** (開発環境)
- **Render.com** (本番環境)
- **Amazon S3** (画像ストレージ)

### 非同期処理・UI 強化

- **Sidekiq** + **Active Job** (非同期処理)
- **ActiveStorage** (画像管理)
- **Chartkick** (グラフ表示)

## 🚀 セットアップ

### 前提条件

- Docker
- Docker Compose

### 開発環境の起動

```bash
# リポジトリをクローン
git clone <repository-url>
cd fureai

# Docker環境で起動
docker-compose up -d

# データベースのセットアップ
docker-compose exec web rails db:create
docker-compose exec web rails db:migrate
docker-compose exec web rails db:seed

# アプリケーションにアクセス
open http://localhost:3000
```

### 環境変数の設定

`.env`ファイルを作成し、以下の環境変数を設定してください：

```env
# OpenAI API
OPENAI_API_KEY=your_openai_api_key
OPENAI_SYSTEM_PROMPT=あなたは親切で丁寧なアシスタントです。

# Google OAuth
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret

# AWS S3 (本番環境)
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=ap-northeast-1
AWS_BUCKET=your_s3_bucket_name

# Redis
REDIS_URL=redis://redis:6379/0
```

## 📁 プロジェクト構造

```
fureai/
├── app/
│   ├── controllers/          # コントローラー
│   ├── models/              # モデル
│   ├── views/               # ビュー
│   ├── jobs/                # 非同期ジョブ
│   └── javascript/          # JavaScript
├── config/                  # 設定ファイル
├── db/                      # データベース関連
├── compose.yml              # Docker Compose設定
└── Dockerfile.dev           # 開発用Dockerfile
```

## 🔧 主要な技術的工夫

### 1. 非同期チャット処理

- Sidekiq を使用した AI 応答の非同期処理
- Turbo Streams によるリアルタイム更新
- ストリーミング応答による自然な会話体験

### 2. AI キャラクターのカスタマイズ

- ユーザーごとの性格設定
- プロンプトの動的生成
- アバター画像の管理

### 3. メンタル記録の可視化

- 日別の記録機能
- Chartkick によるグラフ表示
- 継続的なメンタル管理のサポート

### 4. 画像アップロード機能

- ActiveStorage を使用した画像管理
- アバター画像と背景画像の設定
- S3 との連携

## 🎨 UX/UI の特徴

### 温かみのあるデザイン

- メンタルケアサービスとして「温かみ」と「安心感」を重視
- シンプルな構造で操作の迷いを最小化
- 統一感のあるデザインシステム

### ストレスフリーな操作

- Turbo によるページ遷移の削減
- 最小手順での設定変更
- 直感的なナビゲーション

## 🔮 今後の展望

- **リマインダー機能**: メンタル記録の習慣化支援
- **3 行日記機能**: より気軽な記録方法
- **AI キャラクター共有**: ユーザー間でのキャラクター共有
- **メンタル記録分析**: より詳細な自己理解のサポート

## 📝 ライセンス

© 2024 FureAi. All rights reserved.

## 🤝 フィードバック

実際に使用していただいたユーザーからの感想：

- 「気分に応じて相談相手を変えられるのが良い」
- 「メンタル記録で自分の変化が分かる」
- 「もう少し応答の文言を人間っぽくしてほしい」

改善提案やフィードバックは大歓迎です！
