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
