#!/bin/bash

set -e

# Diretório do projeto e repositórios
project_root="$HOME/SLStools"
repo_url="https://github.com/aglairdev/SLStools.git"
conquistas_dir="$project_root/conquistas"
scripts_dir="$project_root/scripts"

color_green=$(tput setaf 2)
color_red=$(tput setaf 1)
color_reset=$(tput sgr0)

symbol_check="✓"
symbol_cross="𐄂"
symbol_divider="⚒"

# Spinner
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 $pid 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
}

echo
echo "#------------------------------#"
echo "     SLStools $symbol_divider   "
echo "|------------------------------|"
echo "    Instalando SLStools         "
echo "#------------------------------#"
echo

# Password
echo
echo "[sudo] Será solicitada a senha para continuar..."
sudo -v

# Dependências
dependencies=(
    git make unzip g++ pkg-config figlet whiptail libssl-dev
    g++-multilib gcc-multilib libc6-dev-i386 libssl-dev:i386
    python3.13 python3.13-venv python3.12-venv python3.10-venv
    libxcb-cursor0 libxcb-xinerama0 libxcb-icccm4 libxcb-image0
    libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-shape0
    libxcb-xfixes0 libxkbcommon-x11-0 libglu1-mesa
    qt6-base-dev qt6-base-dev-tools
)

echo
echo "Instalando dependências necessárias..."
for package in "${dependencies[@]}"; do
    if ! command -v "$package" >/dev/null 2>&1 && ! dpkg -s "$package" >/dev/null 2>&1; then
        if command -v apt >/dev/null 2>&1; then
            echo "Instalando $package via apt..."
            (sudo apt install -y "$package" >/dev/null 2>&1) & spinner
        elif command -v dnf >/dev/null 2>&1; then
            echo "Instalando $package via dnf..."
            (sudo dnf install -y "$package" >/dev/null 2>&1) & spinner
        elif command -v pacman >/dev/null 2>&1; then
            echo "Instalando $package via pacman..."
            (sudo pacman -S --noconfirm "$package" >/dev/null 2>&1) & spinner
        else
            echo "${color_red}$symbol_cross Nenhum gerenciador de pacotes compatível encontrado${color_reset}"
            exit 1
        fi
    fi
done
echo "${color_green}$symbol_check Dependências instaladas com sucesso${color_reset}"

export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/i386-linux-gnu/pkgconfig"

# Repositório principal
echo
if [ -d "$project_root/.git" ]; then
    echo "Repositório principal já existe. Atualizando via git pull..."
    cd "$project_root"
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    echo "${color_green}$symbol_check Repositório principal atualizado${color_reset}"
else
    echo "Clonando repositório principal na branch 'conquistas'..."
    git clone --branch conquistas "$repo_url" "$project_root" --quiet
    echo "${color_green}$symbol_check Repositório principal clonado com sucesso${color_reset}"
fi

# SLSsteam
echo
echo "Clonando/atualizando SLSsteam dentro de $scripts_dir..."
slssteam_dir="$scripts_dir/SLSsteam"
if [ -d "$slssteam_dir/.git" ]; then
    cd "$slssteam_dir"
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    echo "${color_green}$symbol_check SLSsteam atualizado${color_reset}"
else
    git clone "https://github.com/AceSLS/SLSsteam.git" "$slssteam_dir" --quiet
    echo "${color_green}$symbol_check SLSsteam clonado com sucesso${color_reset}"
fi

echo
echo "Instalando SLSsteam..."
cd "$slssteam_dir"
make >/dev/null 2>&1
chmod +x setup.sh
./setup.sh install >/dev/null 2>&1
echo "${color_green}$symbol_check SLSsteam instalado com sucesso${color_reset}"

# SLScheevo
echo
echo "Clonando/atualizando SLScheevo dentro de $conquistas_dir..."
slscheevo_dir="$conquistas_dir/SLScheevo"
if [ -d "$slscheevo_dir/.git" ]; then
    cd "$slscheevo_dir"
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    echo "${color_green}$symbol_check SLScheevo atualizado${color_reset}"
else
    git clone "https://github.com/xamionex/SLScheevo.git" "$slscheevo_dir" --quiet
    echo "${color_green}$symbol_check SLScheevo clonado com sucesso${color_reset}"
fi

# SLStools zip
echo
echo "Instalando SLStools..."
slstools_dir="$scripts_dir/SLStools"

if ls "$slstools_dir"/SLStools.zip.* >/dev/null 2>&1; then
    echo "Unindo partes do SLStools.zip..."
    cd "$slstools_dir"
    cat SLStools.zip.001 SLStools.zip.002 SLStools.zip.003 SLStools.zip.004 > SLStools.zip

    echo "Descompactando SLStools.zip..."
    unzip -o SLStools.zip -d "$slstools_dir"

    echo "Movendo conteúdo para $slstools_dir..."
    if [ -d "$slstools_dir/SLStools" ]; then
        rm -rf "$slstools_dir/bin" "$slstools_dir/setup.sh" 2>/dev/null || true
        mv "$slstools_dir/SLStools/"* "$slstools_dir/"
        rm -rf "$slstools_dir/SLStools"
    fi

    echo "Excluindo arquivos zip..."
    rm -f SLStools.zip SLStools.zip.001 SLStools.zip.002 SLStools.zip.003 SLStools.zip.004
else
    echo "Nenhum arquivo SLStools.zip encontrado. Limpando e atualizando via git..."
    rm -rf "$slstools_dir"
    mkdir -p "$slstools_dir"
    cd "$project_root"
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    echo "${color_green}$symbol_check SLStools atualizado via git${color_reset}"
fi

echo "Executando setup.sh para instalar SLStools..."
cd "$slstools_dir"
chmod +x setup.sh
./setup.sh install >/dev/null 2>&1

# Gerar atalho
echo "Gerando atalho..."
/home/shebang/SLStools/scripts/SLStools/bin/shortcut.sh

# Atualizar cache de atalhos e ícones
echo "Atualizando cache de atalhos e ícones..."
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi
if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true
fi

echo
echo "${color_green}$symbol_check SLStools foi adicionado com sucesso. ${color_reset}"
