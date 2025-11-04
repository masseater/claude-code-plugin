---
description: プロジェクト全体のステアリングドキュメントを作成・更新
---

# プロジェクト全体のステアリングドキュメント管理

このコマンドは、プロジェクト全体の永続的なコンテキスト（プロダクト方針、技術スタック、プロジェクト構造）をステアリングドキュメントとして管理します。

**重要**: 全ての `/sdd:*` コマンドは自動的にステアリングドキュメントを読み込み、プロジェクトの一貫性を保ちます。

## 実行手順

### 1. モード判定

`specs/_steering/` ディレクトリの状態を確認：

- **Bootstrap Mode（初期作成）**: ディレクトリが存在しないか、コアファイルが不足
- **Sync Mode（更新）**: 全てのコアファイルが存在

**コアファイル**:
- `product.md` - プロダクト方針、ターゲットユーザー、ビジネス目標
- `tech.md` - 技術スタック、アーキテクチャパターン、開発標準
- `structure.md` - プロジェクト構造、命名規則、コード組織原則

### 2. Bootstrap Mode（初期作成）

#### 2.1 既存プロジェクト情報の収集

以下の情報を収集してステアリングドキュメント生成に活用：

**プロダクト情報**:
- `README.md` の存在確認と内容読み取り
- パッケージマニフェスト（`package.json`, `pyproject.toml`, `Cargo.toml` など）からプロジェクト名と説明を抽出

**技術スタック情報**:
- `package.json` - Node.js依存関係、スクリプト、エンジンバージョン
- `tsconfig.json` / `jsconfig.json` - TypeScript/JavaScript設定
- `pyproject.toml` / `requirements.txt` - Python依存関係
- `Cargo.toml` - Rust依存関係
- `go.mod` - Go依存関係
- `.ruby-version` / `Gemfile` - Ruby依存関係
- ビルドツール設定（`vite.config.ts`, `webpack.config.js`, `next.config.js` など）
- データベース関連（`prisma/schema.prisma`, ORM設定など）

**プロジェクト構造情報**:
- ルートディレクトリの構造（`ls -la`）
- 主要ディレクトリ（`src/`, `lib/`, `app/`, `tests/` など）の存在確認
- ファイル命名パターンの分析（kebab-case, camelCase, snake_case）

**注意**: ファイルが見つからない場合はスキップし、テンプレート構造で生成

#### 2.2 ディレクトリ作成

```bash
mkdir -p specs/_steering
```

#### 2.3 ステアリングドキュメント生成

以下の3つのファイルを生成（収集した情報を反映）：

##### `specs/_steering/product.md`

```markdown
# Product Overview

## Product Purpose

[プロジェクトの目的]
- README.mdやpackage.jsonの説明から抽出
- 存在しない場合はプレースホルダー

**Vision (North Star)**:
[プロダクトのビジョン]

**解決する問題**:
- [課題1]
- [課題2]

## Target Users

**Primary Archetype**: [主要ユーザー像]
- [特徴1]
- [特徴2]

**ニーズと課題**:
- **ニーズ**: [ニーズ]
- **課題**: [課題]

## Key Features

このプロジェクトが提供する主要機能：

1. **[機能カテゴリ1]**: [説明]
2. **[機能カテゴリ2]**: [説明]

## Business Objectives

- **[目標1]**: [説明]
- **[目標2]**: [説明]

## Success Metrics

**Quantitative Metrics**:
- **[指標名]**: [測定方法]

**Qualitative Metrics**:
- **[指標名]**: [評価基準]

## Product Principles

1. **[原則1]**: [説明]
2. **[原則2]**: [説明]

## Non-Goals / Guardrails

このプロジェクトは以下の領域には**意図的に関与しない**：

- **[非対象1]**: [理由]
- **[非対象2]**: [理由]
```

##### `specs/_steering/tech.md`

```markdown
# Technology Stack

## Architecture

[システムアーキテクチャの概要]
- 既存プロジェクト構造から推測
- モノリス/マイクロサービス/JAMstack など

## Core Technologies

### Primary Language(s)
- **Language**: [検出された言語]
- **Runtime**: [検出されたランタイム]
- **Framework**: [検出されたフレームワーク]

### Key Dependencies/Libraries

[package.jsonなどから抽出した主要ライブラリ]

## Development Standards

### Type Safety
[型安全性に関する方針]
- TypeScript strict mode の使用状況
- 型定義の要求レベル

### Code Quality
[コード品質ツール]
- ESLint, Prettier, Ruff などの設定状況

### Testing
[テスト戦略]
- テストフレームワーク（Jest, pytest など）
- カバレッジ要求

## Development Environment

### Required Tools
[必要なツールとバージョン]
- Node.js, Python, Rust などのバージョン要求
- package.jsonのenginesフィールドから抽出

### Common Commands
```bash
# Dev: [開発サーバー起動コマンド]
# Build: [ビルドコマンド]
# Test: [テストコマンド]
```

## Key Technical Decisions

[重要な技術的決定とその理由]

1. **[決定事項1]**:
   - **理由**: [理由]
   - **代替案**: [検討した代替案]
   - **トレードオフ**: [トレードオフ]
```

##### `specs/_steering/structure.md`

```markdown
# Project Structure

## Directory Organization

```
[プロジェクト名]/
├── [検出されたディレクトリ構造]
├── specs/
│   └── _steering/          # ステアリングドキュメント
└── ...
```

**組織化の原則**:
- **[原則1]**: [説明]
- **[原則2]**: [説明]

## Naming Conventions

### ファイル名
- **[パターン1]**: [説明]（例: kebab-case.ts）
- **[パターン2]**: [説明]（例: PascalCase.tsx）

### ディレクトリ名
- **[パターン]**: [説明]

## Code Organization Principles

1. **単一責任**: [プロジェクト固有の適用方法]
2. **モジュール性**: [モジュール分割の基準]
3. **再利用性**: [共通コンポーネントの配置]

## Module Boundaries

[モジュール間の境界定義]

## File Size Guidelines

- **推奨サイズ**: [行数]
- **最大サイズ**: [行数]

## Documentation Standards

### プロジェクトレベル
- **README.md**: [役割]
- **[その他ドキュメント]**: [役割]

### コードレベル
- **コメント**: [コメント規約]
- **型定義**: [型定義の要求]
```

#### 2.4 完了報告

```markdown
✅ ステアリングドキュメントを作成しました
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 作成先: specs/_steering/

📝 作成されたファイル:
   - product.md (プロダクト方針)
   - tech.md (技術スタック)
   - structure.md (プロジェクト構造)

💡 次のアクション:
   1. 各ドキュメントの内容を確認・編集してください
   2. プロジェクト固有の情報を追加してください
   3. `/sdd:init-task` でタスクを作成できます

⚠️ 重要:
   - 全ての /sdd:* コマンドは自動的にこれらのドキュメントを読み込みます
   - ステアリングドキュメントはプロジェクトの「永続的メモリ」として機能します
   - プロジェクトの方針や技術スタックが変更された場合は、このコマンドを再実行してください
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3. Sync Mode（更新）

既存のステアリングドキュメントを最新の状態に更新：

#### 3.1 既存ドキュメントの読み込み

- `specs/_steering/product.md`
- `specs/_steering/tech.md`
- `specs/_steering/structure.md`

#### 3.2 プロジェクトの変更検出

以下の変更を検出：

**技術スタック変更**:
- 新しい依存関係の追加
- 既存依存関係のバージョン更新
- フレームワークの変更

**プロジェクト構造変更**:
- 新しいディレクトリの追加
- ファイル命名パターンの変化
- モジュール構成の変更

#### 3.3 更新の提案

変更が検出された場合、AskUserQuestionツールで確認：

```
以下の変更が検出されました。ステアリングドキュメントを更新しますか？

変更内容:
1. tech.md: 新しい依存関係 "react-query" が追加されました
2. structure.md: 新しいディレクトリ "hooks/" が検出されました

選択肢:
- はい（推奨）: ステアリングドキュメントを更新
- いいえ: 現状を維持
- 個別に確認: 各変更を個別に確認
```

#### 3.4 ドキュメント更新

ユーザーの承認に基づいて該当ドキュメントを更新

#### 3.5 完了報告

```markdown
✅ ステアリングドキュメントを更新しました
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 更新先: specs/_steering/

📝 更新されたファイル:
   - tech.md (依存関係を更新)
   - structure.md (ディレクトリ構造を更新)

🔍 検出された変更:
   - 新しい依存関係: react-query, zustand
   - 新しいディレクトリ: hooks/, contexts/

💡 次のアクション:
   - 更新内容を確認してください
   - 必要に応じて手動で調整してください
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 注意事項

- **⚠️ 重要**: ステアリングドキュメントはプロジェクト全体の「唯一の真実の源」として機能します
- **⚠️ 重要**: 全ての `/sdd:*` コマンドは自動的にステアリングドキュメントを読み込みます
- 既存プロジェクトの場合、Bootstrap Modeで自動検出された内容を必ず確認・調整してください
- プロジェクトの方針や技術スタックが大きく変わった場合は、このコマンドを再実行してください
- ステアリングドキュメントは抽象的なレベルを保ち、具体的なコマンド名やファイル名は列挙しないでください

## 矛盾チェック（必須）

ステアリングドキュメント作成後、3つのドキュメント間の矛盾がないか必ず contradiction-checker SubAgent を使用して確認してください：

```bash
# contradiction-checker SubAgentを使用（指摘のみ、修正は行わない）
Task(contradiction-checker): specs/_steering/ の全ドキュメント間の矛盾をチェックしてください。product.md、tech.md、structure.mdの整合性を確認してください。
```
