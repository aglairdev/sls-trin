#!/bin/bash

set -e

project_root="$(pwd)"
main_repo="sls-trin"

color_green=$(tput setaf 2)
color_red=$(tput setaf 1)
color_reset=$(tput sgr0)

symbol_check="✓"
symbol_cross="𐄂"
symbol_divider="┿"

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
echo "---------------------------------------"
echo "         SLS TRIN $symbol_divider         "
echo "---------------------------------------"
echo "  Instalando SLSsteam, ACCELA e SLSah"
echo "---------------------------------------"

# Password
echo
echo "[sudo] Será solicitada a senha para continuar..."
sudo -v

# Dependências
dependencies=(
    git make unzip g++ pkg-config figlet whiptail libssl-dev
    g++-multilib gcc-multilib libc6-dev-i386 libssl-dev:i386
    python3.13 python3.13-venv
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

# Verificação e criação do atalho da Steam
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

# Clonagem do repositório principal
echo
echo "Clonando repositório principal $main_repo..."
rm -rf "$project_root/$main_repo"
git clone "https://github.com/aglairdev/$main_repo.git" "$project_root/$main_repo" --quiet

# Clonagem do SLSsteam dentro do repositório principal
echo
echo "Clonando SLSsteam dentro de $main_repo..."
rm -rf "$project_root/$main_repo/SLSsteam"
git clone "https://github.com/AceSLS/SLSsteam.git" "$project_root/$main_repo/SLSsteam" --quiet

# SLSsteam
echo
echo "Instalando SLSsteam..."
cd "$project_root/$main_repo/SLSsteam"
make >/dev/null 2>&1
chmod +x setup.sh
./setup.sh install >/dev/null 2>&1
echo "${color_green}$symbol_check SLSsteam instalado com sucesso${color_reset}"

cd "$project_root/$main_repo"

# ACCELA
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

cd "$project_root/$main_repo"

# SLSah
echo
echo "Instalando SLSah..."
if [ ! -f "$project_root/$main_repo/SLSah-M.sh" ]; then
    echo "${color_red}$symbol_cross Script SLSah-M.sh não encontrado!${color_reset}"
    exit 1
fi

chmod +x "$project_root/$main_repo/SLSah-M.sh"
"$project_root/$main_repo/SLSah-M.sh" >/dev/null 2>&1
echo "${color_green}$symbol_check SLSah instalada com sucesso${color_reset}"

# Finalização
echo
echo "${color_green}$symbol_check SLSsteam, ACCELA e SLSah instalados com sucesso${color_reset}"
