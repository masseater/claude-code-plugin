# SDD (Specification-Driven Development)

SDDは**Specification-Driven Development(仕様駆動開発)**の略で、明確な仕様書に基づいて段階的に実装を進める開発手法です。

## 📚 概要

SDDは以下の原則に基づいています：

- **明確な仕様**: 実装前に詳細な仕様書を作成
- **段階的実装**: Phaseに分けて実装を進める
- **継続的検証**: 各Phaseで要件と品質を検証
- **TDD統合**: テスト駆動開発と組み合わせて品質を確保

## 🔄 基本ワークフロー

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

## 📋 コマンド一覧

### Phase 1: 仕様作成

#### `/sdd:create-specs <計画の説明>`
計画をもとにプロジェクトの全容ドキュメント、技術詳細、仕様書を生成します。

**生成されるファイル**:
- `specs/{taskname}/overview.md` - プロジェクト概要とPhase構成
- `specs/{taskname}/specification.md` - 機能要件と非機能要件
- `specs/{taskname}/technical-details.md` - 技術仕様と設計

### Phase 2: 仕様の検証・明確化

#### `/sdd:clarify-spec <タスク名>`
specs内の不明箇所をユーザーに質問して明確化します。

**対象**: 「**不明**」とマークされた箇所や複数の案がある箇所を特定し、ユーザーに質問します。

#### `/sdd:contradiction-check <タスク名>`
specsドキュメント間の矛盾をチェックし、修正します。

**チェック項目**:
- Phase情報の矛盾（overview.mdとtasks/phase*.md）
- 機能の矛盾
- データ設計の矛盾

#### `/sdd:validate-feasibility <タスク名>`
technical-details.md の実現可能性検証と更新を行います。

**チェック項目**:
- 技術スタックの確認
- ディレクトリ構造の確認
- データベース関連の確認
- API構造の確認

### Phase 3: Phase分割計画

#### `/sdd:break-down-phase <タスク名>`
既存specsプロジェクトのPhase別計画書を生成・管理します。

**生成されるファイル**:
- `specs/{taskname}/tasks/phase1-{name}.md`
- `specs/{taskname}/tasks/phase2-{name}.md`
- ...

**各Phase計画書の内容**:
- タスク一覧（タスク番号、TDDステップ）
- 各タスクの詳細説明
- 依存関係
- テスト戦略
- Phase完了条件

### Phase 4: Phase実装

#### `/sdd:implement-phase <taskname> [phase.task]`
specs/[taskname]/配下の仕様書ドキュメントを読み込み、それに基づいて実装作業を行います。

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

#### `/sdd:sync-spec [taskname] [phase番号]`
Phase途中でのドキュメント同期を行います。

**実行内容**:
- コードベースから実装状況を推測
- タスク完了状況を判定
- Phase計画書を更新
- overview.mdを更新

**引数省略時**: 会話のコンテキストから自動推測します。

### Phase 5: Phase検証

#### `/sdd:verify-phase <taskname> <phase番号>`
Phase統合検証（ドキュメント・要件・品質の一括検証）を実行します。

**検証内容**:
1. ドキュメント検証（`/sdd:verify:docs`）
2. 要件検証（`/sdd:verify:requirements`）
3. 品質検証（`/sdd:verify:quality`）

**総合評価**:
- ✅ Phase完了可能
- ⚠️ 一部に問題あり
- ❌ 重大な問題あり

#### `/sdd:verify:docs <taskname> <phase番号>`
Phase計画書とドキュメントの検証を行います。

**検証項目**:
- タスク完了状況
- Phase完了条件
- overview.mdとの整合性
- 次Phaseへの引き継ぎ事項
- Phase間のドキュメント整合性

#### `/sdd:verify:requirements <taskname> <phase番号>`
Phase要件と実装の整合性検証を行います。

**検証項目**:
- specification.mdとの整合性（機能要件・非機能要件）
- technical-details.mdとの整合性（技術スタック・データ設計・API設計）
- Phase間の実装整合性
- 機能レベルの実装検証

#### `/sdd:verify:quality <taskname> <phase番号>`
Phase実装の品質検証を行います。

**検証項目**:
- コーディング規約（any型禁止、barrel禁止、interface使用）
- テストの存在と実行
- 品質チェックコマンド（lint、type-check、build）
- Phase間の実装品質

### タスク管理

#### `/sdd:list-specs`
すべてのspecの一覧とステータスを表示し、`specs/status.md`に保存します。

**表示内容**:
- タスク名
- ステータス（未着手/進行中/完了）
- Phase進捗（各Phaseのタスク完了数）
- Phase完了条件の達成状況
- 最終更新日時
- 次に実行すべきコマンド

**出力形式**:
- Markdown table形式
- ステータス順（未着手→進行中→完了）でグループ化
- 各グループ内で更新日時順（新しい順）にソート

#### `/sdd:archive-spec`
完了または不要になったspecsをアーカイブします。

**実行内容**:
- specs/配下のタスク一覧を表示
- 各タスクのPhase状態からアーカイブ理由を自動判定（完了/保留/却下）
- 選択したタスクを`specs/_archived/[taskname]/`に移動
- アーカイブ情報を記録

**移動方法**:
- Gitリポジトリ内: `git mv`を使用
- それ以外: `mv`を使用

### ヘルプ

#### `/sdd:help`
SDDワークフローの全体像とコマンド一覧を表示します。

#### `/sdd:next-step <taskname>`
次に実行すべきステップを提案します。

**実行内容**:
- タスクの現在の状態を分析
- 次に実行すべきコマンドを提案
- 代替案も表示

## 🚀 クイックスタート

### 新しいタスクを始める

```bash
# 1. 仕様書を作成
/sdd:create-specs

# 2. 不明点を明確化
/sdd:clarify-spec {taskname}

# 3. 矛盾をチェック
/sdd:contradiction-check {taskname}

# 4. 実現可能性を検証
/sdd:validate-feasibility {taskname}

# 5. Phase別計画書を作成
/sdd:break-down-phase {taskname}

# 6. 実装を開始
/sdd:implement-phase {taskname}
```

### Phase実装を続ける

```bash
# 特定のタスクから実装を続ける
/sdd:implement-phase {taskname} {phase}.{task}
```

### 作業を中断する前に

```bash
# 進捗を仕様書に記録
/sdd:sync-spec
```

### Phase完了時

```bash
# Phase検証を実行
/sdd:verify-phase {taskname} {phase}
```

### タスクの状態を確認したい時

```bash
# すべてのspecの一覧とステータスを表示
/sdd:list-specs
```

### 次に何をすべきか分からない時

```bash
# 次のステップを提案してもらう
/sdd:next-step {taskname}
```

### タスク完了時・不要になった時

```bash
# タスクをアーカイブ
/sdd:archive-spec
```

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
        ├── overview.md
        ├── specification.md
        ├── technical-details.md
        └── tasks/
            └── ...
```

## 💡 TDDサイクル

SDDはTDD（Test-Driven Development）と組み合わせて使用することを推奨します：

1. **Red**: テストを先に書く（失敗するテストの作成）
2. **Green**: テストを通すための最小限の実装
3. **Refactor**: コードのリファクタリング

各Phase計画書では、各タスクのTDDステップ（Red/Green/Refactor）を管理します。

## 🎯 開発の原則

SDDは以下の設計原則を重視します：

- **単一責任の原則 (SRP)**: 各Phase/タスク/関数は単一の責任を持つ
- **開放/閉鎖の原則 (OCP)**: 拡張に対して開いており、修正に対して閉じている設計
- **リスコフの置換原則 (LSP)**: 型の一貫性と期待される振る舞いを保つ
- **最小限の公開**: 必要な機能のみを公開し、内部実装の詳細は隠蔽する
- **依存性逆転の原則 (DIP)**: 具体的な実装ではなく、契約（関数シグネチャ）に依存する

**重要な制約**:
- インターフェースや抽象クラスの使用は、それを使用しなければ実現できない時以外は禁止
- 型定義だけを先に作ることは禁止（実装とセットで進める）

## 🔗 関連リンク

- [詳細なヘルプ](/sdd:help)
- [次のステップを確認](/sdd:next-step)
