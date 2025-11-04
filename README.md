# masseater/claude-code-plugin

Claude Code用のプラグインリポジトリです。複数の共有可能なプラグインを含みます。

## 含まれるプラグイン

### 1. mutils - 汎用ユーティリティコマンド集
開発ワークフローを効率化する汎用的なコマンド集です。

詳細: [mutils/README.md](./mutils/README.md)

### 2. sdd - Spec Driven Development ワークフロー支援
仕様駆動開発（SDD）のワークフローを支援するコマンド集です。

詳細: [sdd/README.md](./sdd/README.md)

## プロジェクト構成

```
claude-code-plugin/
├── .claude/                 # Claude Codeのローカル設定
├── .claude-plugin/
│   └── marketplace.json     # マーケットプレイス設定
├── mutils/
│   ├── plugin.json          # mutilsプラグインのメタデータ
│   ├── README.md            # mutilsの詳細ドキュメント
│   └── commands/            # mutilsのコマンド
├── sdd/
│   ├── plugin.json          # sddプラグインのメタデータ
│   ├── README.md            # sddの詳細ドキュメント
│   ├── agents/              # sddで使用するSubAgent定義
│   └── commands/            # sddのコマンド
├── CLAUDE.md                # Claude Code向けのプロジェクト説明
├── README.md                # このファイル
├── lefthook.yml             # Git hooksの設定（セキュリティチェック）
└── link-commands.sh         # ローカル開発用のコマンドリンクスクリプト
```

## インストール方法

### 1. マーケットプレイスを追加

GitHubリポジトリのURLを指定してマーケットプレイスを追加します：

```bash
/plugin marketplace add https://github.com/masseater/claude-code-plugin
```

### 2. プラグインをインストール

必要なプラグイン（どちらか、または両方）をインストールします：

```bash
# mutilsプラグインをインストール
/plugin install mutils

# sddプラグインをインストール
/plugin install sdd
```

### 3. インストールされたコマンドを確認

```bash
/help
```

### 4. コマンドを実行

```bash
# mutilsのコマンド例
/issue-plan <issue番号またはURL>
/organize-commits
/self-review

# sddのコマンド例
/sdd:help
/sdd:steering         # 初回のみ: ステアリングドキュメント作成
/sdd:init-task <計画の説明>
```

## ローカル開発・テスト

このリポジトリをローカルでテストする場合：

### 方法1: link-commands.shを使用（推奨）

```bash
# スクリプトを実行してコマンドをリンク
./link-commands.sh

# Claude Codeを再起動して変更を反映
```

このスクリプトは、各プラグインのコマンドを`.claude/commands/`にシンボリックリンクします。

### 方法2: ローカルマーケットプレイスとして追加

```bash
# ローカルパスを指定してマーケットプレイスを追加
/plugin marketplace add /path/to/claude-code-plugin

# プラグインをインストール
/plugin install mutils
/plugin install sdd
```

## Git Hooks（セキュリティチェック）

このリポジトリはlefthookを使用してpre-commitフックを管理しています。

### セットアップ

```bash
# Lefthookをインストール（未インストールの場合）
brew install lefthook

# Git hooksをセットアップ
lefthook install
```

### チェック項目

コミット前に自動的に以下をチェックします：
- APIキー、パスワード、トークンなどの機密情報
- 危険な関数やコマンドの使用
- SQLインジェクション、XSSなどの脆弱性
- 企業の機密情報

チェックをスキップする場合：
```bash
git commit --no-verify
```

## 共有方法

このリポジトリは複数のプラグインを含むマーケットプレイスとして機能します。

他のユーザーは、GitHubリポジトリのURLを直接指定してインストールできます：

```bash
# マーケットプレイスとして追加
/plugin marketplace add https://github.com/masseater/claude-code-plugin

# 必要なプラグインをインストール
/plugin install mutils
/plugin install sdd
```

## 参考資料

- [Claude Code プラグインドキュメント](https://docs.claude.com/ja/docs/claude-code/plugins)
