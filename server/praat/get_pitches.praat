form
    sentence audioFilePath: ""
endform

# オーディオファイルを読み込む
Read from file... 'audioFilePath$'
sound = selected("Sound")

# ピッチ抽出を実行
# 引数: Time step (s), Minimum pitch (Hz), Maximum pitch (Hz)
# 0 は Praat のデフォルト値を使用 (通常 0.01 または 0.005)
# 75Hz から 500Hz は一般的な音声範囲 (必要に応じて調整)
pitch = To Pitch: 0, 75, 500

# 全体の持続時間を取得
duration = Get total duration
# Praatのデフォルトタイムステップを取得 (より正確)
timeStep = Get time step

# 最初のフレームの中心時刻を取得
firstTime = Get time from frame number: 1
currentTime = firstTime

# ピッチ値を取得して標準出力に表示
while currentTime <= duration
    # Get value at time: time (s), unit ("Hertz", "semitones re 100 Hz", etc.), interpolation ("Linear", "None")
    pitchValue = Get value at time: currentTime, "Hertz", "Linear"
    if pitchValue = undefined
        # 未定義の場合は 0 または特定のマーカー (例: -1) を出力
        pitchValue = 0
    endif
    # 標準出力に数値のみを出力
    appendInfoLine: pitchValue
    currentTime += timeStep
endwhile

# オブジェクトを削除 (メモリ解放)
removeObject: sound, pitch
