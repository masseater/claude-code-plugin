---
description: SDDワークフローの全体像とコマンド一覧を表示
---

# SDDワークフローガイド

SDDは**Specification-Driven Development（仕様駆動開発）**の略で、明確な仕様書に基づいて段階的に実装を進める開発手法です。

## 基本ワークフロー

```
0. ステアリングドキュメント作成（初回のみ）
   ↓
1. タスク初期化・実装計画
   ├── タスク骨格作成
   ├── 実装概要・調査項目特定
   └── 調査実施
   ↓
2. 要件・技術詳細の定義
   ├── 要件定義
   ├── 技術詳細作成
   └── 実現可能性検証
   ↓
3. 仕様の検証・明確化
   ├── 不明箇所の明確化
   └── 矛盾チェック
   ↓
4. Phase構成の決定
   ↓
5. Phase詳細計画（各Phaseごと）
   ↓
6. Phase実装
   ├── Phase実装
   └── ドキュメント同期
   ↓
7. Phase検証
   ├── ドキュメント検証
   ├── 要件検証
   └── 品質検証
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
- `specs/_steering/principles.md` - 開発原則（TDD、SOLID、YAGNI）

**実行モード**:
- **Bootstrap Mode（初期作成）**: 既存プロジェクトから情報を抽出して自動生成
- **Sync Mode（更新）**: プロジェクトの変更を検出して更新提案

**重要**: 全ての `/sdd:*` コマンドは自動的にステアリングドキュメントを読み込みます

**次のステップ**: タスク初期化へ

---

### 📝 Phase 1: タスク初期化・実装計画

#### `/sdd:init-task <計画の説明>`
新しいタスクのスケルトンを作成します（最小限の情報のみ）。

**生成されるファイル**:
- `specs/{taskname}/overview.md` - プロジェクト概要（実装概要と調査項目は未記入）

**次のステップ**: `/sdd:plan-implementation {taskname}`

#### `/sdd:plan-implementation <タスク名>`
実装概要と調査項目を特定してoverview.mdに追加します。

**更新されるファイル**:
- `specs/{taskname}/overview.md` - 実装概要と調査項目表を追加

**次のステップ**: `/sdd:conduct-research {taskname}`

#### `/sdd:conduct-research <タスク名> [調査項目名]`
overview.mdの調査項目を実施し、個別ファイルとして保存します。

**生成されるファイル**:
- `specs/research/[調査項目名].md` - 調査結果（結論、詳細、関連タスク）

**更新されるファイル**:
- `specs/{taskname}/overview.md` - 調査項目表の状態を「完了」に更新

**役割**:
- 技術的な調査・検証（AIが自律的に実施）
- ライブラリ選定、実装方法の検証、パフォーマンス測定など

**vs clarify-spec**:
- `conduct-research`: AIが調べる（技術的検証）
- `clarify-spec`: ユーザーに聞く（ビジネス要件）

**次のステップ**: `/sdd:define-requirements {taskname}`（全調査完了後）

---

### 📋 Phase 2: 要件・技術詳細の定義

#### `/sdd:define-requirements <タスク名>`
機能要件と非機能要件を定義します。

**生成されるファイル**:
- `specs/{taskname}/specification.md` - 機能要件、非機能要件

**特徴**:
- 非機能要件は選択式（セキュリティは常に含む）
- ステアリングドキュメントと整合性を保つ

**次のステップ**: `/sdd:define-technical {taskname}`

#### `/sdd:define-technical <タスク名>`
技術仕様と設計を定義します。

**生成されるファイル**:
- `specs/{taskname}/technical-details.md` - 技術スタック、アーキテクチャ、API設計

**重要**: `specs/_steering/tech.md` の技術方針を尊重（逸脱する場合は理由を明記）

**次のステップ**: `/sdd:validate-feasibility {taskname}`

#### `/sdd:validate-feasibility <タスク名>`
technical-details.mdの実現可能性を検証します。

**検証内容**:
- 既存プロジェクトとの互換性
- 技術スタックの整合性
- 実装可能性

**更新されるファイル**:
- `specs/{taskname}/technical-details.md` - 実プロジェクトとの整合性を確認・修正

**次のステップ**: `/sdd:plan-phases {taskname}`

---

### 🔍 Phase 3: 仕様の検証・明確化

#### `/sdd:clarify-spec <タスク名>`
仕様書内の不明点（ビジネス要件）をユーザーに質問します。

**対象**:
- 「**不明**」とマークされた箇所
- 複数の案がある箇所（案A、案B、案C）

**更新されるファイル**:
- `specs/{taskname}/` 配下の全ドキュメント - 「**不明**」箇所を更新

**vs conduct-research**:
- `clarify-spec`: ユーザーに聞く（ビジネス要件）
- `conduct-research`: AIが調べる（技術的検証）

**使用タイミング**: 仕様書に不明箇所がある場合、いつでも実行可能

#### `/sdd:contradiction-check <タスク名>`
仕様書間の矛盾を検出します。

**チェック項目**:
- Phase情報の矛盾（overview.md ⇔ tasks/phase*.md）
- 機能の矛盾（overview.md ⇔ specification.md ⇔ technical-details.md）
- データ設計の矛盾（specification.md ⇔ technical-details.md）

**使用タイミング**: 仕様変更時、実装中の疑問が生じた際、Phase完了前など

---

### 🗂️ Phase 4: Phase構成の決定

#### `/sdd:plan-phases <タスク名>`
調査完了後、Phase構成をoverview.mdに追加します。

**前提条件**: `overview.md` の全調査項目が「完了」状態であること

**追加内容**:
- Phase名、目標、依存関係、成果物
- 適切な数のPhaseを生成（プロジェクトの複雑度に応じて柔軟に決定）
- ユーザー承認後にoverview.mdを更新

**重要**: 詳細なタスク計画は `/sdd:breakdown-phase` で個別に作成

**次のステップ**: `/sdd:breakdown-phase {taskname} 1`

---

### 📊 Phase 5: Phase詳細計画

#### `/sdd:breakdown-phase <タスク名> <phase番号>`
指定されたPhaseの詳細タスク計画を生成します。

**引数**:
- `<タスク名>` - タスク名（必須）
- `<phase番号>` - Phase番号（必須、例: 1, 2, 3）

**生成されるファイル**:
- `specs/{taskname}/tasks/phase{N}-{name}.md` - 指定Phaseの詳細計画

**各Phase計画書の内容**:
- タスク一覧（タスク番号、TDDステップ）
- 各タスクの詳細説明
- 依存関係
- テスト戦略

**重要**: Phase構成は `/sdd:plan-phases` で事前に決定されている必要があります

**次のステップ**: `/sdd:implement-phase {taskname} {N}.1`

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
- 全Phase完了: `/sdd:archive-spec {taskname}`

---

### 📦 タスク管理

#### `/sdd:list-specs`
すべてのspecの一覧とステータスを表示し、specs/status.mdに保存します。

**表示内容**:
- タスク名
- ステータス（未着手/進行中/完了）
- Phase進捗（Phase N (完了数/総数)）
- 最終更新日
- 次のコマンド

**生成されるファイル**:
- `specs/status.md` - 全タスクの進捗状況

**使用タイミング**: 全体の進捗状況を確認したい時

#### `/sdd:archive-spec`
完了または不要になったspecsをアーカイブします。

**実行内容**:
- タスク一覧を表示
- 「完了」または「却下」のタスクのみを対象
- `specs/_archived/{taskname}/`に移動

**使用タイミング**: 全Phase完了後、タスクが不要になった時

---

### 🧭 ナビゲーション

#### `/sdd:next-step <taskname>`
タスクの現在の状態を分析して、次に実行すべきコマンドを提案します。

**使用タイミング**: 次に何をすべきか分からない時

#### `/sdd:help`
このガイドを表示します。SDDワークフローの全体像とコマンド一覧を確認できます。

---

## 📊 ディレクトリ構造

```
specs/
├── _steering/                   # プロジェクト全体の永続的コンテキスト
│   ├── product.md               # プロダクト方針
│   ├── tech.md                  # 技術スタック
│   ├── structure.md             # プロジェクト構造
│   └── principles.md            # 開発原則
├── research/                    # 調査結果の個別ファイル
│   ├── [調査項目名].md
│   └── ...
├── {taskname}/
│   ├── overview.md              # プロジェクト概要、Phase構成、調査項目表
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

---

## 💡 よくある使い方

### 初めてSDDを使う（プロジェクト全体で1回のみ）
```
/sdd:steering
```

### 新しいタスクを始める
```
# 1. タスク初期化
/sdd:init-task <計画の説明>

# 2. 実装概要と調査項目を特定
/sdd:plan-implementation {taskname}

# 3. 調査実施
/sdd:conduct-research {taskname}

# 4. 要件と技術詳細を定義
/sdd:define-requirements {taskname}
/sdd:define-technical {taskname}

# 5. 実現可能性検証
/sdd:validate-feasibility {taskname}

# 6. 不明点の明確化・矛盾チェック
/sdd:clarify-spec {taskname}
/sdd:contradiction-check {taskname}

# 7. Phase構成を決定
/sdd:plan-phases {taskname}

# 8. Phase詳細計画を作成（各Phaseごと）
/sdd:breakdown-phase {taskname} 1
/sdd:breakdown-phase {taskname} 2
# ...

# 9. Phase実装を開始
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

---

## 🆕 ワークフローの特徴

### ステアリングドキュメント
- プロジェクト全体の「永続的メモリ」として機能
- 全ての `/sdd:*` コマンドが自動的に読み込む
- Bootstrap Modeで既存プロジェクトから自動抽出
- principles.md で開発原則（TDD、SOLID、YAGNI）を定義

### 調査ファースト
- Phase構成の決定前に技術調査を完了
- `overview.md` の調査項目表で調査を管理
- `/sdd:conduct-research` で技術的検証を実施
- 調査結果は `specs/research/` に個別ファイルとして保存

### Phase構成の段階的作成
1. `/sdd:plan-implementation` で実装概要と調査項目を特定
2. `/sdd:conduct-research` で調査を完了
3. `/sdd:plan-phases` でPhase構成のみを決定
4. `/sdd:breakdown-phase` で各Phaseの詳細計画を個別に作成
5. Phase実装前に詳細計画を見直し可能

### 内部品質チェック
- SubAgent（steering-reviewer、contradiction-checker）による内部チェック
- **重要**: チェック結果はspecファイルに書かず、問題がある場合のみユーザーに報告
- ステアリングドキュメントへの準拠チェック
- 仕様書間の矛盾チェック

---

**最終更新**: 2025-01-05
**コマンド数**: 21コマンド
