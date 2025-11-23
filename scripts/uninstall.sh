#!/bin/bash

set -e

ROOT_DIR="$HOME/SLStools"
REPO_NAME="SLStools"

green=$(tput setaf 2)
red=$(tput setaf 1)
reset=$(tput sgr0)

check="✓"
cross="𐄂"
divider="⚒"

echo
echo "------------------------------"
echo "      REMOÇÃO SLStools $divider      "
echo "------------------------------"

# Remoção SLSsteam
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

# Remoção configuração SLSsteam
echo
echo "Removendo configuração do SLSsteam..."
CONFIG_SLSSTEAM="$HOME/.config/SLSsteam"
if [ -d "$CONFIG_SLSSTEAM" ]; then
    rm -rf "$CONFIG_SLSSTEAM"
    echo "${green}$check Configuração SLSsteam removida com sucesso${reset}"
else
    echo "${red}$cross Configuração SLSsteam não encontrada${reset}"
fi

# Remoção SLScheevo
echo
echo "Removendo SLScheevo..."
SLSCHEEVO_DIR="$ROOT_DIR/conquistas/SLScheevo"
if [ -d "$SLSCHEEVO_DIR" ]; then
    rm -rf "$SLSCHEEVO_DIR"
    echo "${green}$check SLScheevo removido com sucesso${reset}"
else
    echo "${red}$cross SLScheevo não está instalado${reset}"
fi

# Remoção do repositório SLStools
echo
echo "Removendo diretório $REPO_NAME..."
if [ -d "$ROOT_DIR" ]; then
    rm -rf "$ROOT_DIR"
    echo "${green}$check Diretório $REPO_NAME removido com sucesso${reset}"
else
    echo "${red}$cross Diretório $REPO_NAME não encontrado${reset}"
fi

# Remoção do atalho SLStools
echo
echo "Removendo atalho SLStools..."
SLSTOOLS_DESKTOP="$HOME/.local/share/applications/SLStools.desktop"
if [ -f "$SLSTOOLS_DESKTOP" ]; then
    rm -f "$SLSTOOLS_DESKTOP"
    echo "${green}$check Atalho SLStools removido com sucesso${reset}"
else
    echo "${red}$cross Atalho SLStools não encontrado${reset}"
fi

# Remoção do diretório SLStools em ~/.local/share
echo
echo "Removendo diretório SLStools de ~/.local/share..."
if [ -d "$HOME/.local/share/SLStools" ]; then
    rm -rf "$HOME/.local/share/SLStools"
    echo "${green}$check Diretório SLStools removido com sucesso${reset}"
else
    echo "${red}$cross Diretório SLStools não encontrado em ~/.local/share${reset}"
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

# Atualizar cache de atalhos e ícones
echo "Atualizando cache de atalhos e ícones..."
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true
fi

# Finalização
echo
echo "${green}$check SLSsteam, SLScheevo e SLStools foram removidos com sucesso${reset}"
echo "${green}$check Repositório $REPO_NAME foi removido com sucesso${reset}"
