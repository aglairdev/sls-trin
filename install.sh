#!/bin/bash

set -e

# Diretório do projeto e repositórios
project_root="$HOME/SLStools"
main_repo="SLStools"
repo_url="https://github.com/aglairdev/$main_repo.git"
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
echo "------------------------------------------------"
echo "         SLStools $symbol_divider         "
echo "------------------------------------------------"
echo "  Instalando SLStools                     "
echo "------------------------------------------------"

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

# Clonando repositório principal
echo
if [ -d "$project_root/$main_repo" ]; then
    echo "Pasta $main_repo já existe. Atualizando via git pull..."
    cd "$project_root/$main_repo"
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    cd "$project_root"
    echo "${color_green}$symbol_check Repositório principal atualizado${color_reset}"
else
    echo "Clonando repositório principal $main_repo..."
    git clone "$repo_url" "$project_root/$main_repo" --quiet
fi

# Clonagem do SLSsteam para scripts
echo
echo "Clonando/atualizando SLSsteam dentro de $scripts_dir..."
slssteam_dir="$scripts_dir/SLSsteam"
if [ -d "$slssteam_dir" ]; then
    cd "$slssteam_dir"
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    cd "$scripts_dir"
    echo "${color_green}$symbol_check SLSsteam atualizado${color_reset}"
else
    git clone "https://github.com/AceSLS/SLSsteam.git" "$slssteam_dir" --quiet
    echo "${color_green}$symbol_check SLSsteam clonado com sucesso${color_reset}"
fi

# Instalação SLSsteam
echo
echo "Instalando SLSsteam..."
cd "$slssteam_dir"
make >/dev/null 2>&1
chmod +x setup.sh
./setup.sh install >/dev/null 2>&1
echo "${color_green}$symbol_check SLSsteam instalado com sucesso${color_reset}"

# Clonagem do SLScheevo para conquistas
echo
echo "Clonando/atualizando SLScheevo dentro de $conquistas_dir..."
slscheevo_dir="$conquistas_dir/SLScheevo"
if [ -d "$slscheevo_dir" ]; then
    cd "$slscheevo_dir"
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    cd "$conquistas_dir"
    echo "${color_green}$symbol_check SLScheevo atualizado${color_reset}"
else
    git clone "https://github.com/xamionex/SLScheevo.git" "$slscheevo_dir" --quiet
    echo "${color_green}$symbol_check SLScheevo clonado com sucesso${color_reset}"
fi

# Instalação do SLStools
echo
echo "Instalando SLStools..."

# Caminho onde o SLStools será descompactado
slstools_dir="$scripts_dir/SLStools"
if [ ! -f "$slstools_dir/SLStools.zip" ]; then
    echo "${color_red}$symbol_cross Arquivo SLStools.zip não encontrado em $slstools_dir!${color_reset}"
    echo "Coloque os arquivos SLStools.zip na pasta antes de continuar."
    exit 1
fi

echo "Descompactando os arquivos SLStools.zip..."
for part in {001..004}; do
    unzip -o "$slstools_dir/SLStools.zip.$part" -d "$slstools_dir"
done

# Excluindo os arquivos zip após descompactar
echo "Excluindo arquivos zip..."
rm -f "$slstools_dir/SLStools.zip."{001..004}

# Executando o setup.sh
echo "Executando setup.sh para instalar SLStools..."
cd "$slstools_dir/SLStools"
chmod +x setup.sh
./setup.sh install >/dev/null 2>&1

# Finalização
echo
echo "${color_green}$symbol_check SLStools foi adicionado com sucesso. ${color_reset}"
