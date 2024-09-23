#!/bin/bash

# エラーハンドリング関数
handle_error() {
    echo "エラーが発生しました: $1"
    echo "スクリプトを終了します。問題を解決してから再度実行してください。"
    exit 1
}

# 依存関係の問題を修正
echo "依存関係の問題を修正しています..."
sudo apt --fix-broken install -y || handle_error "依存関係の修正に失敗しました"

# システムの更新
echo "システムを更新しています..."
sudo apt update || handle_error "システムの更新に失敗しました"
sudo apt full-upgrade -y || handle_error "システムのアップグレードに失敗しました"

# 必要なパッケージのインストール
echo "必要なパッケージをインストールしています..."
sudo apt install -y python3-pip python3-venv python3-tk || handle_error "必要なパッケージのインストールに失敗しました"

# 仮想環境の作成
echo "Python仮想環境を作成しています..."
python3 -m venv ~/world_clock_env || handle_error "仮想環境の作成に失敗しました"

# 仮想環境をアクティベート
source ~/world_clock_env/bin/activate || handle_error "仮想環境のアクティベートに失敗しました"

# 仮想環境内でpytzをインストール
pip install pytz || handle_error "pytzのインストールに失敗しました"

# Pythonスクリプトの作成
echo "世界時計のPythonスクリプトを作成しています..."
cat > ~/world_clock.py << EOL
import tkinter as tk
from datetime import datetime
import pytz

def update_time():
    timezones = [
        ('本地時間', 'Local'),
        ('東京', 'Asia/Tokyo'),
        ('シンガポール', 'Asia/Singapore'),
        ('ジャカルタ', 'Asia/Jakarta'),
        ('ニューデリー', 'Asia/Kolkata'),
        ('カラチ', 'Asia/Karachi'),
        ('カサブランカ', 'Africa/Casablanca'),
        ('ニューヨーク', 'America/New_York'),
        ('サンパウロ', 'America/Sao_Paulo')
    ]
    
    for i, (city, tz) in enumerate(timezones):
        if tz == 'Local':
            time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        else:
            time = datetime.now(pytz.timezone(tz)).strftime('%Y-%m-%d %H:%M:%S')
        labels[i].config(text=f"{city}: {time}")
    
    root.after(1000, update_time)

root = tk.Tk()
root.title("World Clock")
root.attributes('-topmost', True)

labels = []
for i in range(9):
    label = tk.Label(root, font=('Arial', 12))
    label.pack(anchor='w')
    labels.append(label)

update_time()
root.mainloop()
EOL

# スクリプトに実行権限を付与
chmod +x ~/world_clock.py || handle_error "Pythonスクリプトに実行権限を付与できませんでした"

# 自動起動の設定
echo "自動起動の設定を行っています..."
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/world_clock.desktop << EOL
[Desktop Entry]
Type=Application
Exec=$HOME/world_clock_env/bin/python $HOME/world_clock.py
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=World Clock
Name=World Clock
Comment[en_US]=Display world clock
Comment=Display world clock
EOL

echo "セットアップが完了しました。"
echo "世界時計を今すぐ起動するには、以下のコマンドを実行してください："
echo "$HOME/world_clock_env/bin/python $HOME/world_clock.py"
echo "次回ログイン時から自動的に起動します。"
echo ""
echo "注意: 変更を完全に適用するには、手動でログアウトして再度ログインするか、"
echo "      またはGNOME Shellを再起動する必要があります。"
echo "GNOME Shellを再起動するには、Alt+F2を押してから'r'を入力し、Enterキーを押してください。"
echo "ただし、これにより現在の作業が中断される可能性があるため、"
echo "すべての作業を保存してから行ってください。"

# 仮想環境を非アクティブ化
deactivate