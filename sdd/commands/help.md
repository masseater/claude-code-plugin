---
description: SDDワークフローの全体像とコマンド一覧を表示
---

# SDDワークフローガイド

SDDは**Specification-Driven Development（仕様駆動開発）**の略で、明確な仕様書に基づいて段階的に実装を進める開発手法です。

## 基本ワークフロー

```
1. 仕様作成
   ↓
2. 仕様の検証・明確化
   ↓
3. Phase分割計画
   ↓
4. Phase実装
   ↓
5. Phase検証
   ↓
6. 次Phaseへ（4に戻る）
```

## コマンド一覧と使用順序

### 📝 Phase 1: 仕様作成

#### `/sdd:create-specs`
新しいタスクの仕様書を作成します。

**生成されるファイル**:
- `specs/{taskname}/overview.md` - プロジェクト概要とPhase構成
- `specs/{taskname}/specification.md` - 機能要件と非機能要件
- `specs/{taskname}/technical-details.md` - 技術仕様と設計

**次のステップ**: 仕様の検証・明確化へ

---

### 🔍 Phase 2: 仕様の検証・明確化

#### `/sdd:clarify-spec <taskname>`
仕様書内の不明点や曖昧な箇所を特定し、明確化します。

**対象**: 「**不明**」とマークされた箇所や複数の案がある箇所

**次のステップ**: 仕様の整合性チェックへ

#### `/sdd:contradiction-check <taskname>`
仕様書内の矛盾や不整合を検出します。

**チェック項目**:
- 機能要件間の矛盾
- 機能要件と非機能要件の矛盾
- 技術選定と要件の不整合

**使用タイミング**: いつでも実行可能。仕様変更時、実装中の疑問が生じた際、Phase完了前など

**次のステップ**: 実現可能性の検証へ

#### `/sdd:validate-feasibility <taskname>`
仕様の実現可能性を技術的・リソース的に検証します。

**チェック項目**:
- 技術的実現可能性
- 依存関係の整合性
- リソースとスケジュールの妥当性

**次のステップ**: Phase分割計画へ

---

### 📋 Phase 3: Phase分割計画

#### `/sdd:break-down-phase <taskname>`
仕様書からPhase別の詳細実装計画を作成します。

**生成されるファイル**:
- `specs/{taskname}/tasks/phase1-{name}.md`
- `specs/{taskname}/tasks/phase2-{name}.md`
- ...

**各Phase計画書の内容**:
- タスク一覧（タスク番号、TDDステップ）
- 各タスクの詳細説明
- 依存関係
- テスト戦略

**次のステップ**: Phase実装へ

---

### 💻 Phase 4: Phase実装

#### `/sdd:implement-phase <taskname> [phase.task]`
Phase計画書に基づいて実装作業を行います。

**引数**:
- `<taskname>` - タスク名のみ: Phase 1から開始
- `<taskname> <phase>.<task>` - 指定したPhaseとタスクから開始

**実行内容**:
- 仕様書の内容を読み込み
- 実装計画を提示
- コードの実装
- テストの実装
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
- Phase計画書を更新
- overview.mdを更新

**引数省略時**: 会話のコンテキストから自動推測

**次のステップ**: 実装を続ける場合は `/sdd:implement-phase`

---

### ✅ Phase 5: Phase検証

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

**次のステップ**:
- ✅の場合: 次のPhaseへ進む（Phase 4に戻る）
- ⚠️/❌の場合: 問題を解決して再検証

---

### 📦 タスク管理

#### `/sdd:list-specs`
すべてのspecの一覧とステータスを表示し、specs/status.mdに保存します。

**実行内容**:
- specs/配下のすべてのタスクを走査
- 各タスクの進捗状況を集計
- タスク名、ステータス、Phase進捗、最終更新、次のコマンドを表示
- `specs/status.md`に保存

**使用タイミング**: 全体の進捗状況を確認したい時

#### `/sdd:archive-spec`
完了または不要になったspecsをアーカイブします。

**実行内容**:
- specs/配下のタスク一覧を表示
- overview.mdの「プロジェクトステータス」が「完了」または「却下」のタスクのみをアーカイブ対象として表示
- 選択したタスクを`specs/_archived/[taskname]/`に移動

**使用タイミング**: Phase完了後、タスクが不要になった時

---

## 📊 ディレクトリ構造

```
specs/
├── {taskname}/
│   ├── overview.md              # プロジェクト概要とPhase構成
│   ├── specification.md         # 機能要件と非機能要件
│   ├── technical-details.md     # 技術仕様と設計
│   └── tasks/
│       ├── phase1-{name}.md     # Phase 1 実装計画
│       ├── phase2-{name}.md     # Phase 2 実装計画
│       └── ...
└── _archived/
    └── {taskname}/              # アーカイブされたタスク
        └── ...
```

## 🎯 次に実行すべきコマンドを知りたい場合

現在の状況から次のステップを提案してもらいたい場合:

```
/sdd:next-step <taskname>
```

このコマンドは、タスクの現在の状態を分析して、次に実行すべきコマンドを提案します。

## 💡 よくある使い方

### 新しいタスクを始める
```
/sdd:create-specs
→ /sdd:clarify-spec {taskname}
→ /sdd:contradiction-check {taskname}
→ /sdd:validate-feasibility {taskname}
→ /sdd:break-down-phase {taskname}
→ /sdd:implement-phase {taskname}
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
