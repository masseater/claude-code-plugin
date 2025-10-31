---
description: すべてのspecの一覧とステータスを表示し、specs/status.mdに保存
---

# spec一覧とステータスの表示・保存

`specs/` ディレクトリ配下のすべてのタスクを走査し、各タスクの進捗状況を集計して `specs/status.md` に保存します。

## 実行手順

### 1. specs/ディレクトリの確認

- `specs/` ディレクトリの存在を確認
- 存在しない場合は、空のステータスファイルを作成して終了

### 2. タスク情報の収集

各タスクディレクトリ（`specs/*/`）について、以下の情報を収集：

**⚠️ 重要**: `specs/_archived/` 配下のタスクは完全に無視します（アーカイブ済みタスクはノイズ）

#### 2.1 基本情報の取得
- タスク名（ディレクトリ名）
- 最終更新日時（ディレクトリ内のすべてのファイルの最新mtime）

#### 2.2 仕様書の存在確認
- `overview.md` の存在
- `specification.md` の存在
- `technical-details.md` の存在

#### 2.3 Phase情報の取得

**overview.mdから**:
- プロジェクト概要（「## プロジェクト概要」セクションの「目的と背景」または最初の数行を簡潔に取得）
- Phase数
- 各Phaseの名前
- 各Phaseの状態（未着手/進行中/完了）

**tasks/ディレクトリから**:
- Phase計画書（`phase{N}-*.md`）の存在確認

#### 2.4 Phase進捗の集計

各Phase計画書（`specs/{taskname}/tasks/phase{N}-*.md`）から：

**タスク進捗**:
```markdown
## タスク一覧

| # | タスク名 | 状態 | TDD | 説明 |
|---|---------|------|-----|------|
| 1 | ... | ✅完了 | Green | ... |
| 2 | ... | 🔄進行中 | Red | ... |
| 3 | ... | ⬜未着手 | - | ... |
```

- 各タスクの状態を集計
  - ✅完了: 完了カウント +1
  - 🔄進行中: 進行中カウント +1
  - ⬜未着手: 未着手カウント +1

**Phase完了条件**:
```markdown
## Phase完了条件

- [x] 条件1
- [ ] 条件2
- [x] 条件3
```

- チェック済み（`[x]`）の数をカウント
- 全体の条件数をカウント

#### 2.5 タスク全体のステータス判定

以下のロジックでタスクのステータスを判定：

```
if 仕様書が存在しない:
  ステータス = "未着手"
else if すべてのPhaseが完了状態:
  ステータス = "完了"
else if いずれかのPhaseが進行中または完了:
  ステータス = "進行中"
else:
  ステータス = "未着手"
```

#### 2.6 次に実行すべきコマンドの判定

`/sdd:next-step` コマンドと同様のロジックで判定：

- 仕様書が存在しない → `/sdd:create-specs`
- 仕様書に「**不明**」がある → `/sdd:clarify-spec {taskname}`
- Phase計画書がない → `/sdd:break-down-phase {taskname}`
- Phase未着手 → `/sdd:implement-phase {taskname}`
- Phase進行中 → `/sdd:implement-phase {taskname} {phase}.{next_task}`
- Phase完了、未検証 → `/sdd:verify-phase {taskname} {phase}`
- Phase検証済み、次Phaseあり → `/sdd:implement-phase {taskname} {next_phase}.1`
- すべて完了 → `/sdd:archive-spec`

### 3. ステータスファイルの生成

#### 3.1 データのソート

1. ステータスでグループ化（未着手 → 進行中 → 完了）
2. 各グループ内で更新日時順（新しい順）にソート

#### 3.2 Markdown生成

以下のような形式でstatus.mdを生成します。

**フォーマット:**
```markdown
# SDD Spec Status

最終更新: {現在日時}

## 次に実施すべきこと

{進行中タスクがある場合: 全ての進行中タスクの次のコマンドをリスト表示}
{進行中タスクがない場合: 最初の未着手タスクの次のコマンド}
{全て完了の場合: アーカイブを促すメッセージ}

## タスク一覧

### 🔄 進行中

| タスク名 | Phase進捗 | 完了条件 | 最終更新 | 次のコマンド |
|---------|----------|---------|---------|-------------|
| {taskname} | P1: {completed}/{total}, P2: {completed}/{total} | P1: {checked}/{total} | YYYY-MM-DD | `/sdd:implement-phase {taskname} {phase}.{task}` |

### ⬜ 未着手

| タスク名 | Phase進捗 | 完了条件 | 最終更新 | 次のコマンド |
|---------|----------|---------|---------|-------------|
| {taskname} | - | - | YYYY-MM-DD | `/sdd:create-specs` |

### ✅ 完了

| タスク名 | Phase進捗 | 完了条件 | 最終更新 | 次のコマンド |
|---------|----------|---------|---------|-------------|
| {taskname} | P1: {total}/{total}, P2: {total}/{total} | P1: {total}/{total}, P2: {total}/{total} | YYYY-MM-DD | `/sdd:archive-spec` |

---

## 各タスクの詳細

### {taskname}
- **概要**: {overview.mdのプロジェクト概要から取得した簡単な説明}
- **ステータス**: 🔄 進行中
- **Phase 1**: ✅ {completed}/{total} タスク完了、📋 {checked}/{total} 完了条件達成
- **Phase 2**: ⬜ {completed}/{total} タスク完了、📋 {checked}/{total} 完了条件達成
- **最終更新**: YYYY-MM-DD HH:MM:SS
- **次のコマンド**: `/sdd:implement-phase {taskname} {phase}.{task}`

### {taskname}
...
```

**作成例:**
```markdown
# SDD Spec Status

最終更新: 2025-10-31 14:30:00

## 次に実施すべきこと

**user-authentication** タスクの続き:
```
/sdd:implement-phase user-authentication 1.4
```

**payment-integration** タスクの検証:
```
/sdd:verify-phase payment-integration 1
```

## タスク一覧

### 🔄 進行中

| タスク名 | Phase進捗 | 完了条件 | 最終更新 | 次のコマンド |
|---------|----------|---------|---------|-------------|
| user-authentication | P1: 3/5, P2: 0/4 | P1: 2/3 | 2025-10-30 | `/sdd:implement-phase user-authentication 1.4` |
| payment-integration | P1: 5/5, P2: 2/7 | P1: 3/3, P2: 0/5 | 2025-10-29 | `/sdd:verify-phase payment-integration 1` |

### ⬜ 未着手

| タスク名 | Phase進捗 | 完了条件 | 最終更新 | 次のコマンド |
|---------|----------|---------|---------|-------------|
| admin-dashboard | - | - | 2025-10-28 | `/sdd:create-specs` |

### ✅ 完了

| タスク名 | Phase進捗 | 完了条件 | 最終更新 | 次のコマンド |
|---------|----------|---------|---------|-------------|
| database-setup | P1: 4/4, P2: 6/6 | P1: 3/3, P2: 5/5 | 2025-10-27 | `/sdd:archive-spec` |

---

## 各タスクの詳細

### user-authentication
- **概要**: JWTベースのユーザー認証システムの実装
- **ステータス**: 🔄 進行中
- **Phase 1**: ✅ 3/5 タスク完了、📋 2/3 完了条件達成
- **Phase 2**: ⬜ 0/4 タスク完了、📋 0/5 完了条件達成
- **最終更新**: 2025-10-30 15:30:45
- **次のコマンド**: `/sdd:implement-phase user-authentication 1.4`

### payment-integration
- **概要**: Stripe決済システムの統合と定期課金機能の実装
- **ステータス**: 🔄 進行中
- **Phase 1**: ✅ 5/5 タスク完了、📋 3/3 完了条件達成（検証待ち）
- **Phase 2**: 🔄 2/7 タスク完了、📋 0/5 完了条件達成
- **最終更新**: 2025-10-29 10:15:22
- **次のコマンド**: `/sdd:verify-phase payment-integration 1`

### admin-dashboard
- **概要**: 管理者用のダッシュボード画面とユーザー管理機能
- **ステータス**: ⬜ 未着手
- **最終更新**: 2025-10-28 09:00:00
- **次のコマンド**: `/sdd:create-specs`

### database-setup
- **概要**: PostgreSQLデータベースの初期セットアップとマイグレーション
- **ステータス**: ✅ 完了
- **Phase 1**: ✅ 4/4 タスク完了、📋 3/3 完了条件達成
- **Phase 2**: ✅ 6/6 タスク完了、📋 5/5 完了条件達成
- **最終更新**: 2025-10-27 18:45:30
- **次のコマンド**: `/sdd:archive-spec`
```

**Phase進捗の表記**:
- `P1: 3/5` = Phase 1で3/5タスク完了
- `-` = Phase計画書未作成

**完了条件の表記**:
- `P1: 2/3` = Phase 1で2/3完了条件達成
- `-` = Phase計画書未作成

### 4. ファイルの保存

- `specs/status.md` に保存
- `specs/` ディレクトリが存在しない場合は作成

### 5. 完了メッセージの表示

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Specステータスを更新しました
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 保存先: specs/status.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## エラーハンドリング

### specs/ディレクトリが存在しない場合

```markdown
⚠️ specs/ディレクトリが見つかりません。

specs/ディレクトリを作成して、空のステータスファイルを生成します。
```

→ 空のステータスファイルを作成

```markdown
# SDD Spec Status

最終更新: {現在日時}

## タスク一覧

タスクがまだ作成されていません。

新しいタスクを作成するには:
\```
/sdd:create-specs
\```
```

### タスクディレクトリが空の場合

- ステータス: "未着手"
- 次のコマンド: `/sdd:create-specs`

### overview.mdが破損している場合

- エラーを記録しつつ、他のファイルから可能な限り情報を取得
- 次のコマンド: `/sdd:clarify-spec {taskname}` （修復を促す）

## 注意事項

- **⚠️ 重要**: このコマンドは読み取り専用です。既存のspecファイルは変更しません
- ステータスファイルは完全に再生成されます（手動編集は上書きされます）
- Phase進捗は各Phase計画書から自動計算されます
- 「次のコマンド」は推測であり、必ずしも最適とは限りません
- ファイルのmtimeを基に最終更新日時を判定するため、ファイルコピー時は正確でない場合があります
