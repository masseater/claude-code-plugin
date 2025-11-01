#!/bin/bash

# Cursorコマンド配置スクリプト
# このスクリプトは、mutils と sdd の commands を ~/.cursor/commands/ に配置します

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.cursor/commands"

echo "🚀 Cursorコマンド配置スクリプトを開始します..."

# ターゲットディレクトリの作成
if [ ! -d "$TARGET_DIR" ]; then
    echo "📁 ディレクトリを作成: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# シンボリックリンクを作成する関数
create_symlinks() {
    local source_dir="$1"
    local prefix="$2"
    
    if [ ! -d "$source_dir" ]; then
        echo "⚠️  警告: ディレクトリが見つかりません: $source_dir"
        return
    fi
    
    echo "📦 処理中: $source_dir"
    
    # commands ディレクトリ内の全てのファイルをリンク
    for file in "$source_dir"/*; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local target_file="$TARGET_DIR/$filename"
            
            # 既存のリンクまたはファイルを削除
            if [ -L "$target_file" ] || [ -f "$target_file" ]; then
                echo "  🔄 既存のファイルを削除: $filename"
                rm "$target_file"
            fi
            
            # シンボリックリンクを作成
            ln -s "$file" "$target_file"
            echo "  ✅ リンク作成: $filename"
        elif [ -d "$file" ]; then
            local dirname=$(basename "$file")
            local target_subdir="$TARGET_DIR/$dirname"
            
            # サブディレクトリの処理
            if [ -L "$target_subdir" ] || [ -d "$target_subdir" ]; then
                echo "  🔄 既存のディレクトリを削除: $dirname"
                rm -rf "$target_subdir"
            fi
            
            # シンボリックリンクを作成
            ln -s "$file" "$target_subdir"
            echo "  ✅ ディレクトリリンク作成: $dirname"
        fi
    done
}

# mutils/commands を配置
if [ -d "$SCRIPT_DIR/mutils/commands" ]; then
    create_symlinks "$SCRIPT_DIR/mutils/commands" "mutils"
else
    echo "⚠️  警告: mutils/commands が見つかりません"
fi

# sdd/commands を配置
if [ -d "$SCRIPT_DIR/sdd/commands" ]; then
    create_symlinks "$SCRIPT_DIR/sdd/commands" "sdd"
else
    echo "⚠️  警告: sdd/commands が見つかりません"
fi

echo ""
echo "✨ 配置完了しました！"
echo "📍 配置先: $TARGET_DIR"
echo ""
echo "配置されたコマンド一覧:"
ls -la "$TARGET_DIR" | grep -v "^total" | tail -n +2

echo ""
echo "💡 Cursorを再起動してコマンドを有効化してください。"

