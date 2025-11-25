#!/bin/bash

set -e

project_root="$HOME/SLStools"
repo_url="https://github.com/aglairdev/SLStools.git"
conquistas_dir="$project_root/conquistas"
scripts_dir="$project_root/scripts"

color_green=$(tput setaf 2)
color_red=$(tput setaf 1)
color_reset=$(tput sgr0)

symbol_check="✓"
symbol_cross="𐄂"

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
echo "          SLStools             "
echo "|------------------------------|"
echo "       Instalando SLStools     "
echo "#------------------------------#"
echo

echo "[sudo] Será solicitada a senha para continuar..."
sudo -v

dependencies=(
    git make unzip g++ pkg-config figlet whiptail libssl-dev
    g++-multilib gcc-multilib libc6-dev-i386 libssl-dev:i386
    python3.13 python3.13-venv python3.12-venv python3.10-venv
    libxcb-cursor0 libxcb-xinerama0 libxcb-icccm4 libxcb-image0
    libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-shape0
    libxcb-xfixes0 libxkbcommon-x11-0 libglu1-mesa
    qt6-base-dev qt6-base-dev-tools
)

echo "Instalando dependências..."
for package in "${dependencies[@]}"; do
    echo "Instalando: $package"
    if ! command -v "$package" >/dev/null 2>&1 && ! dpkg -s "$package" >/dev/null 2>&1; then
        if command -v apt >/dev/null 2>&1; then
            (sudo apt install -y "$package" >/dev/null 2>&1) & spinner
        elif command -v dnf >/dev/null 2>&1; then
            (sudo dnf install -y "$package" >/dev/null 2>&1) & spinner
        elif command -v pacman >/dev/null 2>&1; then
            (sudo pacman -S --noconfirm "$package" >/dev/null 2>&1) & spinner
        else
            echo "${color_red}$symbol_cross Nenhum gerenciador de pacotes compatível encontrado${color_reset}"
            exit 1
        fi
    fi
done
echo "${color_green}$symbol_check Dependências instaladas${color_reset}"

export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/i386-linux-gnu/pkgconfig"

echo
echo "Identificando instalação da Steam..."

steam_binary=""
if command -v steam >/dev/null 2>&1; then
    steam_binary="$(command -v steam)"
elif [ -x "/usr/games/steam" ]; then
    steam_binary="/usr/games/steam"
elif which steam >/dev/null 2>&1; then
    steam_binary="$(which steam)"
else
    candidate="$(whereis -b steam | awk '{print $2}')"
    if [ -n "$candidate" ] && [ -x "$candidate" ]; then
        steam_binary="$candidate"
    fi
fi

if [ -z "$steam_binary" ]; then
    echo "${color_red}$symbol_cross Steam não encontrada${color_reset}"
    exit 1
else
    echo "Criando atalho da Steam..."
    echo "${color_green}$symbol_check Steam encontrada: $steam_binary${color_reset}"
    desktop_dir="$HOME/.local/share/applications"
    desktop_file="$desktop_dir/steam.desktop"
    mkdir -p "$desktop_dir"
    if [ ! -f "$desktop_file" ]; then
        cat <<EOF > "$desktop_file"
[Desktop Entry]
Name=Steam
Exec=$steam_binary
Type=Application
Icon=steam
Categories=Game;
EOF
        echo "${color_green}$symbol_check Atalho criado${color_reset}"
    else
        echo "${color_green}$symbol_check Atalho já existe${color_reset}"
    fi
fi

echo
echo "Atualizando/clonando repositório principal..."
if [ -d "$project_root/.git" ]; then
    cd "$project_root"
    echo "Atualizando SLStools..."
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    echo "${color_green}$symbol_check SLStools atualizado${color_reset}"
else
    echo "Clonando SLStools..."
    git clone --branch conquistas "$repo_url" "$project_root" --quiet
    echo "${color_green}$symbol_check SLStools clonado${color_reset}"
fi

echo
echo "Atualizando/clonando SLSsteam..."
slssteam_dir="$scripts_dir/SLSsteam"
if [ -d "$slssteam_dir/.git" ]; then
    cd "$slssteam_dir"
    echo "Atualizando SLSsteam..."
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    echo "${color_green}$symbol_check SLSsteam atualizado${color_reset}"
else
    echo "Clonando SLSsteam..."
    git clone "https://github.com/AceSLS/SLSsteam.git" "$slssteam_dir" --quiet
    echo "${color_green}$symbol_check SLSsteam clonado${color_reset}"
fi

echo
echo "Compilando e instalando SLSsteam..."
cd "$slssteam_dir"
make >/dev/null 2>&1
chmod +x setup.sh
./setup.sh install >/dev/null 2>&1 || true
echo "${color_green}$symbol_check SLSsteam instalado${color_reset}"

echo
echo "Atualizando/clonando SLScheevo..."
slscheevo_dir="$conquistas_dir/SLScheevo"
if [ -d "$slscheevo_dir/.git" ]; then
    cd "$slscheevo_dir"
    echo "Atualizando SLScheevo..."
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    echo "${color_green}$symbol_check SLScheevo atualizado${color_reset}"
else
    echo "Clonando SLScheevo..."
    git clone "https://github.com/xamionex/SLScheevo.git" "$slscheevo_dir" --quiet
    echo "${color_green}$symbol_check SLScheevo clonado${color_reset}"
fi

echo
echo "# Início do processo de descompactação #"

echo
echo "Processando SLStools .zip..."
slstools_dir="$scripts_dir/SLStools"

if ls "$slstools_dir"/SLStools.zip.* >/dev/null 2>&1; then
    echo "Unindo arquivos zip..."
    cd "$slstools_dir"
    cat SLStools.zip.* > SLStools.zip
    echo "Extraindo SLStools..."
    unzip -o SLStools.zip -d "$slstools_dir"
    if [ -d "$slstools_dir/SLStools" ]; then
        rm -rf "$slstools_dir/bin" "$slstools_dir/setup.sh" "$slstools_dir/utils" 2>/dev/null || true
        shopt -s dotglob nullglob
        mv "$slstools_dir/SLStools/"* "$slstools_dir/"
        shopt -u dotglob nullglob
        rm -rf "$slstools_dir/SLStools"
    fi
    rm -f SLStools.zip SLStools.zip.*
else
    echo "Atualizando SLStools via git..."
    rm -rf "$slstools_dir"
    mkdir -p "$slstools_dir"
    cd "$project_root"
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    echo "${color_green}$symbol_check SLStools atualizado${color_reset}"
fi

echo
echo "# Fim do processo de descompactação #"
echo

echo "Instalando SLStools..."
cd "$slstools_dir"
chmod +x setup.sh
./setup.sh install >/dev/null 2>&1 || true
echo "${color_green}$symbol_check SLStools instalado${color_reset}"

echo
echo "Criando atalhos do SLStools..."
"$slstools_dir/bin/shortcut.sh" >/dev/null 2>&1 || true
echo "${color_green}$symbol_check Atalho SLStools criado com sucesso${color_reset}"

echo
echo "Baixando Steamless..."
steamless_dir="$scripts_dir/Steamless"
steamless_url="https://github.com/atom0s/Steamless/releases/download/v3.1.0.5/Steamless.v3.1.0.5.-.by.atom0s.zip"

mkdir -p "$steamless_dir"
cd "$steamless_dir"

if [ ! -f "Steamless.v3.1.0.5.-.by.atom0s.zip" ]; then
    echo "Baixando Steamless v3.1.0.5..."
    (wget -q "$steamless_url" -O "Steamless.v3.1.0.5.-.by.atom0s.zip") & spinner
    echo "${color_green}$symbol_check Steamless baixado${color_reset}"
else
    echo "${color_green}$symbol_check Steamless já está atualizado${color_reset}"
fi

if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi

if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true
fi

echo
echo "${color_green}$symbol_check Todas as ferramentas necessárias foram adicionadas${color_reset}"
