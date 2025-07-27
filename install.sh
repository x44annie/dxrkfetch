#!/bin/bash

set -e

JAR_URL="https://github.com/404femme/dxrkfetch/releases/latest/download/dxrkfetch.jar"
INSTALL_DIR="/usr/local/lib/dxrkfetch"
BIN_DIR="/usr/local/bin"
LAUNCHER="$BIN_DIR/dxrkfetch"

# Check if JDK is installed via javac
if ! command -v javac >/dev/null 2>&1; then
  echo "[!] JDK not found. Installing..."
  OS="$(uname)"

  case "$OS" in
    Darwin)
      # macOS
      if command -v brew >/dev/null 2>&1; then
        brew install openjdk
      else
        echo "[x] Homebrew not found. Please install JDK manually from https://adoptium.net/"
        exit 1
      fi
      ;;

    Linux)
      # Detect Linux package manager
      if command -v nix-env >/dev/null 2>&1; then
        echo "[i] Detected Nix package manager"
        nix-env -iA nixpkgs.openjdk

      elif command -v apt >/dev/null 2>&1; then
        sudo apt update
        sudo apt install -y default-jdk

      elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y java-11-openjdk-devel

      elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y java-11-openjdk-devel

      elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm jdk-openjdk

      elif command -v slackpkg >/dev/null 2>&1; then
        sudo slackpkg update
        sudo slackpkg install openjdk

      else
        echo "[x] Unsupported package manager. Install JDK manually."
        exit 1
      fi
      ;;

    *)
      echo "[x] Unsupported OS: $OS"
      exit 1
      ;;
  esac
else
  echo "[✓] JDK found: $(javac -version 2>&1 | head -n1)"
fi

echo "[+] Downloading dxrkfetch.jar..."
sudo mkdir -p "$INSTALL_DIR"
sudo curl -sSL "$JAR_URL" -o "$INSTALL_DIR/dxrkfetch.jar"

echo "[+] Creating launcher at $LAUNCHER..."
sudo tee "$LAUNCHER" > /dev/null <<EOF
#!/bin/bash
exec java -jar "$INSTALL_DIR/dxrkfetch.jar" "\$@"
EOF
sudo chmod +x "$LAUNCHER"

echo "[✓] Installation complete!"
echo "    Run command: dxrkfetch"