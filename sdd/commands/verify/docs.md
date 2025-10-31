---
argument-hint: <taskname> <phase番号>
---

# Phase計画書とドキュメントの検証

指定したPhaseのドキュメントとプロセス管理が適切に行われているかを検証します。

【引数】
$ARGUMENTS

## 引数の形式
- `<taskname>` - タスク名（specs/[taskname]/ディレクトリ）
- `<phase番号>` - 検証対象のPhase番号（1, 2, 3...）

## 検証手順

### 1. 準備
- 引数の解析（未指定の場合はAskUserQuestionで確認）
- `specs/[taskname]/tasks/phase{N}-*.md` の存在確認

### 2. Phase計画書のタスク完了状況チェック

Phase計画書を読み込み：
- タスク目次：全タスクが「完了」、TDDステップ（Red/Green/Refactor）完了を確認
- タスク詳細：状態、開始/完了日時、依存関係を確認

### 3. Phase完了条件のチェック

Phase計画書の「Phase完了条件」セクションの各チェックボックスを確認：
- 全タスク完了
- 全テスト通過
- 品質チェック成功
- コードレビュー承認

### 4. overview.mdとの整合性

- 対象Phaseの状態が「進行中」または「完了」か確認
- 前Phaseが「完了」状態か確認
- 前Phaseの成果物がoverview.mdに記載されているか確認

### 5. 次Phaseへの引き継ぎ事項の確認

Phase計画書の「次Phaseへの引き継ぎ事項」セクションを確認：
- 成果物リストの存在
- 未解決の課題、技術的負債の明記

### 6. Phase間のドキュメント整合性（Phase 2以降のみ）

- 前Phase計画書の「次Phaseへの引き継ぎ事項」から成果物リストを抽出
- 現Phase計画書で該当成果物が言及されているか確認

### 7. 検証結果レポート

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Phase {N} ドキュメント検証レポート
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 specs/{taskname}/ - Phase {N}
📅 {YYYY-MM-DD HH:MM}

## 総合評価
{✅ / ⚠️ / ❌}

## 検証結果

### タスク完了状況
{✅/⚠️/❌} {completed}/{total} タスク

### Phase完了条件
{✅/⚠️/❌} {completed}/{total} 項目

### overview.md整合性
{✅/⚠️/❌}

### 引き継ぎ事項
{✅/⚠️/❌}

### Phase間ドキュメント整合性
{✅/⚠️/❌/N/A}

## 🚨 要対応項目
{問題のリスト}

## 💡 次のアクション
✅: `/sdd:verify:requirements {taskname} {N}` で要件検証へ
⚠️/❌: 問題解決後、再検証（`/sdd:verify:docs {taskname} {N}`）

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 8. 問題への対応（⚠️/❌の場合）

AskUserQuestionで各問題の対応方針を確認（最大4問/回）：
- 選択肢に「修正する」「スキップする」「対応しない」等を含める
- 選択後、TodoWriteでタスク作成

## 注意事項

- ドキュメントとプロセス管理のみを検証
- コードやテストの実行は `verify:requirements` と `verify:quality` で実施
