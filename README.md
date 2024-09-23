# World Clock App And Installer
　　
## 1. 必要なパッケージのインストール

```bash
sudo apt update
sudo apt install -y python3-pip python3-venv python3-tk
```

## 2. 仮想環境の作成とアクティベート

```bash
python3 -m venv ~/world_clock_env
source ~/world_clock_env/bin/activate
```

## 3. 必要なPythonパッケージのインストール

```bash
pip install pytz
```

## 4. Pythonスクリプトの作成

以下の内容で `~/world-clock-python-script.py` ファイルを作成します：

```python
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
```

## 5. スクリプトに実行権限を付与

```bash
chmod +x ~/world-clock-python-script.py
```

## 6. 自動起動の設定

`~/.config/autostart/world-clock-python-script.py.desktop` ファイルを作成し、以下の内容を記述します：

```ini
[Desktop Entry]
Type=Application
Exec=/home/USERNAME/world_clock_env/bin/python /home/USERNAME/world_clock.py
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=World Clock
Name=World Clock
Comment[en_US]=Display world clock
Comment=Display world clock
```

注意: `USERNAME` を実際のユーザー名に置き換えてください。

## 7. 自動起動ファイルに実行権限を付与

```bash
chmod +x ~/.config/autostart/world-clock-python-script.py.desktop
```

## 8. アプリケーションの実行（即時起動の場合）

```bash
~/world_clock_env/bin/python ~/world-clock-python-script.py &
```

## 9. 仮想環境の非アクティブ化（オプション）

```bash
deactivate
```

これで設定は完了です。次回ログイン時から世界時計が自動的に起動します。即座に起動したい場合は、手順8のコマンドを使用してください。
