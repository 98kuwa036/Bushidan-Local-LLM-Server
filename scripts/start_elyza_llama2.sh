#!/bin/bash
# 武士団 v11.5 - ELYZA Llama-2-7b 起動スクリプト
# port 8081 | オンデマンド | 日本語フォールバック

SERVER="/home/myuser/llama.cpp/build/bin/llama-server"
MODEL="/home/myuser/Bushidan-Multi-Agent/models/elyza-llama2/ELYZA-japanese-Llama-2-7b-instruct-q4_k_m.gguf"

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
echo "  🎌 ELYZA Llama-2-7b (port ${PORT})"
echo "  Endpoint: http://${HOST}:${PORT}"
echo "====================================="

$SERVER \
    -m "$MODEL" \
    -c 4096 \
    -t 4 \
    -b 256 \
    --parallel 1 \
    --host "$HOST" \
    --port "$PORT" \
    ${MLOCK_OPT} \
    --mmap
