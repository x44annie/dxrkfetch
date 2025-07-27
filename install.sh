#!/bin/bash

set -e

JAR_URL="https://github.com/404femme/dxrkfetch/releases/latest/download/dxrkfetch.jar"
INSTALL_DIR="/usr/local/lib/dxrkfetch"
BIN_DIR="/usr/local/bin"
LAUNCHER="$BIN_DIR/dxrkfetch"

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

echo "[+] Downloading dxrkfetch.jar..."
sudo mkdir -p "$INSTALL_DIR"
sudo curl -sSL "$JAR_URL" -o "$INSTALL_DIR/dxrkfetch.jar"

echo "[+] Creating launcher at $LAUNCHER_PATH..."
sudo tee "$LAUNCHER_PATH" > /dev/null <<'EOF'
#!/usr/bin/env bash
exec java -jar "/usr/local/lib/dxrkfetch/dxrkfetch.jar" "$@"
EOF
sudo chmod +x "$LAUNCHER_PATH"

echo "[✓] Installation complete!"
echo "    You can now run: dxrkfetch"