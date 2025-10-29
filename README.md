# masseater/claude-code-plugin

共有可能なカスタムコマンド集のプラグインです。

## プラグイン構成

```
claude-code-plugin/
├── .claude-plugin/
│   └── plugin.json          # プラグインのメタデータ
├── commands/                 # カスタムコマンド
│   └── hello.md             # サンプルコマンド
├── marketplace.json         # ローカルテスト用マーケットプレイス設定
└── README.md                # このファイル
```

## ローカルでのテスト方法

1. マーケットプレイスを追加:
   ```bash
   /plugin marketplace add /Users/pc386/projects/my-claude-code-plugin
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
