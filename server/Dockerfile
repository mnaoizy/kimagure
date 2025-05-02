# -------- Build Stage --------
    FROM golang:1.23 as builder

    WORKDIR /app
    
    # 必要なパッケージをインストール
    RUN apt-get update && apt-get install -y wget ffmpeg bzip2
    
    # Praatをダウンロード
    RUN wget https://www.fon.hum.uva.nl/praat/praat6427_linux-intel64.tar.gz && \
        tar -xzf praat6427_linux-intel64.tar.gz && \
        mv praat /usr/local/bin/praat && \
        rm praat6427_linux-intel64.tar.gz
    
    # sherpa-onnxモデルをダウンロード
    RUN wget https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-paraformer-zh-2023-09-14.tar.bz2 && \
        tar -xjf sherpa-onnx-paraformer-zh-2023-09-14.tar.bz2 && \
        rm sherpa-onnx-paraformer-zh-2023-09-14.tar.bz2
    
    # sherpa-onnx C APIをダウンロード (必須)
    RUN wget https://github.com/k2-fsa/sherpa-onnx/releases/download/v1.11.3/sherpa-onnx-v1.11.3-linux-x64-shared.tar.bz2 && \
        tar -xjf sherpa-onnx-v1.11.3-linux-x64-shared.tar.bz2 && \
        mkdir -p /usr/local/sherpa-onnx/lib /usr/local/sherpa-onnx/include && \
        cp -r sherpa-onnx-v1.11.3-linux-x64-shared/lib/* /usr/local/sherpa-onnx/lib/ && \
        cp -r sherpa-onnx-v1.11.3-linux-x64-shared/include/* /usr/local/sherpa-onnx/include/ && \
        rm -rf sherpa-onnx-v1.11.3-linux-x64-shared*
    
    # Goモジュールをコピー
    COPY go.mod go.sum ./
    RUN go mod download
    
    # ソースコードをコピー
    COPY . .
    
    # ビルド (CGO必須)
    RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -o /app/server ./cmd/server
    
    # -------- Runtime Stage --------
    FROM debian:bookworm-slim
    
    WORKDIR /app
    
    # 必要なパッケージをインストール
    RUN apt-get update && \
        apt-get install -y \
            ffmpeg \
            libgtk-3-0 \
            libx11-6 \
            libglib2.0-0 \
            libpangocairo-1.0-0 \
            libcairo2 \
            libpango-1.0-0 \
            libharfbuzz0b \
            libatk1.0-0 \
            libgdk-pixbuf2.0-0 \
            libxrender1 \
            libxext6 \
            libsm6 \
            libice6 \            
            libc++1 \
            && rm -rf /var/lib/apt/lists/*
    
    # バイナリとモデルをコピー
    COPY --from=builder /app/server /app/server
    COPY --from=builder /usr/local/bin/praat /usr/local/bin/praat
    COPY --from=builder /app/praat /app/praat
    COPY --from=builder /app/sherpa-onnx-paraformer-zh-2023-09-14 /app/sherpa-onnx-paraformer-zh-2023-09-14

    # 重要: sherpa-onnx Cライブラリをランタイムにコピー
    COPY --from=builder /usr/local/sherpa-onnx/lib/* /usr/lib/
    
    # ライブラリパスをセットアップ
    RUN ldconfig
    
    # アップロードディレクトリを作成
    RUN mkdir -p /tmp/uploads && chmod 777 /tmp/uploads
    
    # ユーザー設定
    USER nobody:nogroup
    
    EXPOSE 8080
    
    # デバッグログを有効化
    ENV LOG_LEVEL=debug
    
    ENTRYPOINT ["/app/server"]