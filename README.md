# masseater/claude-code-plugin

共有可能なカスタムコマンド集のプラグインです。

## プラグイン構成

```
claude-code-plugin/
├── .claude-plugin/
│   └── plugin.json          # プラグインのメタデータ
├── commands/                 # カスタムコマンド
│   └── hello.md             # サンプルコマンド
├── lefthook.yml             # Git hooks設定（セキュリティチェック）
├── marketplace.json         # ローカルテスト用マーケットプレイス設定
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

2. プラグインをインストール:
   ```bash
   /plugin install masseater/claude-code-plugins@my-local-marketplace
   ```

3. インストールされたコマンドを確認:
   ```bash
   /help
   ```

4. サンプルコマンドを実行:
   ```bash
   /hello
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

1. `commands/` ディレクトリに新しいマークダウンファイルを作成
2. ファイル名がコマンド名になります（例: `build.md` → `/build`）
3. ファイルのフォーマット:

```markdown
---
description: コマンドの説明
---

コマンドが実行する内容の詳細
```

## 他の人と共有する方法

1. このディレクトリをGitリポジトリとして公開
2. 共有先のユーザーに以下の手順を案内:
   - リポジトリをクローン
   - マーケットプレイスとして追加
   - プラグインをインストール

## plugin.json のカスタマイズ

`.claude-plugin/plugin.json` を編集して、プラグイン名、説明、作者名などを変更できます:

```json
{
  "name": "masseater/claude-code-plugin",
  "description": "プラグインの説明",
  "version": "0.0.1",
  "author": {
    "name": "masseater"
  }
}
```

## 参考資料

- [Claude Code プラグインドキュメント](https://docs.claude.com/ja/docs/claude-code/plugins)
