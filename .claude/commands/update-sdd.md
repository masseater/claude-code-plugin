---
description: SDDのヘルプとREADMEを最新の状態に更新
---

# SDDドキュメントの更新

`sdd/README.md` と `sdd/commands/help.md` を最新の状態に更新します。
SDDコマンドの追加・削除・変更があった場合にこのコマンドを実行してください。

**更新の流れ**:
1. SDDコマンドを収集・分類
2. `sdd/README.md` を生成（メインドキュメント）
3. `sdd/commands/help.md` を生成（README.mdベースの詳細版）

## 実行内容

### 1. 既存のSDDコマンドを収集

`sdd/commands/` ディレクトリ配下のすべてのコマンドファイルをスキャン：
- `*.md` ファイルをすべて取得
- `verify/` サブディレクトリも含める

各コマンドファイルから以下の情報を抽出：
- コマンド名（ファイル名から）
- description（フロントマターから）
- argument-hint（フロントマターから）
- コマンドの説明（ファイル内容の最初の見出しとその説明）

### 2. コマンドの分類

SDDワークフローに沿ってコマンドを分類：

#### Phase 1: 仕様作成
- `create-specs`

#### Phase 2: 仕様の検証・明確化
- `clarify-spec`
- `contradiction-check`
- `validate-feasibility`

#### Phase 3: Phase分割計画
- `break-down-phase`

#### Phase 4: Phase実装
- `implement-phase`
- `sync-specs`

#### Phase 5: Phase検証
- `verify-phase`
- `verify/docs`
- `verify/requirements`
- `verify/quality`

#### その他・ヘルプ
- `help`
- `next-step`

### 3. help.mdの構造

以下の構造で `sdd/commands/help.md` を生成：

```markdown
---
description: SDDワークフローの全体像とコマンド一覧を表示
---

# SDDワークフローガイド

SDDは**Specification-Driven Development（仕様駆動開発）**の略で、明確な仕様書に基づいて段階的に実装を進める開発手法です。

## 基本ワークフロー

[フロー図]

## コマンド一覧と使用順序

### 📝 Phase 1: 仕様作成
[各コマンドの詳細]

### 🔍 Phase 2: 仕様の検証・明確化
[各コマンドの詳細]

### 📋 Phase 3: Phase分割計画
[各コマンドの詳細]

### 💻 Phase 4: Phase実装
[各コマンドの詳細]

### ✅ Phase 5: Phase検証
[各コマンドの詳細]

## 📊 ディレクトリ構造

## 🎯 次に実行すべきコマンドを知りたい場合

## 💡 よくある使い方

## 🔄 TDDサイクル

## 📌 重要な原則

## 🆘 困った時は
```

### 4. 各コマンドの詳細フォーマット

各コマンドは以下の形式で記載：

```markdown
#### `/sdd:{command-name} {argument-hint}`
{description}

**生成されるファイル**: （該当する場合）
- ファイルリスト

**実行内容**: （該当する場合）
- 実行内容の説明

**引数**: （該当する場合）
- 引数の説明

**次のステップ**: 次に実行すべきコマンド
```

### 5. 動的に更新される情報

以下の情報は自動的に更新：
- コマンド数
- 各Phaseで利用可能なコマンドリスト
- 引数の形式
- コマンドの説明

### 6. 固定される情報

以下の情報は固定（更新時も保持）：
- 基本ワークフローの図
- SDDの基本概念の説明
- TDDサイクルの説明
- 重要な原則
- よくある使い方のサンプル

### 7. 更新の実行

1. すべてのコマンドファイルをスキャン
2. 情報を抽出して分類
3. 新しい `help.md` の内容を生成
4. ユーザーに更新内容のプレビューを表示：

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 sdd:help 更新プレビュー
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 検出されたコマンド

### Phase 1: 仕様作成
- create-specs

### Phase 2: 仕様の検証・明確化
- clarify-spec
- contradiction-check
- validate-feasibility

### Phase 3: Phase分割計画
- break-down-phase

### Phase 4: Phase実装
- implement-phase
- sync-specs

### Phase 5: Phase検証
- verify-phase
- verify:docs
- verify:requirements
- verify:quality

### その他・ヘルプ
- help
- next-step

合計: {N} コマンド

## 更新される内容

[変更された箇所のdiff]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

5. `sdd/README.md` を更新

### 8. sdd/commands/help.mdの更新

`sdd/README.md` の内容を元に `sdd/commands/help.md` を生成：

**help.mdの特徴**:
- README.mdをベースにした内容
- コマンド実行時に読みやすい形式
- より詳細な使用例を含める
- 各コマンドの引数と説明を詳細に記載

**README.mdの構造**:
```markdown
# SDD (Specification-Driven Development)

SDDは**Specification-Driven Development（仕様駆動開発）**の略で、明確な仕様書に基づいて段階的に実装を進める開発手法です。

## 📚 概要

[SDDの基本概念]

## 🔄 基本ワークフロー

[フロー図とステップ説明]

## 📋 コマンド一覧

### Phase 1: 仕様作成
- `/sdd:create-specs` - {description}

### Phase 2: 仕様の検証・明確化
- `/sdd:clarify-spec` - {description}
- `/sdd:contradiction-check` - {description}
- `/sdd:validate-feasibility` - {description}

### Phase 3: Phase分割計画
- `/sdd:break-down-phase` - {description}

### Phase 4: Phase実装
- `/sdd:implement-phase` - {description}
- `/sdd:sync-specs` - {description}

### Phase 5: Phase検証
- `/sdd:verify-phase` - {description}

### ヘルプ
- `/sdd:help` - ワークフローの詳細を確認
- `/sdd:next-step` - 次のステップを提案

## 🚀 クイックスタート

[よくある使い方]

## 📊 ディレクトリ構造

[specsディレクトリの構造]

## 💡 TDDサイクル

[TDDの説明]

## 🎯 開発の原則

[SOLID原則など]

## 🔗 関連リンク

- [詳細なヘルプ](/sdd:help)
- [次のステップを確認](/sdd:next-step)
```

### 9. 完了報告

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ sdd:help と README 更新完了
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 更新されたファイル
- sdd/commands/help.md
- sdd/README.md

## 検出されたコマンド数
合計: {N} コマンド

## 次のアクション
- `/sdd:help` で更新内容を確認
- `sdd/README.md` でドキュメントを確認

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 注意事項

- **⚠️ 重要**: このコマンドは `sdd/commands/help.md` と `sdd/README.md` を完全に上書きします
- **⚠️ 重要**: 各コマンドファイルのフロントマター（description、argument-hint）が正しく設定されている必要があります
- 新しいコマンドを追加した場合、適切なPhaseに分類されます
- コマンドの分類が不適切な場合、生成されたファイルを直接編集するか、このコマンドのロジックを修正してください

## 使用タイミング

以下の場合にこのコマンドを実行：
- 新しいSDDコマンドを追加した時
- 既存のコマンドの説明や引数を変更した時
- コマンドを削除した時
- ワークフローの構造を変更した時
- SDDのREADMEを更新したい時
