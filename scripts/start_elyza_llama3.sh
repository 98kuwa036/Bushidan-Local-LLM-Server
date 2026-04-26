#!/bin/bash
# 武士団 v11.5 - ELYZA Llama-3-8B 起動スクリプト
# port 8081 | オンデマンド | 日本語特化

SERVER="/home/myuser/llama.cpp/build/bin/llama-server"
MODEL="/home/myuser/Bushidan-Multi-Agent/models/elyza-llama3/Llama-3-ELYZA-JP-8B-q4_k_m.gguf"

[ ! -x "$SERVER" ] && echo "[ERROR] llama-server not found or not executable: $SERVER" && exit 1
[ ! -f "$MODEL"  ] && echo "[ERROR] Model not found: $MODEL" && exit 1

if ! ulimit -l unlimited 2>/dev/null; then
    echo "[WARN] ulimit -l unlimited failed — starting without --mlock (performance may be reduced)"
    MLOCK_OPT=""
else
    MLOCK_OPT="--mlock"
fi

# デフォルトは localhost。LAN公開が必要な場合は HOST=0.0.0.0 で起動
HOST="${HOST:-127.0.0.1}"
PORT="${PORT:-8081}"

echo "====================================="
echo "  🎌 ELYZA Llama-3-JP-8B (port ${PORT})"
echo "  Endpoint: http://${HOST}:${PORT}"
echo "  ⚠️  Nemotron (port 8080) と同時起動でメモリ使用 ~27GB"
echo "====================================="

$SERVER \
    -m "$MODEL" \
    -c 4096 \
    -t 4 \
    -b 256 \
    --parallel 1 \
    --host "$HOST" \
    --port "$PORT" \
    --chat-template llama3 \
    ${MLOCK_OPT} \
    --mmap
