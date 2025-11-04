---
argument-hint: <タスク名>
allowed-tools: ["Read", "Edit", "Task"]
---

# specsドキュメント間の矛盾をチェックし、修正します

`specs/[taskname]/` ディレクトリ内の仕様書のドキュメント間の矛盾をチェックし、修正してください。

【対象タスク名】
$ARGUMENTS

## 実行手順

### 1. タスクディレクトリの確認

タスク名が指定されている場合:
- `specs/[taskname]/` ディレクトリの存在を確認
- 必須ファイルの存在確認:
  - `overview.md`
  - `specification.md`
  - `technical-details.md`
  - `tasks/` ディレクトリ（Phase別計画書）

タスク名が指定されていない場合:
- `specs/` ディレクトリ内の利用可能なタスクをリスト表示
- ユーザーに選択を求める

### 2. ステアリングドキュメントの読み込み

プロジェクト全体のコンテキストを把握するため、以下のステアリングドキュメントを読み込みます：

**`specs/_steering/product.md`**:
- プロダクトの目的とビジョン
- ターゲットユーザー
- 主要機能とビジネス目標

**`specs/_steering/tech.md`**:
- 技術スタックとアーキテクチャ
- 開発標準（型安全性、コード品質、テスト戦略）
- 重要な技術的決定事項

**`specs/_steering/structure.md`**:
- プロジェクト構造と命名規則
- コード組織原則
- モジュール境界

**ステアリングドキュメントが存在しない場合**:
- 警告メッセージを表示: 「⚠️ ステアリングドキュメントが見つかりません。プロジェクト固有のコンテキストなしで進めます。」
- `/sdd:steering` コマンドでステアリングドキュメントを作成することを推奨
- 処理は続行（ステアリングドキュメントは必須ではない）

### 3. ドキュメント間の矛盾チェック

以下の矛盾をチェックし、**全ての矛盾をリストアップ**してください：

#### Phase情報の矛盾
- overview.mdとtasks/phase*.mdでPhase数、Phase名、Phase状態、開始日時が一致しているか
- overview.mdの各Phaseの「目標」とtasks/phase*.mdの「Phase概要」の目標が一致しているか
- overview.mdの各Phaseの「依存関係」とtasks/phase*.mdの「依存関係」セクション（前提条件、ブロッカー、後続Phaseへの影響）が一致しているか
- overview.mdの各Phaseの「成果物」とtasks/phase*.mdの「Phase完了条件」や「次Phaseへの引き継ぎ事項」が一致しているか

#### 機能の矛盾
- overview.md、specification.md、technical-details.mdで記載されている機能リストが一致しているか
- specification.mdの各機能に対応する実装Phaseがtasks/phase*.mdに存在するか

#### データ設計の矛盾
- specification.mdとtechnical-details.mdでデータモデルの記述が一致しているか

### 4. 矛盾の報告と修正

**矛盾を発見した場合:**

1. **全ての矛盾をまとめて報告**する：
   - 矛盾の種類
   - 矛盾している箇所（ファイル名と該当部分）
   - 各ドキュメントでの記述内容

2. **AskUserQuestionツールを使用**して、全ての矛盾についてまとめて質問する：
   - 各矛盾に対して、どちらのドキュメントを正とするか
   - または新しい内容にするか

3. ユーザーの回答に基づいて該当ドキュメントを修正

4. 修正完了を報告

**矛盾がない場合:**
- 「矛盾は見つかりませんでした」と報告

## ステアリングドキュメントレビュー（必須）

矛盾修正後のドキュメントがステアリングドキュメントに準拠しているか必ず steering-reviewer SubAgent を使用して確認してください：

```bash
# steering-reviewer SubAgentを使用（指摘のみ、修正は行わない）
# レビュー観点を明示的に指定
Task(steering-reviewer): specs/[taskname]/ 配下の全ドキュメントをレビューしてください。product.mdのビジネス目標との整合性、tech.mdの技術方針との整合性、structure.mdのプロジェクト構造との整合性を確認してください。
```
