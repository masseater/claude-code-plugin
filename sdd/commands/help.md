---
description: SDDワークフローの全体像とコマンド一覧を表示
---

# SDDワークフローガイド

SDDは**Specification-Driven Development（仕様駆動開発）**の略で、明確な仕様書に基づいて段階的に実装を進める開発手法です。

## 基本ワークフロー

```
0. ステアリングドキュメント作成（初回のみ）
   ↓
1. タスク初期化
   ↓
2. 要件・技術詳細の定義
   ↓
3. 調査・検証
   ↓
4. Phase構成の決定
   ↓
5. Phase詳細計画
   ↓
6. Phase実装
   ↓
7. Phase検証
   ↓
8. 次Phaseへ（5に戻る）
```

## コマンド一覧と使用順序

### 🎯 Phase 0: ステアリングドキュメント作成（初回のみ）

#### `/sdd:steering`
プロジェクト全体の永続的なコンテキストを管理します。

**生成されるファイル**:
- `specs/_steering/product.md` - プロダクト方針、ターゲットユーザー、ビジネス目標
- `specs/_steering/tech.md` - 技術スタック、アーキテクチャ、開発標準
- `specs/_steering/structure.md` - プロジェクト構造、命名規則、コード組織原則

**実行モード**:
- **Bootstrap Mode（初期作成）**: 既存プロジェクトから情報を抽出して自動生成
- **Sync Mode（更新）**: プロジェクトの変更を検出して更新提案

**重要**: 全ての `/sdd:*` コマンドは自動的にステアリングドキュメントを読み込みます

**次のステップ**: タスク初期化へ

---

### 📝 Phase 1: タスク初期化

#### `/sdd:init-task <計画の説明>`
新しいタスクのスケルトンを作成します（Phase構成はまだ作成しません）。

**生成されるファイル**:
- `specs/{taskname}/overview.md` - プロジェクト概要（Phase構成なし）
- `specs/{taskname}/research.md` - 調査項目リスト

**重要**: Phase構成は調査完了後に `/sdd:plan-phases` で作成します

**次のステップ**: 要件・技術詳細の定義へ

---

### 📋 Phase 2: 要件・技術詳細の定義

#### `/sdd:define-requirements <taskname>`
機能要件と非機能要件を定義します。

**生成されるファイル**:
- `specs/{taskname}/specification.md` - 機能要件、非機能要件

**特徴**:
- 非機能要件は選択式（セキュリティは常に含む）
- ステアリングドキュメントと整合性を保つ

**次のステップ**: 技術詳細の定義へ

#### `/sdd:define-technical <taskname>`
技術仕様と設計を定義します。

**生成されるファイル**:
- `specs/{taskname}/technical-details.md` - 技術スタック、アーキテクチャ、API設計

**重要**: `specs/_steering/tech.md` の技術方針を尊重（逸脱する場合は理由を明記）

**次のステップ**: 調査・検証へ

---

### 🔍 Phase 3: 調査・検証

#### `/sdd:conduct-research <taskname> [調査項目番号]`
research.mdの技術調査項目を実施します。

**役割**:
- 技術的な調査・検証（AIが自律的に実施）
- ライブラリ選定、実装方法の検証、パフォーマンス測定など

**vs clarify-spec**:
- `conduct-research`: AIが調べる（技術的検証）
- `clarify-spec`: ユーザーに聞く（ビジネス要件）

**次のステップ**: 実現可能性の検証へ

#### `/sdd:validate-feasibility <taskname>`
technical-details.mdの実現可能性を検証します。

**検証内容**:
- 既存プロジェクトとの互換性
- 技術スタックの整合性
- 実装可能性

**次のステップ**: 矛盾チェックへ

#### `/sdd:contradiction-check <taskname>`
仕様書間の矛盾を検出します。

**チェック項目**:
- Phase情報の矛盾（overview.md ⇔ tasks/phase*.md）
- 機能の矛盾（overview.md ⇔ specification.md ⇔ technical-details.md）
- データ設計の矛盾（specification.md ⇔ technical-details.md）

**使用タイミング**: いつでも実行可能。仕様変更時、実装中の疑問が生じた際、Phase完了前など

**次のステップ**: 不明点の明確化へ

#### `/sdd:clarify-spec <taskname>`
仕様書内の不明点（ビジネス要件）をユーザーに質問します。

**対象**:
- 「**不明**」とマークされた箇所
- 複数の案がある箇所（案A、案B、案C）

**vs conduct-research**:
- `clarify-spec`: ユーザーに聞く（ビジネス要件）
- `conduct-research`: AIが調べる（技術的検証）

**次のステップ**: Phase構成の決定へ

---

### 🗂️ Phase 4: Phase構成の決定

#### `/sdd:plan-phases <taskname>`
調査完了後、Phase構成をoverview.mdに追加します。

**前提条件**: `research.md` の全調査項目が完了していること

**追加内容**:
- Phase名、目標、依存関係、成果物
- 適切な数のPhaseを生成（プロジェクトの複雑度に応じて柔軟に決定）
- ユーザー承認後にoverview.mdを更新

**重要**: 詳細なタスク計画は `/sdd:breakdown-phase` で個別に作成

**次のステップ**: Phase詳細計画へ

---

### 📊 Phase 5: Phase詳細計画

#### `/sdd:breakdown-phase <taskname> <phase番号>`
指定されたPhaseの詳細タスク計画を生成します。

**引数**:
- `<taskname>` - タスク名（必須）
- `<phase番号>` - Phase番号（必須、例: 1, 2, 3）

**生成されるファイル**:
- `specs/{taskname}/tasks/phase{N}-{name}.md` - 指定Phaseの詳細計画

**各Phase計画書の内容**:
- タスク一覧（タスク番号、TDDステップ）
- 各タスクの詳細説明
- 依存関係
- テスト戦略

**重要**: Phase構成は `/sdd:plan-phases` で事前に決定されている必要があります

**次のステップ**: Phase実装へ

---

### 💻 Phase 6: Phase実装

#### `/sdd:implement-phase <taskname> [phase.task]`
Phase計画書に基づいて実装作業を行います。

**引数**:
- `<taskname>` - タスク名のみ: Phase 1から開始
- `<taskname> <phase>.<task>` - 指定したPhaseとタスクから開始

**実行内容**:
- ステアリングドキュメントと仕様書の読み込み
- 実装計画の提示
- コードとテストの実装
- 品質チェック
- Phase計画書の状態更新

**次のステップ**:
- 作業途中で中断する場合: `/sdd:sync-spec`
- Phase完了後: `/sdd:verify-phase`

#### `/sdd:sync-spec [taskname] [phase番号]`
実装状況を調査してPhase計画書とoverview.mdを同期します。

**実行内容**:
- コードベースから実装状況を推測
- タスク完了状況を判定
- Phase計画書とoverview.mdを更新

**引数省略時**: 会話のコンテキストから自動推測

**次のステップ**: 実装を続ける場合は `/sdd:implement-phase`

---

### ✅ Phase 7: Phase検証

#### `/sdd:verify-phase <taskname> <phase番号>`
Phase完了時の統合検証を実行します。

**検証内容**:
1. ドキュメント検証（`/sdd:verify:docs`）
2. 要件検証（`/sdd:verify:requirements`）
3. 品質検証（`/sdd:verify:quality`）

**総合評価**:
- ✅ Phase完了可能
- ⚠️ 一部に問題あり
- ❌ 重大な問題あり

**サブコマンド**:
- `/sdd:verify:docs <taskname> <phase番号>` - ドキュメント検証
- `/sdd:verify:requirements <taskname> <phase番号>` - 要件検証
- `/sdd:verify:quality <taskname> <phase番号>` - 品質検証

**次のステップ**:
- ✅の場合: 次のPhaseへ進む（Phase 5に戻る）
- ⚠️/❌の場合: 問題を解決して再検証

---

### 📦 タスク管理

#### `/sdd:list-specs`
すべてのspecの一覧とステータスを表示し、specs/status.mdに保存します。

**表示内容**:
- タスク名
- ステータス
- Phase進捗
- 最終更新
- 次のコマンド

**使用タイミング**: 全体の進捗状況を確認したい時

#### `/sdd:archive-spec`
完了または不要になったspecsをアーカイブします。

**実行内容**:
- タスク一覧を表示
- 「完了」または「却下」のタスクのみを対象
- `specs/_archived/{taskname}/`に移動

**使用タイミング**: Phase完了後、タスクが不要になった時

---

## 📊 ディレクトリ構造

```
specs/
├── _steering/                   # プロジェクト全体の永続的コンテキスト
│   ├── product.md               # プロダクト方針
│   ├── tech.md                  # 技術スタック
│   └── structure.md             # プロジェクト構造
├── {taskname}/
│   ├── overview.md              # プロジェクト概要とPhase構成
│   ├── research.md              # 調査項目リスト
│   ├── specification.md         # 機能要件と非機能要件
│   ├── technical-details.md     # 技術仕様と設計
│   └── tasks/
│       ├── phase1-{name}.md     # Phase 1 実装計画
│       ├── phase2-{name}.md     # Phase 2 実装計画
│       └── ...
├── status.md                    # 全タスクのステータス一覧
└── _archived/
    └── {taskname}/              # アーカイブされたタスク
```

## 🎯 次に実行すべきコマンドを知りたい場合

現在の状況から次のステップを提案してもらいたい場合:

```
/sdd:next-step <taskname>
```

このコマンドは、タスクの現在の状態を分析して、次に実行すべきコマンドを提案します。

## 💡 よくある使い方

### 初めてSDDを使う（プロジェクト全体で1回のみ）
```
/sdd:steering
```

### 新しいタスクを始める
```
# 1. タスク初期化
/sdd:init-task <計画の説明>

# 2. 要件と技術詳細を定義
/sdd:define-requirements {taskname}
/sdd:define-technical {taskname}

# 3. 調査・検証
/sdd:conduct-research {taskname}
/sdd:validate-feasibility {taskname}
/sdd:contradiction-check {taskname}
/sdd:clarify-spec {taskname}

# 4. Phase構成を決定
/sdd:plan-phases {taskname}

# 5. Phase詳細計画を作成（各Phaseごと）
/sdd:breakdown-phase {taskname} 1
/sdd:breakdown-phase {taskname} 2
# ...

# 6. Phase実装を開始
/sdd:implement-phase {taskname}
```

### Phase実装を続ける
```
/sdd:implement-phase {taskname} {phase}.{task}
```

### 作業を中断する前に
```
/sdd:sync-spec
```

### Phase完了時
```
/sdd:verify-phase {taskname} {phase}
```

### タスクの状態を確認したい時
```
/sdd:list-specs
```

### 次に何をすべきか分からない時
```
/sdd:next-step {taskname}
```

### タスク完了時・不要になった時
```
/sdd:archive-spec
```

## 🆕 新ワークフローの特徴

### ステアリングドキュメント
- プロジェクト全体の「永続的メモリ」として機能
- 全ての `/sdd:*` コマンドが自動的に読み込む
- Bootstrap Modeで既存プロジェクトから自動抽出

### 調査ファースト
- Phase構成の決定前に技術調査を完了
- `research.md` で調査項目を管理
- `/sdd:conduct-research` で技術的検証を実施

### Phase構成の段階的作成
1. `/sdd:plan-phases` でPhase構成のみを決定
2. `/sdd:breakdown-phase` で各Phaseの詳細計画を個別に作成
3. Phase実装前に詳細計画を見直し可能

## ⚠️ 非推奨コマンド

### `/sdd:create-specs` (非推奨)
このコマンドは役割ごとに細分化された以下のコマンドに置き換えられました：
- `/sdd:steering` - ステアリングドキュメント作成
- `/sdd:init-task` - タスク初期化
- `/sdd:define-requirements` - 要件定義
- `/sdd:define-technical` - 技術詳細定義
- `/sdd:plan-phases` - Phase構成決定
- `/sdd:breakdown-phase` - Phase詳細計画
