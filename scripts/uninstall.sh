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
echo "|------------------------------|"
echo "      REMOÇÃO SLStools $divider      "
echo "|------------------------------|"

echo
echo "Removendo SLSsteam..."
SLSSTEAM_DIR="$ROOT_DIR/scripts/SLSsteam"
if [ -d "$SLSSTEAM_DIR" ]; then
    cd "$SLSSTEAM_DIR"
    make clean >/dev/null 2>&1 || true
    chmod +x setup.sh
    ./setup.sh uninstall >/dev/null 2>&1 || true
    cd "$ROOT_DIR" 2>/dev/null || true
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
echo "Removendo atalho SLStools..."
SLSTOOLS_DESKTOP="$HOME/.local/share/applications/SLStools.desktop"
if [ -f "$SLSTOOLS_DESKTOP" ]; then
    rm -f "$SLSTOOLS_DESKTOP"
    echo "${green}$check Atalho SLStools removido com sucesso${reset}"
else
    echo "${red}$cross Atalho SLStools não encontrado${reset}"
fi

echo
echo "Removendo diretório SLStools de ~/.local/share..."
if [ -d "$HOME/.local/share/SLStools" ]; then
    rm -rf "$HOME/.local/share/SLStools"
    echo "${green}$check Diretório SLStools removido com sucesso${reset}"
else
    echo "${red}$cross Diretório SLStools não encontrado em ~/.local/share${reset}"
fi

echo
echo "Restaurando atalho padrão da Steam..."

STEAM_BIN="$(command -v steam 2>/dev/null || which steam 2>/dev/null || whereis -b steam 2>/dev/null | awk '{print $2}' 2>/dev/null || true)"
DESKTOP_DIR_APPS="$HOME/.local/share/applications"
DESKTOP_FILE_APPS="$DESKTOP_DIR_APPS/steam.desktop"

if [ -n "$STEAM_BIN" ]; then
    mkdir -p "$DESKTOP_DIR_APPS"
    cat > "$DESKTOP_FILE_APPS" <<EOF
[Desktop Entry]
Name=Steam
Exec=$STEAM_BIN %U
Type=Application
Icon=steam
Categories=Game;
Terminal=false
EOF
    chmod 644 "$DESKTOP_FILE_APPS" || true
    if command -v gio >/dev/null 2>&1; then
        gio set "$DESKTOP_FILE_APPS" "metadata::trusted" true >/dev/null 2>&1 || true
    fi
    echo "${green}$check Atalho da Steam restaurado em $DESKTOP_DIR_APPS${reset}"
else
    echo "${red}$cross Steam não encontrada para restaurar atalho${reset}"
fi

find_desktop_dir() {
    local d
    if command -v xdg-user-dir >/dev/null 2>&1; then
        d="$(xdg-user-dir DESKTOP 2>/dev/null || true)"
        if [ -n "$d" ] && [ -d "$d" ]; then
            echo "$d"
            return
        fi
    fi
    local candidates=("Desktop" "desktop" "Área de trabalho" "Área de Trabalho" "Área de trabalho" "Área de trabalho")
    for name in "${candidates[@]}"; do
        if [ -d "$HOME/$name" ]; then
            echo "$HOME/$name"
            return
        fi
    done
    for d in "$HOME"/*; do
        if [ -d "$d" ]; then
            local base="$(basename "$d")"
            local lower="$(echo "$base" | tr '[:upper:]' '[:lower:]' | iconv -f utf8 -t ascii//TRANSLIT 2>/dev/null || true)"
            if [[ "$lower" == *desktop* ]] || ([[ "$lower" == *area* ]] && [[ "$lower" == *trabalho* ]]); then
                echo "$d"
                return
            fi
        fi
    done
    echo "$HOME/Desktop"
}

DESKTOP_DIR_USER="$(find_desktop_dir)"
mkdir -p "$DESKTOP_DIR_USER"

DESKTOP_FILE_USER="$DESKTOP_DIR_USER/steam.desktop"

if [ -n "$STEAM_BIN" ]; then
    cp "$DESKTOP_FILE_APPS" "$DESKTOP_FILE_USER"
    chmod 644 "$DESKTOP_FILE_USER" || true
    if command -v gio >/dev/null 2>&1; then
        gio set "$DESKTOP_FILE_USER" "metadata::trusted" true >/dev/null 2>&1 || true
    fi
    chmod a+x "$DESKTOP_FILE_USER" >/dev/null 2>&1 || true
    echo "${green}$check Atalho da Steam criado/atualizado na área de trabalho em $DESKTOP_DIR_USER${reset}"
else
    echo "${red}$cross Não foi possível criar atalho na área de trabalho: Steam não encontrada${reset}"
fi

echo "Atualizando cache de atalhos e ícones..."
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true
fi

echo
echo "${green}$check SLSsteam, SLScheevo e SLStools foram removidos com sucesso${reset}"
echo "${green}$check Repositório $REPO_NAME foi removido com sucesso${reset}"

