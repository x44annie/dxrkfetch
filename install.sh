#!/bin/bash

# Check if javac is available
if ! command -v javac >/dev/null 2>&1; then
  echo "[!] JDK not found. Installing..."

  OS="$(uname)"

  if [[ "$OS" == "Darwin" ]]; then
    # macOS
    if command -v brew >/dev/null 2>&1; then
      brew install openjdk
    else
      echo "[x] Homebrew not found. Please install JDK manually from https://adoptium.net/"
      exit 1
    fi

  elif [[ "$OS" == "Linux" ]]; then
    # Linux: detect package manager and distro specifics

    # Detect if running NixOS (by presence of /etc/NIXOS or nix command)
    if command -v nix-env >/dev/null 2>&1; then
      echo "[i] Detected Nix package manager (likely NixOS)"
      nix-env -iA nixpkgs.openjdk
      exit $?

    elif command -v apt >/dev/null 2>&1; then
      # Debian, Ubuntu, Kali
      echo "[i] Using apt package manager"
      sudo apt update
      sudo apt install -y default-jdk

    elif command -v dnf >/dev/null 2>&1; then
      # Fedora, newer RedHat-based
      echo "[i] Using dnf package manager"
      sudo dnf install -y java-11-openjdk-devel

    elif command -v yum >/dev/null 2>&1; then
      # Older RedHat, CentOS
      echo "[i] Using yum package manager"
      sudo yum install -y java-11-openjdk-devel

    elif command -v pacman >/dev/null 2>&1; then
      # Arch Linux
      echo "[i] Using pacman package manager"
      sudo pacman -Sy --noconfirm jdk-openjdk

    elif command -v slackpkg >/dev/null 2>&1; then
      # Slackware uses slackpkg
      echo "[i] Using slackpkg package manager"
      sudo slackpkg update
      sudo slackpkg install openjdk

    else
      echo "[x] Unknown Linux package manager. Please install JDK manually."
      exit 1
    fi

  else
    echo "[x] Unsupported OS. Please install Java manually."
    exit 1
  fi

else
  echo "[✓] JDK found: $(javac -version)"
fi

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
