---
argument-hint: ""
---

# 完了または不要になったspecsをアーカイブします

specs/配下のタスクを一覧表示し、選択したタスクを`specs/_archived/`ディレクトリに移動します。アーカイブ理由はoverview.mdのPhase statusから自動判定します。

## 実行手順

### 1. タスク一覧の取得
1. `specs/`ディレクトリが存在するか確認
2. 存在しない場合、エラーメッセージを表示して終了
3. `specs/`配下のディレクトリ一覧を取得（`_archived`を除外）
4. タスクが存在しない場合、「アーカイブ可能なタスクがありません」と表示して終了

### 2. 各タスクの状態確認とアーカイブ理由の判定
各タスクについて以下を実行:

1. `specs/[taskname]/overview.md`を読み込む
2. 各Phaseの「**状態**:」フィールドを抽出
3. アーカイブ理由を自動判定:
   - **全Phase「完了」の場合** → アーカイブ理由: `完了`
   - **いずれかのPhaseが「保留」の場合** → アーカイブ理由: `保留`
   - **その他（未着手/進行中が残っている場合）** → アーカイブ理由: `却下`
4. `overview.md`が存在しない、またはPhase情報が取得できない場合 → アーカイブ理由: `不明`

### 3. AskUserQuestionツールでタスクを選択
1. タスク一覧を「タスク名（理由）」の形式で表示
   - 例: `user-authentication（完了）`、`payment-integration（保留）`
2. ユーザーに選択させる
3. 選択されたタスク名とアーカイブ理由を取得

### 4. アーカイブディレクトリの準備
1. `specs/_archived/`ディレクトリが存在するか確認
2. 存在しない場合、作成する
3. `specs/_archived/[taskname]/`が既に存在する場合、エラーメッセージを表示して終了
   - エラーメッセージ: 「既にアーカイブされています: specs/_archived/[taskname]/」

### 5. Gitリポジトリの確認と移動
1. `git rev-parse --is-inside-work-tree`を実行して確認
2. 成功した場合（Gitリポジトリ内）:
   - `git mv specs/[taskname] specs/_archived/[taskname]`を実行
   - コミットメッセージ: `Archive spec: [taskname] ([理由])`
3. 失敗した場合（Gitリポジトリ外）:
   - `mv specs/[taskname] specs/_archived/[taskname]`を実行

### 6. Gitコミット（Gitリポジトリの場合のみ）
Gitリポジトリ内の場合:
```bash
git commit -m "$(cat <<'EOF'
Archive spec: [taskname] ([理由])

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### 7. 完了報告
以下を報告:
- アーカイブ先パス: `specs/_archived/[taskname]/`
- アーカイブ理由: [完了/保留/却下/不明]
- Phase状態のサマリー

## エラーハンドリング

### specs/ディレクトリが存在しない場合
```
エラー: specs/ディレクトリが見つかりません
```

### アーカイブ可能なタスクがない場合
```
アーカイブ可能なタスクがありません
```

### 既にアーカイブされている場合
```
エラー: タスク「[taskname]」は既にアーカイブされています
specs/_archived/[taskname]/ が既に存在します
```

## 注意事項
- アーカイブしたタスクを復元する場合は、手動で`git mv specs/_archived/[taskname] specs/[taskname]`を実行してください（Gitの場合）
- アーカイブ理由は各Phaseの状態から自動判定されます
- 既にアーカイブされているタスクは上書きできません
