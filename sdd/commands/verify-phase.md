---
argument-hint: <taskname> <phase番号>
allowed-tools: SlashCommand(/sdd:verify:docs:*), SlashCommand(/sdd:verify:requirements:*), SlashCommand(/sdd:verify:quality:*)
---

# Phase統合検証（ドキュメント・要件・品質の一括検証）

指定したPhaseの検証を統合的に実行します。以下の3つのコマンドを順次実行し、総合的な検証レポートを生成します。

【引数】
$ARGUMENTS

## 引数の形式
- `<taskname>` - タスク名（specs/[taskname]/ディレクトリ）
- `<phase番号>` - 検証対象のPhase番号（1, 2, 3...）

## 実行内容

このコマンドは以下の3つのコマンドを順次実行します：

### 1. `/sdd:verify:docs {taskname} {phase番号}`
Phase計画書とドキュメントの検証：
- タスク完了状況
- Phase完了条件
- overview.mdとの整合性
- 次Phaseへの引き継ぎ事項
- Phase間のドキュメント整合性

### 2. `/sdd:verify:requirements {taskname} {phase番号}`
要件と実装の整合性検証：
- specification.mdとの整合性（機能要件・非機能要件）
- technical-details.mdとの整合性（技術スタック・データ設計・API設計）
- Phase間の実装整合性（成果物の存在・使用状況・インターフェース）
- 機能レベルの実装検証

### 3. `/sdd:verify:quality {taskname} {phase番号}`
品質検証：
- コーディング規約（any型禁止、barrel禁止、interface使用）
- テストの存在と実行
- 品質チェックコマンド（lint、type-check、build）
- Phase間の実装品質

## 検証手順

1. **引数の確認**
   - タスク名とPhase番号が指定されているか確認
   - 未指定の場合はAskUserQuestionで確認

2. **3つのコマンドを順次実行**
   - 各コマンドの実行結果を記録
   - エラーが発生した場合も継続して次のコマンドを実行

3. **統合レポートの生成**
   - 3つのコマンドの結果を統合
   - 総合評価を決定（すべて✅なら✅、1つでも❌なら❌、それ以外は⚠️）

## 統合検証結果レポート

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 Phase {N} 統合検証レポート
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 specs/{taskname}/ - Phase {N}
📅 {YYYY-MM-DD HH:MM}

## 総合評価
{✅ Phase完了可能 / ⚠️ 一部に問題あり / ❌ 重大な問題あり}

## 検証結果サマリー

### 📋 ドキュメント検証
{✅/⚠️/❌}
- タスク完了状況: {✅/⚠️/❌}
- Phase完了条件: {✅/⚠️/❌}
- overview.md整合性: {✅/⚠️/❌}
- 引き継ぎ事項: {✅/⚠️/❌}
- Phase間ドキュメント整合性: {✅/⚠️/❌/N/A}

### 📐 要件検証
{✅/⚠️/❌}
- 機能要件: {✅/⚠️/❌}
- 非機能要件: {✅/⚠️/❌/N/A}
- technical-details.md整合性: {✅/⚠️/❌}
- Phase間実装整合性: {✅/⚠️/❌/N/A}
- 実装品質: {✅/⚠️/❌}

### 🔧 品質検証
{✅/⚠️/❌}
- コーディング規約: {✅/⚠️/❌}
- テスト: {✅/⚠️/❌}
- 品質チェック: {✅/⚠️/❌}
- Phase間実装品質: {✅/⚠️/❌/N/A}

## 🚨 要対応項目（全体）
{3つの検証で見つかった問題の統合リスト}

## 💡 次のアクション

{✅ の場合}
- Phase {N} の検証をすべてクリアしました
- overview.mdのPhase状態を「完了」に更新することを推奨
- 次のPhase（Phase {N+1}）に進むことができます
- 次のコマンド: `/sdd:implement-phase {taskname} {N+1}.1`

{⚠️ の場合}
- 以下の問題を解決してください:
  {問題リスト}
- 個別に再検証する場合:
  - `/sdd:verify:docs {taskname} {N}` - ドキュメント検証のみ
  - `/sdd:verify:requirements {taskname} {N}` - 要件検証のみ
  - `/sdd:verify:quality {taskname} {N}` - 品質検証のみ
- 全体を再検証: `/sdd:verify-phase {taskname} {N}`

{❌ の場合}
- 重大な問題があります。まず以下を解決してください:
  {問題リスト}
- 問題を解決後、再度検証してください

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 問題への対応

統合検証の結果、問題が見つかった場合：
- 各検証コマンドが個別に対応方針を確認
- 統合レポートではすべての問題をまとめて表示
- ユーザーが個別に再検証するか、全体を再検証するかを選択可能

## overview.md更新提案

総合評価が ✅ の場合のみ、AskUserQuestionで確認：
- 「overview.mdのPhase状態を『完了』に更新しますか？」
- 承認された場合、overview.mdの該当Phaseの状態を「完了」に更新

## 注意事項

- 3つの検証コマンドを順次実行する統合コマンド
- 各検証で問題が見つかっても、すべての検証を完了してから報告
- 問題の対応は各検証コマンドで個別に行うか、統合検証後にまとめて対応

## 矛盾チェック（必須）

Phase検証後、仕様書間の矛盾がないか必ず contradiction-checker SubAgent を使用して確認してください：

```bash
# contradiction-checker SubAgentを使用（指摘のみ、修正は行わない）
Task(contradiction-checker): specs/[taskname]/ の全ドキュメント間の矛盾をチェックしてください。Phase完了状態とタスク完了状態が整合しているか確認してください。
```
