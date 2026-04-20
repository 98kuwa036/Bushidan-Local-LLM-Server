#!/bin/bash
# 武士団 v11.5 - 隠密 Nemotron-3-Nano 起動スクリプト
# port 8080 | 常駐 | 機密・オフライン専用

SERVER="/home/myuser/llama.cpp/build/bin/llama-server"
MODEL="/home/myuser/Bushidan-Multi-Agent/models/nemotron/Nemotron-3-Nano-30B-A3B-Instruct-Q4_K_M.gguf"

[ ! -f "$SERVER" ] && echo "[ERROR] llama-server not found: $SERVER" && exit 1
[ ! -f "$MODEL"  ] && echo "[ERROR] Model not found: $MODEL" && exit 1

ulimit -l unlimited

echo "====================================="
echo "  🥷 Nemotron-3-Nano (port 8080)"
echo "  Endpoint: http://192.168.11.239:8080"
echo "====================================="

$SERVER \
    -m "$MODEL" \
    -c 8192 \
    -t 4 \
    -b 512 \
    --parallel 1 \
    --host 0.0.0.0 \
    --port 8080 \
    --mlock \
    --mmap
