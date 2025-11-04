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

### 3. ドキュメント間の矛盾チェック（contradiction-checker SubAgent使用）

**contradiction-checker SubAgent** を使用して包括的な矛盾チェックを実施します：

```bash
# contradiction-checker SubAgentを使用（指摘のみ、修正は行わない）
Task(contradiction-checker): specs/[taskname]/ の全ドキュメント間の矛盾をチェックしてください。Phase情報、機能定義、データ設計、API設計、セキュリティ要件、Phase間依存関係の整合性を確認してください。
```

**SubAgentがチェックする項目**:
- Phase情報の整合性（overview.md ⇔ tasks/phase*.md）
- 機能定義の整合性（overview.md ⇔ specification.md ⇔ technical-details.md）
- データ設計の整合性（specification.md ⇔ technical-details.md）
- API設計の整合性
- セキュリティ要件の整合性
- Phase間依存関係の妥当性

SubAgentは検出した矛盾を重要度別（高/中/低）にレポートします。

### 4. 矛盾の修正

**contradiction-checker SubAgentが矛盾を報告した場合:**

1. **SubAgentのレポートを確認**:
   - 重要度別の矛盾一覧を確認
   - 各矛盾の影響範囲と推奨対応を確認

2. **高重要度の矛盾から対応**:
   - 実装作業に影響する矛盾を優先的に修正

3. **AskUserQuestionツールを使用**して修正方針を確認:
   - 各矛盾に対して、どちらのドキュメントを正とするか
   - または新しい内容にするか
   - 複数の矛盾がある場合は、まとめて質問

4. **ユーザーの回答に基づいて該当ドキュメントを修正**:
   - Editツールを使用してドキュメントを更新
   - 修正内容を明確に報告

5. **修正完了後、再度矛盾チェック**:
   - 修正によって新たな矛盾が発生していないか確認
   - 必要に応じてcontradiction-checker SubAgentを再実行

**矛盾がない場合:**
- SubAgentのレポートを基に「矛盾は見つかりませんでした」と報告
- 次のステップ（実装開始など）を提案

## ステアリングドキュメントレビュー（必須）

矛盾修正後のドキュメントがステアリングドキュメントに準拠しているか必ず steering-reviewer SubAgent を使用して確認してください：

```bash
# steering-reviewer SubAgentを使用（指摘のみ、修正は行わない）
# レビュー観点を明示的に指定
Task(steering-reviewer): specs/[taskname]/ 配下の全ドキュメントをレビューしてください。product.mdのビジネス目標との整合性、tech.mdの技術方針との整合性、structure.mdのプロジェクト構造との整合性を確認してください。
```
