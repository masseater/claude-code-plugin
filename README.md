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
├── mutils/
│   ├── plugin.json          # mutilsプラグインのメタデータ
│   └── commands/            # mutilsのコマンド
├── sdd/
│   ├── plugin.json          # sddプラグインのメタデータ
│   └── commands/            # sddのコマンド
└── README.md                # このファイル
```

## インストール方法

1. マーケットプレイスを追加（GitHubリポジトリのURLを指定）:
   ```bash
   /plugin marketplace add https://github.com/masseater/claude-code-plugin
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
   /sdd:help
   /sdd:steering         # 初回のみ: ステアリングドキュメント作成
   /sdd:init-task        # タスク初期化
   ```

## 共有方法

このリポジトリは複数のプラグインを含むマーケットプレイスとして機能します。

共有先のユーザーは、GitHubリポジトリのURLを直接指定してインストールできます:

```bash
# マーケットプレイスとして追加
/plugin marketplace add https://github.com/masseater/claude-code-plugin

# 必要なプラグインをインストール
/plugin install mutils
/plugin install sdd
```

## 参考資料

- [Claude Code プラグインドキュメント](https://docs.claude.com/ja/docs/claude-code/plugins)
