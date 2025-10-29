# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

これはClaude Codeのプラグインリポジトリです。共有可能なカスタムコマンド、エージェント、スキル、フックを提供します。

## プラグイン構造

- `.claude-plugin/plugin.json` - プラグインのメタデータ（名前、説明、バージョン、作者情報）
- `commands/` - カスタムコマンドのマークダウンファイル。ファイル名がコマンド名になる（例: `hello.md` → `/hello`）
- `marketplace.json` - ローカルテスト用のマーケットプレイス設定
- `lefthook.yml` - Git hooksの設定（セキュリティチェック用のpre-commitフック）

## 初回セットアップ

1. Lefthookのインストール（未インストールの場合）:
   ```bash
   brew install lefthook
   ```

2. Git hooksのセットアップ:
   ```bash
   lefthook install
   ```

## ローカルテスト手順

1. マーケットプレイスを追加:
   ```
   /plugin marketplace add /Users/pc386/projects/my-claude-code-plugin
   ```

2. プラグインをインストール:
   ```
   /plugin install masseater/claude-code-plugins@my-local-marketplace
   ```

3. コマンドを確認: `/help`

## Git Hooks（セキュリティチェック）

このリポジトリはlefthookを使用してpre-commitフックを管理しています。コミット前に自動的にClaude Codeを使ってセキュリティリスクをチェックします。

チェック項目:
- APIキー、パスワード、トークンなどの機密情報
- 危険な関数やコマンドの使用
- SQLインジェクション、XSSなどの脆弱性
- 企業の機密情報

セキュリティチェックをスキップする場合:
```bash
git commit --no-verify
```

## コマンドファイルのフォーマット

各コマンドは`commands/`ディレクトリ内のマークダウンファイルで定義します:

```markdown
---
description: コマンドの説明
---

コマンドが実行する内容の詳細
```

## 重要事項

- **企業の機密事項を含めないこと**: プラグイン内のコマンド、説明、コード例などに機密情報（APIキー、社内システムの詳細、非公開の技術情報など）を記載しないでください。このプラグインは共有可能なものとして設計されています。
