#!/bin/bash
# 武士団 v11.5 - 隠密 Nemotron-3-Nano 起動スクリプト
# port 8080 | 常駐 | 機密・オフライン専用

SERVER="/home/myuser/llama.cpp/build/bin/llama-server"
MODEL="/home/myuser/Bushidan-Multi-Agent/models/nemotron/Nemotron-3-Nano-30B-A3B-Instruct-Q4_K_M.gguf"

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
PORT="${PORT:-8080}"

echo "====================================="
echo "  🥷 Nemotron-3-Nano (port ${PORT})"
echo "  Endpoint: http://${HOST}:${PORT}"
echo "====================================="

$SERVER \
    -m "$MODEL" \
    -c 8192 \
    -t 4 \
    -b 512 \
    --parallel 1 \
    --host "$HOST" \
    --port "$PORT" \
    ${MLOCK_OPT} \
    --mmap
