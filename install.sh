#!/bin/bash

set -e

project_root="$(pwd)"
main_repo="SLStools"
repo_url="https://github.com/aglairdev/$main_repo.git"

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
echo "  Instalando SLSsteam, ACCELA, SLSah e SLScheevo"
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

# Atalho Steam
echo
echo "Verificando instalação da Steam..."

steam_binary="$(command -v steam || which steam || whereis -b steam | awk '{print $2}')"

if [ -z "$steam_binary" ]; then
    echo "${color_red}$symbol_cross Steam não encontrada no sistema${color_reset}"
    exit 1
else
    echo "${color_green}$symbol_check Steam encontrada em: $steam_binary${color_reset}"

    desktop_dir="$HOME/.local/share/applications"
    desktop_file="$desktop_dir/steam.desktop"

    mkdir -p "$desktop_dir"

    if [ ! -f "$desktop_file" ]; then
        echo "Criando atalho steam.desktop..."
        cat <<EOF > "$desktop_file"
[Desktop Entry]
Name=Steam
Exec=$steam_binary
Type=Application
Icon=steam
Categories=Game;
EOF
        echo "${color_green}$symbol_check Atalho criado em $desktop_file${color_reset}"
    else
        echo "${color_green}$symbol_check Atalho já existe em $desktop_file${color_reset}"
    fi
fi

# Clonagem SLStools
echo
if [ -d "$project_root/$main_repo" ]; then
    echo "Pasta $main_repo já existe. Atualizando via git pull..."
    cd "$project_root/$main_repo"
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    cd "$project_root"
    echo "${color_green}$symbol_check Repositório atualizado${color_reset}"
else
    echo "Clonando repositório principal $main_repo..."
    git clone "$repo_url" "$project_root/$main_repo" --quiet
fi

# Clonagem do SLSsteam
echo
echo "Clonando/atualizando SLSsteam dentro de $main_repo..."
slssteam_dir="$project_root/$main_repo/SLSsteam"
if [ -d "$slssteam_dir" ]; then
    cd "$slssteam_dir"
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    cd "$project_root/$main_repo"
    echo "${color_green}$symbol_check SLSsteam atualizado${color_reset}"
else
    git clone "https://github.com/AceSLS/SLSsteam.git" "$slssteam_dir" --quiet
fi

# Instalação SLSsteam
echo
echo "Instalando SLSsteam..."
cd "$slssteam_dir"
make >/dev/null 2>&1
chmod +x setup.sh
./setup.sh install >/dev/null 2>&1
echo "${color_green}$symbol_check SLSsteam instalado com sucesso${color_reset}"

cd "$project_root/$main_repo"

# Instalação ACCELA
echo
echo "Instalando ACCELA..."

if [ ! -f "$project_root/$main_repo/Accela-M.zip" ]; then
    echo "${color_red}$symbol_cross Arquivo Accela-M.zip não encontrado em $main_repo!${color_reset}"
    echo "Coloque o arquivo na pasta antes de continuar."
    exit 1
fi

unzip -o "$project_root/$main_repo/Accela-M.zip" -d "$project_root/$main_repo" >/dev/null 2>&1
cd "$project_root/$main_repo/ACCELA-M"
chmod +x ./ACCELAINSTALL
./ACCELAINSTALL || {
    echo "${color_red}$symbol_cross Falha na instalação do ACCELA${color_reset}"
    exit 1
}

if [ -x "$HOME/.local/share/ACCELA/bin/ACCELA" ]; then
    echo "${color_green}$symbol_check ACCELA instalada com sucesso${color_reset}"
else
    echo "${color_red}$symbol_cross ACCELA não foi instalada corretamente${color_reset}"
    exit 1
fi

# SLSah (já dentro do repositório SLStools)
echo
echo "SLSah já foi clonado do repositório SLStools."

# Clonando SLScheevo
echo
echo "Clonando SLScheevo dentro de $main_repo..."
slscheevo_dir="$project_root/$main_repo/SLScheevo"
if [ -d "$slscheevo_dir" ]; then
    cd "$slscheevo_dir"
    git reset --hard HEAD >/dev/null 2>&1
    git pull --quiet
    cd "$project_root/$main_repo"
    echo "${color_green}$symbol_check SLScheevo atualizado${color_reset}"
else
    git clone "https://github.com/xamionex/SLScheevo.git" "$slscheevo_dir" --quiet
    echo "${color_green}$symbol_check SLScheevo clonado com sucesso${color_reset}"
fi

# Finalização
echo
echo "${color_green}$symbol_check SLSsteam, ACCELA, SLSah e SLScheevo foram adicionados com sucesso. ${color_reset}"
