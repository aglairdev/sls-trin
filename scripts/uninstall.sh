#!/bin/bash

set -e

ROOT_DIR="$HOME/Accela"
REPO_NAME="ACCELA"

green=$(tput setaf 2)
red=$(tput setaf 1)
reset=$(tput sgr0)

check="✓"
cross="𐄂"
divider="⚒"

echo
echo "------------------------------------------"
echo "      Desinstalação Accela $divider      "
echo "------------------------------------------"

echo
echo "Removendo SLSsteam..."
SLSSTEAM_DIR="$ROOT_DIR/scripts/SLSsteam"
if [ -d "$SLSSTEAM_DIR" ]; then
    cd "$SLSSTEAM_DIR"
    make clean >/dev/null 2>&1 || true
    chmod +x setup.sh
    ./setup.sh uninstall >/dev/null 2>&1 || true
    cd "$ROOT_DIR"
    rm -rf "$SLSSTEAM_DIR"
    echo "${green}$check SLSsteam removido com sucesso${reset}"
else
    echo "${red}$cross SLSsteam não está instalado${reset}"
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

echo
echo "Removendo Accela..."
ACCELA_DIR="$ROOT_DIR/ACCELA"
if [ -d "$ACCELA_DIR" ]; then
    rm -rf "$ACCELA_DIR"
    echo "${green}$check Accela removida com sucesso${reset}"
else
    echo "${red}$cross Accela não está instalada${reset}"
fi

echo
echo "Removendo SLScheevo..."
SLSCHEEVO_DIR="$ROOT_DIR/conquistas/SLScheevo"
if [ -d "$SLSCHEEVO_DIR" ]; then
    rm -rf "$SLSCHEEVO_DIR"
    echo "${green}$check SLScheevo removido com sucesso${reset}"
else
    echo "${red}$cross SLScheevo não está instalado${reset}"
fi

echo
echo "Removendo diretório $REPO_NAME..."
if [ -d "$ROOT_DIR" ]; then
    rm -rf "$ROOT_DIR"
    echo "${green}$check Diretório $REPO_NAME removido com sucesso${reset}"
else
    echo "${red}$cross Diretório $REPO_NAME não encontrado${reset}"
fi

echo
echo "Removendo atalho Accela..."
ACCELA_DESKTOP="$HOME/.local/share/applications/accela.desktop"
if [ -f "$ACCELA_DESKTOP" ]; then
    rm -f "$ACCELA_DESKTOP"
    echo "${green}$check Atalho Accela removido com sucesso${reset}"
else
    echo "${red}$cross Atalho Accela não encontrado${reset}"
fi

echo
echo "Removendo diretório Accela de ~/.local/share..."
if [ -d "$HOME/.local/share/ACCELA" ]; then
    rm -rf "$HOME/.local/share/ACCELA"
    echo "${green}$check Diretório Accela removido com sucesso${reset}"
else
    echo "${red}$cross Diretório Accela não encontrado em ~/.local/share${reset}"
fi

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

echo
echo "Removendo atalho steam-schema-generator..."
STEAM_SCHEMA_GENERATOR_DESKTOP="$HOME/.local/share/applications/steam-schema-generator.desktop"
if [ -f "$STEAM_SCHEMA_GENERATOR_DESKTOP" ]; then
    rm -f "$STEAM_SCHEMA_GENERATOR_DESKTOP"
    echo "${green}$check Atalho steam-schema-generator removido com sucesso${reset}"
else
    echo "${red}$cross Atalho steam-schema-generator não encontrado${reset}"
fi

echo
echo "Removendo diretório ~/steam-schema-generator..."
STEAM_SCHEMA_GENERATOR_DIR="$HOME/steam-schema-generator"
if [ -d "$STEAM_SCHEMA_GENERATOR_DIR" ]; then
    rm -rf "$STEAM_SCHEMA_GENERATOR_DIR"
    echo "${green}$check Diretório steam-schema-generator removido com sucesso${reset}"
else
    echo "${red}$cross Diretório steam-schema-generator não encontrado${reset}"
fi

echo "Atualizando cache de atalhos e ícones..."
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true
fi

echo
echo "${green}$check SLSsteam, Accela, SLSah, SLScheevo, Steamless, e steam-schema-generator foram removidos com sucesso${reset}"
