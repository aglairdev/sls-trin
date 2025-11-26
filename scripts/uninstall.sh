#!/bin/bash

set -e

ROOT_DIR="$(pwd)"
REPO_NAME="SLStools"

green=$(tput setaf 2)
red=$(tput setaf 1)
reset=$(tput sgr0)

check="✓"
cross="𐄂"
divider="⚒"

echo
echo "---------------------------------"
echo "      REMOÇÃO SLStools $divider      "
echo "---------------------------------"

# Remoção SLSsteam
echo
echo "Removendo SLSsteam..."
SLSSTEAM_DIR="$ROOT_DIR/SLSsteam"
if [ -d "$SLSSTEAM_DIR" ]; then
    cd "$SLSSTEAM_DIR"
    make clean >/dev/null 2>&1 || true
    chmod +x setup.sh
    ./setup.sh uninstall >/dev/null 2>&1 || true
    cd "$ROOT_DIR"
    rm -rf "$SLSSTEAM_DIR"
    echo "${green}$check SLSsteam removido com sucesso${reset}"
else
    echo "${red}$cross SLSsteam não está instalada${reset}"
fi

echo
echo "Removendo configuração do SLSsteam..."
CONFIG_SLSSTEAM="$HOME/.config/SLSsteam"
if [ -d "$CONFIG_SLSSTEAM" ]; then
    rm -rf "$CONFIG_SLSSTEAM"
    echo "${green}$check Configuração SLSsteam removida com sucesso${reset}"
else
    echo "${red}$cross Configuração SLSsteam não encontrada${reset}"
fi

# Remoção ACCELA
echo
echo "Removendo ACCELA..."
ACCELA_DIR="$HOME/.local/share/ACCELA"
ACCELA_DESKTOP="$HOME/.local/share/applications/accela.desktop"
ACCELA_ICON="$HOME/.local/share/icons/hicolor/256x256/apps/accela.png"

if [ -d "$ACCELA_DIR" ] || [ -f "$ACCELA_DESKTOP" ]; then
    rm -rf "$ACCELA_DIR"
    rm -f "$ACCELA_DESKTOP" "$ACCELA_ICON"
    if command -v gtk-update-icon-cache &>/dev/null; then
        gtk-update-icon-cache -f "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true
    fi
    if command -v update-desktop-database &>/dev/null; then
        update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
    fi
    echo "${green}$check ACCELA removida com sucesso${reset}"
else
    echo "${red}$cross ACCELA não está instalada${reset}"
fi

# Remoção SLSah
echo
echo "Removendo SLSah..."
SLSAH_DIR="$HOME/steam-schema-generator"
SLSAH_DESKTOP="$HOME/.local/share/applications/steam-schema-generator.desktop"

if [ -d "$SLSAH_DIR" ] || [ -f "$SLSAH_DESKTOP" ]; then
    rm -rf "$SLSAH_DIR"
    rm -f "$SLSAH_DESKTOP"
    if command -v update-desktop-database &>/dev/null; then
        update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
    fi
    echo "${green}$check SLSah removida com sucesso${reset}"
else
    echo "${red}$cross SLSah não está instalada${reset}"
fi

# Remoção SLScheevo
echo
echo "Removendo SLScheevo..."
SLSCHEEVO_DIR="$ROOT_DIR/SLScheevo"
if [ -d "$SLSCHEEVO_DIR" ]; then
    rm -rf "$SLSCHEEVO_DIR"
    echo "${green}$check SLScheevo removido com sucesso${reset}"
else
    echo "${red}$cross SLScheevo não está instalado${reset}"
fi

# Restaurar atalho padrão da Steam
echo
echo "Restaurando atalho padrão da Steam..."

STEAM_BIN="$(command -v steam || which steam || whereis -b steam | awk '{print $2}')"
DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/steam.desktop"

if [ -n "$STEAM_BIN" ]; then
    mkdir -p "$DESKTOP_DIR"
    cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Steam
Exec=$STEAM_BIN
Type=Application
Icon=steam
Categories=Game;
EOF
    update-desktop-database "$DESKTOP_DIR" >/dev/null 2>&1 || true
    echo "${green}$check Atalho da Steam restaurado com sucesso${reset}"
else
    echo "${red}$cross Steam não encontrada para restaurar atalho${reset}"
fi

# Remoção repositório
echo
echo "Removendo diretório $REPO_NAME..."
cd ..
rm -rf "$ROOT_DIR"
echo "${green}$check Diretório $REPO_NAME removido com sucesso${reset}"

# Finalização
echo
echo "${green}$check SLSsteam, ACCELA, SLSah e SLScheevo foram removidos com sucesso${reset}"
