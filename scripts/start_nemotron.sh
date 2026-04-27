#!/bin/bash
# 武士団 v18 - Nemotron-3-Nano 起動スクリプト
# port 8080 | 常駐 | 機密・オフライン専用
set -euo pipefail

SERVER="${LLAMA_SERVER_PATH:-${HOME}/llama.cpp/build/bin/llama-server}"
MODEL="${NEMOTRON_MODEL_PATH:-${HOME}/Bushidan-Multi-Agent/models/nemotron/Nemotron-3-Nano-30B-A3B-Instruct-Q4_K_M.gguf}"
HOST="${HOST:-127.0.0.1}"
PORT="${PORT:-8080}"
N_THREADS="${N_THREADS:-$(nproc 2>/dev/null || echo 4)}"
PID_FILE="${PID_FILE:-/tmp/nemotron.pid}"

[ ! -x "$SERVER" ] && echo "[ERROR] llama-server not found or not executable: $SERVER" && exit 1
[ ! -f "$MODEL"  ] && echo "[ERROR] Model not found: $MODEL" && exit 1

# 二重起動防止
if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "[WARN] Nemotron is already running (PID $(cat "$PID_FILE")). Exiting."
    exit 1
fi

# mlock 設定 (--mmap と排他)
if ulimit -l unlimited 2>/dev/null; then
    MLOCK_OPT="--mlock"
    MMAP_OPT=""
else
    echo "[WARN] ulimit -l unlimited failed — starting without --mlock (performance may be reduced)"
    MLOCK_OPT=""
    MMAP_OPT="--mmap"
fi

# シグナルハンドラ (graceful shutdown)
cleanup() {
    echo "[INFO] Shutting down Nemotron..."
    rm -f "$PID_FILE"
}
trap cleanup EXIT INT TERM

echo "====================================="
echo "  🥷 Nemotron-3-Nano (port ${PORT})"
echo "  Endpoint: http://${HOST}:${PORT}"
echo "  Threads:  ${N_THREADS}"
echo "====================================="

"$SERVER" \
    -m "$MODEL" \
    -c 8192 \
    -t "$N_THREADS" \
    -b 512 \
    --parallel 1 \
    --host "$HOST" \
    --port "$PORT" \
    ${MLOCK_OPT} \
    ${MMAP_OPT} &

echo $! > "$PID_FILE"
echo "[INFO] Started with PID $(cat "$PID_FILE")"
wait
