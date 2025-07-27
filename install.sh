#!/usr/bin/env bash
set -e

PREFIX="/usr/local"
BINDIR="$PREFIX/bin"
LIBDIR="$PREFIX/lib/dxrkfetch"
JAR_NAME="dxrkfetch.jar"
LAUNCHER="$BINDIR/dxrkfetch"

echo "[+] Installing dxrkfetch..."

sudo mkdir -p "$LIBDIR"
sudo mkdir -p "$BINDIR"
sudo cp "$JAR_NAME" "$LIBDIR"

sudo tee "$LAUNCHER" > /dev/null <<EOF
#!/usr/bin/env bash
exec java -jar "$LIBDIR/$JAR_NAME" "\$@"
EOF

sudo chmod +x "$LAUNCHER"

echo "[✓] Installed: $LAUNCHER"
echo "Run with: dxrkfetch"
