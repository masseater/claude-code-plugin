#!/bin/bash

# Cursorコマンド配置スクリプト
# このスクリプトは、mutils と sdd の commands を ~/.cursor/commands/ に配置します
# WSL環境では --wsl オプションでWindows側のパスにリンクを作成できます

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.cursor/commands"
WSL_MODE=false
WSL_USER=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --wsl)
            WSL_MODE=true
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                WSL_USER="$2"
                shift
            fi
            shift
            ;;
        *)
            echo "不明なオプション: $1"
            echo "使用方法: $0 [--wsl [windows-username]]"
            exit 1
            ;;
    esac
done

if [ "$WSL_MODE" = true ]; then
    if [ -z "$WSL_USER" ]; then
        if [ -n "$WSLENV" ] && [ -n "$USERPROFILE" ]; then
            WSL_USER=$(basename "$USERPROFILE" 2>/dev/null || echo "")
        fi
        if [ -z "$WSL_USER" ]; then
            echo "⚠️  警告: Windowsユーザー名を指定してください"
            echo "使用方法: $0 --wsl <windows-username>"
            exit 1
        fi
    fi
    TARGET_DIR="/mnt/c/Users/$WSL_USER/.cursor/commands"
fi

echo "🚀 Cursorコマンド配置スクリプトを開始します..."

# ターゲットディレクトリの作成
if [ ! -d "$TARGET_DIR" ]; then
    echo "📁 ディレクトリを作成: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# WSLパスをWindows側から見えるパスに変換する関数
convert_to_windows_path() {
    local wsl_path="$1"
    if [ "$WSL_MODE" = true ]; then
        local windows_path=$(wslpath -w "$wsl_path" 2>/dev/null)
        if [ -n "$windows_path" ]; then
            echo "$windows_path"
        else
            echo "$wsl_path"
        fi
    else
        echo "$wsl_path"
    fi
}

# Windows側でシンボリックリンクを作成する関数
create_windows_symlink() {
    local target_path="$1"
    local source_path="$2"
    local item_type="$3"
    
    local target_win=$(wslpath -w "$target_path" 2>/dev/null)
    local source_win=$(wslpath -w "$source_path" 2>/dev/null)
    
    if [ -z "$target_win" ] || [ -z "$source_win" ]; then
        return 1
    fi
    
    if [ "$item_type" = "directory" ]; then
        powershell.exe -Command "New-Item -ItemType SymbolicLink -Path '$target_win' -Target '$source_win' -Force" 2>/dev/null
    else
        powershell.exe -Command "New-Item -ItemType SymbolicLink -Path '$target_win' -Target '$source_win' -Force" 2>/dev/null
    fi
}

# シンボリックリンクを作成する関数
create_symlinks() {
    local source_dir="$1"
    local prefix="$2"
    
    if [ ! -d "$source_dir" ]; then
        echo "⚠️  警告: ディレクトリが見つかりません: $source_dir"
        return
    fi
    
    echo "📦 処理中: $source_dir"
    
    local prefix_dir="$TARGET_DIR/$prefix"
    if [ -L "$prefix_dir" ]; then
        rm -f "$prefix_dir"
    fi
    if [ ! -d "$prefix_dir" ]; then
        mkdir -p "$prefix_dir"
    fi
    
    for item in "$source_dir"/*; do
        [ -e "$item" ] || continue
        
        local itemname=$(basename "$item")
        local target_path="$prefix_dir/$itemname"
        
        if [ -f "$item" ]; then
            if [ -L "$target_path" ] || [ -f "$target_path" ]; then
                echo "  🔄 既存のファイルを削除: $itemname"
                rm -f "$target_path"
            fi
            
            local source_path=$(realpath "$item" 2>/dev/null || echo "$item")
            if [ "$WSL_MODE" = true ]; then
                if create_windows_symlink "$target_path" "$source_path" "file"; then
                    echo "  ✅ リンク作成: $itemname"
                else
                    echo "  ⚠️  リンク作成失敗: $itemname"
                fi
            else
                ln -s "$source_path" "$target_path"
                echo "  ✅ リンク作成: $itemname"
            fi
        elif [ -d "$item" ]; then
            if [ -L "$target_path" ]; then
                echo "  🔄 既存のディレクトリリンクを削除: $itemname"
                rm -f "$target_path"
            elif [ -d "$target_path" ]; then
                echo "  🔄 既存のディレクトリを削除: $itemname"
                rm -rf "$target_path"
            fi
            
            local source_path=$(realpath "$item" 2>/dev/null || echo "$item")
            if [ "$WSL_MODE" = true ]; then
                if create_windows_symlink "$target_path" "$source_path" "directory"; then
                    echo "  ✅ ディレクトリリンク作成: $itemname"
                else
                    echo "  ⚠️  ディレクトリリンク作成失敗: $itemname"
                fi
            else
                ln -s "$source_path" "$target_path"
                echo "  ✅ ディレクトリリンク作成: $itemname"
            fi
        fi
    done
}

# 古いファイルを削除（mutils/sdd ディレクトリ構造に移行するため）
echo "🧹 古いファイルをクリーンアップ中..."
if [ "$WSL_MODE" = true ]; then
    target_win=$(wslpath -w "$TARGET_DIR" 2>/dev/null)
    if [ -n "$target_win" ]; then
        powershell.exe -Command "Get-ChildItem '$target_win' | Where-Object { \$_.Name -notin @('mutils', 'sdd') } | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue" 2>/dev/null
    fi
else
    for item in "$TARGET_DIR"/*; do
        [ -e "$item" ] || continue
        itemname=$(basename "$item")
        if [ "$itemname" != "mutils" ] && [ "$itemname" != "sdd" ]; then
            if [ -f "$item" ] || [ -L "$item" ] || [ -d "$item" ]; then
                echo "  🗑️  削除: $itemname"
                rm -rf "$item"
            fi
        fi
    done
fi

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

