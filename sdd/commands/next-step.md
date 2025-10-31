---
argument-hint: <taskname>
---

# 次に実行すべきステップを提案

現在のタスクの状態を分析して、次に実行すべきコマンドを提案します。

【引数】
$ARGUMENTS

## 引数の形式
- `<taskname>` - タスク名（省略時: specs/配下から選択）

## 実行手順

### 1. タスクの特定

#### 引数が指定されている場合
- `specs/{taskname}/` ディレクトリの存在を確認
- 存在しない場合はエラーメッセージとspecs/配下のタスク一覧を表示

#### 引数が指定されていない場合
- `specs/` 配下のタスクをリスト表示
- AskUserQuestionで選択

### 2. タスクの状態分析

以下のファイルとディレクトリを確認して、タスクの進捗状況を判定：

#### 仕様書ファイルの存在確認
- `specs/{taskname}/overview.md`
- `specs/{taskname}/specification.md`
- `specs/{taskname}/technical-details.md`

#### 仕様書の完成度チェック
- 「**不明**」マークの有無
- 複数の案（案A、案B等）の有無
- Phase概要と依存関係セクションの有無

#### Phase計画書の存在確認
- `specs/{taskname}/tasks/` ディレクトリの存在
- Phase計画書ファイル（`phase{N}-*.md`）の存在

#### Phase進捗の確認
各Phase計画書から：
- タスクの状態（未着手/進行中/完了/保留）
- Phase状態（未着手/進行中/完了/保留）
- Phase完了条件のチェック状況

#### overview.mdのPhase状態
- 各Phaseの状態
- 依存関係の満たし方

### 3. 状態に基づく判定

分析結果から、タスクがどの段階にあるかを判定：

#### 状態1: 仕様書が存在しない
→ 新規タスクの作成段階

#### 状態2: 仕様書は存在するが不完全
- 「**不明**」マークがある
- 複数の案が残っている
→ 仕様の明確化が必要

#### 状態3: 仕様書は完成しているがPhase計画書がない
→ Phase分割計画が必要

#### 状態4: Phase計画書は存在するが未着手
→ 実装開始が必要

#### 状態5: Phase実装中
- 進行中または完了したタスクがある
- すべてのタスクは完了していない
→ 実装継続または仕様書同期が必要

#### 状態6: Phase完了（Phase完了条件未チェック）
- すべてのタスクが完了
- Phase完了条件がチェックされていない
→ Phase検証が必要

#### 状態7: Phase検証済み（次Phaseあり）
- Phase完了条件がすべてチェック済み
- overview.mdで次Phaseが定義されている
→ 次Phaseの実装開始

#### 状態8: すべてのPhase完了
- すべてのPhaseが完了状態
→ タスク完了

### 4. 提案の表示

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 次のステップ提案
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 タスク: {taskname}

## 現在の状態

{状態の詳細説明}

### 仕様書の状態
- overview.md: {存在/不完全/完成}
- specification.md: {存在/不完全/完成}
- technical-details.md: {存在/不完全/完成}
- 不明点: {数}箇所
- 複数案: {数}箇所

### Phase進捗
- Phase 1: {状態} - タスク完了: {completed}/{total}
- Phase 2: {状態} - タスク完了: {completed}/{total}
- ...

### Phase完了条件
- Phase 1: {checked}/{total} 項目
- Phase 2: {checked}/{total} 項目
- ...

## 💡 次に実行すべきコマンド

### 推奨: {コマンド名}

**コマンド**:
```
{実行すべきコマンド}
```

**理由**:
{なぜこのコマンドを実行すべきか}

**実行後**:
{このコマンド実行後に何が得られるか}

---

### 代替案（オプション）

**1. {代替コマンド名}**
```
{代替コマンド}
```
{理由と実行後の状態}

**2. {代替コマンド名}**
```
{代替コマンド}
```
{理由と実行後の状態}

---

## 📚 ワークフロー全体を確認したい場合

```
/sdd:help
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. 状態別の提案例

#### 状態1の場合（仕様書が存在しない）
**推奨**: `/sdd:create-specs`
- 理由: タスクの仕様書がまだ作成されていません
- 実行後: overview.md、specification.md、technical-details.mdが生成されます

#### 状態2の場合（仕様書は存在するが不完全）
**推奨**: `/sdd:clarify-spec {taskname}`
- 理由: 仕様書に{N}箇所の不明点があります
- 実行後: 不明点が明確化され、仕様が確定します

**代替案**:
1. `/sdd:contradiction-check {taskname}` - 仕様の整合性を先に確認
2. `/sdd:validate-feasibility {taskname}` - 実現可能性を先に検証

#### 状態3の場合（仕様書は完成しているがPhase計画書がない）
**推奨**: `/sdd:break-down-phase {taskname}`
- 理由: 仕様書は完成していますが、Phase別の実装計画がありません
- 実行後: specs/{taskname}/tasks/配下にPhase計画書が生成されます

#### 状態4の場合（Phase計画書は存在するが未着手）
**推奨**: `/sdd:implement-phase {taskname}`
- 理由: Phase計画書は作成されていますが、実装が開始されていません
- 実行後: Phase 1のタスク1から実装が開始されます

#### 状態5の場合（Phase実装中）
**推奨**: `/sdd:implement-phase {taskname} {current_phase}.{next_task}`
- 理由: Phase {current_phase}の実装が進行中です（{completed}/{total}タスク完了）
- 実行後: 次のタスク{next_task}の実装を続けます

**代替案**:
1. `/sdd:sync-specs` - 作業を中断する前に現在の進捗を仕様書に記録

#### 状態6の場合（Phase完了、検証待ち）
**推奨**: `/sdd:verify-phase {taskname} {phase}`
- 理由: Phase {phase}のすべてのタスクが完了しましたが、検証がまだです
- 実行後: Phase完了条件が検証され、問題があれば指摘されます

#### 状態7の場合（Phase検証済み、次Phaseあり）
**推奨**: `/sdd:implement-phase {taskname} {next_phase}.1`
- 理由: Phase {current_phase}が完了し、次のPhase {next_phase}に進めます
- 実行後: Phase {next_phase}の実装が開始されます

#### 状態8の場合（すべてのPhase完了）
```markdown
🎉 おめでとうございます！

タスク「{taskname}」のすべてのPhaseが完了しました。

## 完了したPhase
- Phase 1: {name} ✅
- Phase 2: {name} ✅
- Phase 3: {name} ✅
...

## 次のアクション
- プロジェクトのデプロイやリリース準備
- 新しいタスクの開始: `/sdd:create-specs`
```

## 注意事項

- **⚠️ 重要**: このコマンドは提案のみを行い、実際のコマンドは実行しません
- **⚠️ 重要**: 提案は現在のファイル状態から推測したものであり、必ずしも最適とは限りません
- 複数の選択肢がある場合、プロジェクトの状況に応じて判断してください
- Phase順序や依存関係を考慮して提案しますが、並行作業が可能な場合もあります
