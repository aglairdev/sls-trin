#!/usr/bin/env bash
set -euo pipefail

REQUIRED_PKGS=("git" "python3" "python3-venv" "python3-pip")
MISSING=()

for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v "${pkg%%-*}" &>/dev/null; then
        MISSING+=("$pkg")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    if command -v apt &>/dev/null; then
        sudo apt update -y >/dev/null 2>&1
        sudo apt install -y "${MISSING[@]}" >/dev/null 2>&1
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y "${MISSING[@]}" >/dev/null 2>&1
    elif command -v pacman &>/dev/null; then
        sudo pacman -Sy --needed "${MISSING[@]}" >/dev/null 2>&1
    else
        exit 1
    fi
fi

INSTALL_DIR="$HOME/steam-schema-generator"
REPO_URL="https://github.com/niwia/SLSah.git"
DESKTOP_ENTRY_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_ENTRY_DIR/steam-schema-generator.desktop"

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

if [ -d ".git" ]; then
    git reset --hard HEAD >/dev/null 2>&1
    git pull >/dev/null 2>&1
else
    git clone "$REPO_URL" . >/dev/null 2>&1
fi

if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

source .venv/bin/activate
pip install --upgrade pip >/dev/null 2>&1
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt >/dev/null 2>&1
fi
deactivate
chmod +x run.sh

if command -v gnome-terminal >/dev/null 2>&1; then
    TERMINAL="gnome-terminal --"
elif command -v konsole >/dev/null 2>&1; then
    TERMINAL="konsole -e"
elif command -v xfce4-terminal >/dev/null 2>&1; then
    TERMINAL="xfce4-terminal -e"
elif command -v x-terminal-emulator >/dev/null 2>&1; then
    TERMINAL="x-terminal-emulator -e"
else
    TERMINAL="bash -c"
fi

mkdir -p "$DESKTOP_ENTRY_DIR"

cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=Steam Schema Generator
Comment=Generate Steam schema files
Exec=$TERMINAL "$INSTALL_DIR/run.sh"
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=Utility;
EOL

chmod +x "$DESKTOP_FILE"

if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$DESKTOP_ENTRY_DIR" >/dev/null 2>&1 || true
fi
