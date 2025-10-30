#!/usr/bin/env bash
set -euo pipefail

# ==============================
# SLSah Universal Installer
# ==============================

clear
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " 🚀  INICIANDO A INSTALAÇÃO DO SLSah  (Steam Schema Generator)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ------------------------------
# 1️⃣ Checagem e instalação de dependências
# ------------------------------

REQUIRED_PKGS=("git" "python3" "python3-venv" "python3-pip")
MISSING=()

for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v "${pkg%%-*}" &>/dev/null; then
        MISSING+=("$pkg")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo ""
    echo "⚠️  Dependências ausentes:"
    for p in "${MISSING[@]}"; do
        echo "   • $p"
    done
    echo ""
    read -rp "Deseja instalá-las agora? (s/n): " ANSWER
    echo ""
    if [[ "$ANSWER" =~ ^[sS]$ ]]; then
        if command -v apt &>/dev/null; then
            echo "📦 Instalando com apt..."
            sudo apt update -y && sudo apt install -y "${MISSING[@]}"
        elif command -v dnf &>/dev/null; then
            echo "📦 Instalando com dnf..."
            sudo dnf install -y "${MISSING[@]}"
        elif command -v pacman &>/dev/null; then
            echo "📦 Instalando com pacman..."
            sudo pacman -Sy --needed "${MISSING[@]}"
        else
            echo "❌ Não foi possível detectar o gerenciador de pacotes."
            echo "Instale manualmente: ${MISSING[*]}"
            exit 1
        fi
    else
        echo "❌ Instalação cancelada. As dependências são obrigatórias."
        exit 1
    fi
else
    echo ""
    echo "✅ Todas as dependências estão instaladas."
fi

echo ""
sleep 1

# ------------------------------
# 2️⃣ Instalação do SLSah
# ------------------------------

INSTALL_DIR="$HOME/steam-schema-generator"
REPO_URL="https://github.com/niwia/SLSah.git"
DESKTOP_ENTRY_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_ENTRY_DIR/steam-schema-generator.desktop"

echo ""
echo "📂 Diretório de instalação: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

if [ -d ".git" ]; then
    echo ""
    echo "📥 Atualizando repositório existente..."
    git reset --hard HEAD
    git pull
else
    echo ""
    echo "📥 Clonando repositório..."
    git clone "$REPO_URL" .
fi

# ------------------------------
# 3️⃣ Ambiente virtual Python
# ------------------------------

if [ ! -d ".venv" ]; then
    echo ""
    echo "🐍 Criando ambiente virtual Python..."
    python3 -m venv .venv
fi

echo ""
echo "📦 Instalando dependências Python..."
source .venv/bin/activate
pip install --upgrade pip >/dev/null 2>&1
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt >/dev/null 2>&1
fi
deactivate
chmod +x run.sh

# ------------------------------
# 4️⃣ Detectar terminal e criar atalho
# ------------------------------

echo ""
echo "🖥️ Detectando terminal disponível..."
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

echo ""
echo "🖇️ Criando atalho de aplicativo..."
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

# ------------------------------
# ✅ Finalização
# ------------------------------

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅  Instalação concluída com sucesso!"
echo ""
echo "📁  Local do SLSah: $INSTALL_DIR"
echo ""
echo "🚀  Execute via menu ou com o comando:"
echo "    $INSTALL_DIR/run.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
