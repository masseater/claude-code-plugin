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
├── .claude/
│   └── commands/            # プロジェクト固有のコマンド
├── .claude-plugin/
│   └── marketplace.json     # ローカルテスト用マーケットプレイス設定
├── mutils/
│   ├── plugin.json          # mutilsプラグインのメタデータ
│   └── commands/            # mutilsのコマンド
├── sdd/
│   ├── plugin.json          # sddプラグインのメタデータ
│   └── commands/            # sddのコマンド
├── lefthook.yml             # Git hooks設定（セキュリティチェック）
├── CLAUDE.md                # Claude Codeへの指示
└── README.md                # このファイル
```

## 初回セットアップ

1. Lefthookのインストール（未インストールの場合）:
   ```bash
   brew install lefthook
   ```

2. Git hooksのセットアップ:
   ```bash
   lefthook install
   ```

## ローカルでのテスト方法

1. マーケットプレイスを追加（プラグインディレクトリの絶対パスを指定）:
   ```bash
   /plugin marketplace add /path/to/claude-code-plugin
   ```

2. プラグインをインストール（どちらか、または両方）:
   ```bash
   # mutilsプラグインをインストール
   /plugin install mutils

   # sddプラグインをインストール
   /plugin install sdd
   ```

3. インストールされたコマンドを確認:
   ```bash
   /help
   ```

4. コマンドを実行:
   ```bash
   # mutilsのコマンド例
   /issue-plan

   # sddのコマンド例
   /sdd help
   /sdd create-specs
   ```

## Git Hooks（セキュリティチェック）

このリポジトリはlefthookを使用してpre-commitフックを管理しています。コミット前に自動的にClaude Codeを使ってセキュリティリスクをチェックします。

### チェック項目
- APIキー、パスワード、トークンなどの機密情報のハードコード
- 危険な関数やコマンドの使用（eval, execなど）
- SQLインジェクション、XSSなどの脆弱性
- 企業の機密情報や非公開の技術情報

### 実際の使い方

通常通りコミットするだけで自動的にチェックが実行されます:

```bash
git add .
git commit -m "コミットメッセージ"
```

**問題がない場合:**
```
🔍 セキュリティチェックを実行中...
✅ セキュリティチェック完了。問題ありません。
```

**問題が検出された場合:**
```
🔍 セキュリティチェックを実行中...
❌ セキュリティリスクが検出されました:
SECURITY_RISK: APIキーがハードコードされています
コミットを中止しました。問題を修正してから再度コミットしてください。
```

セキュリティチェックをスキップする場合（自己責任で）:
```bash
git commit --no-verify -m "コミットメッセージ"
```

## 新しいコマンドの追加方法

既存のプラグインにコマンドを追加する場合:

1. 対象のプラグインの `commands/` ディレクトリに新しいマークダウンファイルを作成
   - mutilsの場合: `mutils/commands/`
   - sddの場合: `sdd/commands/`
2. ファイル名がコマンド名になります（例: `build.md` → `/build`）
3. ファイルのフォーマット:

```markdown
---
description: コマンドの説明
---

コマンドが実行する内容の詳細
```

新しいプラグインを追加する場合:

1. 新しいディレクトリを作成（例: `my-plugin/`）
2. `plugin.json` を作成してメタデータを定義
3. `commands/` ディレクトリを作成してコマンドを追加

## 他の人と共有する方法

このリポジトリは複数のプラグインを含むマーケットプレイスとして機能します。

1. このディレクトリをGitリポジトリとして公開
2. 共有先のユーザーに以下の手順を案内:
   ```bash
   # リポジトリをクローン
   git clone <repository-url>

   # マーケットプレイスとして追加
   /plugin marketplace add /path/to/claude-code-plugin

   # 必要なプラグインをインストール
   /plugin install mutils
   /plugin install sdd
   ```

## plugin.json のカスタマイズ

各プラグインの `plugin.json` を編集して、プラグイン名、説明、バージョンなどを変更できます:

```json
{
  "name": "plugin-name",
  "description": "プラグインの説明",
  "version": "0.1.0",
  "author": {
    "name": "author-name"
  }
}
```

例:
- `mutils/plugin.json` - mutilsプラグインのメタデータ
- `sdd/plugin.json` - sddプラグインのメタデータ

## 参考資料

- [Claude Code プラグインドキュメント](https://docs.claude.com/ja/docs/claude-code/plugins)
