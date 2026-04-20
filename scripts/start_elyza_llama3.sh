#!/bin/bash
# 武士団 v11.5 - ELYZA Llama-3-8B 起動スクリプト
# port 8081 | オンデマンド | 日本語特化

SERVER="/home/myuser/llama.cpp/build/bin/llama-server"
MODEL="/home/myuser/Bushidan-Multi-Agent/models/elyza-llama3/Llama-3-ELYZA-JP-8B-q4_k_m.gguf"

[ ! -f "$SERVER" ] && echo "[ERROR] llama-server not found: $SERVER" && exit 1
[ ! -f "$MODEL"  ] && echo "[ERROR] Model not found: $MODEL" && exit 1

ulimit -l unlimited

echo "====================================="
echo "  🎌 ELYZA Llama-3-JP-8B (port 8081)"
echo "  Endpoint: http://192.168.11.239:8081"
echo "  ⚠️  Nemotron (port 8080) と同時起動でメモリ使用 ~27GB"
echo "====================================="

$SERVER \
    -m "$MODEL" \
    -c 4096 \
    -t 4 \
    -b 256 \
    --parallel 1 \
    --host 0.0.0.0 \
    --port 8081 \
    --chat-template llama3 \
    --mlock \
    --mmap
