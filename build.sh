#!/usr/bin/env bash
set -e

SRC_DIR="src"
OUT_DIR="build"
JAR_NAME="dxrkfetch.jar"
MAIN_CLASS="Main"

mkdir -p "$OUT_DIR"

echo "[+] Compiling Java..."
javac -d "$OUT_DIR" "$SRC_DIR/$MAIN_CLASS.java"

echo "Main-Class: $MAIN_CLASS" > manifest.txt

echo "[+] Packaging JAR..."
jar cfm "$JAR_NAME" manifest.txt -C "$OUT_DIR" .

rm manifest.txt

echo "[✓] Built $JAR_NAME"
