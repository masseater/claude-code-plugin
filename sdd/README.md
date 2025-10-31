# sdd - Spec Driven Development ワークフロー支援

SDD（Specification-Driven Development：仕様駆動開発）は、明確な仕様書に基づいて段階的に実装を進める開発手法です。

## 概要

SDDは以下の原則に基づいています：

- **明確な仕様**: 実装前に詳細な仕様書を作成
- **段階的実装**: Phaseに分けて実装を進める
- **継続的検証**: 各Phaseで要件と品質を検証
- **TDD統合**: テスト駆動開発と組み合わせて品質を確保

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

## コマンド一覧

### Phase 1: 仕様作成

#### `/sdd create-specs [計画の説明]`
新しいタスクの仕様書を作成します。

**生成されるファイル**:
- `specs/{taskname}/overview.md` - プロジェクト概要とPhase構成
- `specs/{taskname}/specification.md` - 機能要件と非機能要件
- `specs/{taskname}/technical-details.md` - 技術仕様と設計

### Phase 2: 仕様の検証・明確化

#### `/sdd clarify-spec <taskname>`
仕様書内の不明点や曖昧な箇所を特定し、明確化します。

**対象**: 「不明」とマークされた箇所や複数の案がある箇所

#### `/sdd contradiction-check <taskname>`
仕様書内の矛盾や不整合を検出します。

**チェック項目**:
- 機能要件間の矛盾
- 機能要件と非機能要件の矛盾
- 技術選定と要件の不整合

**使用タイミング**: いつでも実行可能（仕様変更時、実装中、Phase完了前など）

#### `/sdd validate-feasibility <taskname>`
仕様の実現可能性を技術的・リソース的に検証します。

**チェック項目**:
- 技術的実現可能性
- 依存関係の整合性
- リソースとスケジュールの妥当性

### Phase 3: Phase分割計画

#### `/sdd break-down-phase <taskname>`
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

### Phase 4: Phase実装

#### `/sdd implement-phase <taskname> [phase.task]`
Phase計画書に基づいて実装作業を行います。

**引数**:
- `<taskname>` - Phase 1から開始
- `<taskname> <phase>.<task>` - 指定したPhaseとタスクから開始

**実行内容**:
- 仕様書の読み込み
- 実装計画の提示
- コードとテストの実装
- 品質チェック
- Phase計画書の状態更新

#### `/sdd sync-spec [taskname] [phase番号]`
実装状況を調査してPhase計画書とoverview.mdを同期します。

**実行内容**:
- コードベースから実装状況を推測
- タスク完了状況を判定
- Phase計画書とoverview.mdを更新

**引数省略時**: 会話のコンテキストから自動推測

### Phase 5: Phase検証

#### `/sdd verify-phase <taskname> <phase番号>`
Phase完了時の統合検証を実行します。

**検証内容**:
1. ドキュメント検証（`/sdd verify:docs`）
2. 要件検証（`/sdd verify:requirements`）
3. 品質検証（`/sdd verify:quality`）

**総合評価**:
- ✅ Phase完了可能
- ⚠️ 一部に問題あり
- ❌ 重大な問題あり

**サブコマンド**:
- `/sdd verify:docs <taskname> <phase番号>` - ドキュメント検証
- `/sdd verify:requirements <taskname> <phase番号>` - 要件検証
- `/sdd verify:quality <taskname> <phase番号>` - 品質検証

### タスク管理

#### `/sdd list-specs`
すべてのspecの一覧とステータスを表示し、`specs/status.md`に保存します。

**表示内容**:
- タスク名
- ステータス
- Phase進捗
- 最終更新
- 次のコマンド

#### `/sdd archive-spec`
完了または不要になったspecsをアーカイブします。

**実行内容**:
- タスク一覧を表示
- 「完了」または「却下」のタスクのみを対象
- `specs/_archived/{taskname}/`に移動

### ナビゲーション

#### `/sdd next-step <taskname>`
タスクの現在の状態を分析して、次に実行すべきコマンドを提案します。

#### `/sdd help`
SDDワークフローの全体像とコマンド一覧を表示します（詳細ガイド）。

## よくある使い方

### 新しいタスクを始める
```bash
/sdd create-specs
/sdd clarify-spec {taskname}
/sdd contradiction-check {taskname}
/sdd validate-feasibility {taskname}
/sdd break-down-phase {taskname}
/sdd implement-phase {taskname}
```

### Phase実装を続ける
```bash
/sdd implement-phase {taskname} {phase}.{task}
```

### 作業を中断する前に
```bash
/sdd sync-spec
```

### Phase完了時
```bash
/sdd verify-phase {taskname} {phase}
```

### タスクの状態を確認したい時
```bash
/sdd list-specs
```

### 次に何をすべきか分からない時
```bash
/sdd next-step {taskname}
```

### タスク完了時・不要になった時
```bash
/sdd archive-spec
```

## ディレクトリ構造

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
├── status.md                    # 全タスクのステータス一覧
└── _archived/
    └── {taskname}/              # アーカイブされたタスク
```

## インストール

```bash
/plugin marketplace add https://github.com/masseater/claude-code-plugin
/plugin install sdd
```

## 参考資料

- [Claude Code プラグインドキュメント](https://docs.claude.com/ja/docs/claude-code/plugins)
