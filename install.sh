#!/bin/bash

set -e

project_root="$HOME/Accela"
repo_url="https://github.com/aglairdev/SLStools.git"
scripts_dir="$project_root/scripts"
color_green=$(tput setaf 2)
color_red=$(tput setaf 1)
color_yellow=$(tput setaf 3)
color_reset=$(tput sgr0)

symbol_check="✓"
symbol_cross="𐄂"
symbol_divider="⚒"

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
echo "---------------------------------------------------------------------"
echo "  Instalação Accela, SLSsteam, Steamless, SLSah e SLScheevo $divider $symbol_divider"
echo "---------------------------------------------------------------------"

echo
echo "[sudo] Será solicitado a senha para continuar..."
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

echo
echo "Instalando dependências..."
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

echo
echo "Verificando instalação da Steam..."
steam_binary="$(command -v steam || which steam || whereis -b steam | awk '{print $2}')"

if [ -z "$steam_binary" ]; then
    echo "${color_red}$symbol_cross Steam não encontrada${color_reset}"
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

mkdir -p "$project_root"
mkdir -p "$scripts_dir"

echo
echo "Clonando ou atualizando o repositório SLStools na branch accela..."
if [ -d "$project_root/.git" ]; then
    cd "$project_root"
    git fetch --all
    git checkout accela
    git reset --hard HEAD
    git pull
    echo "${color_green}$symbol_check SLStools atualizado na branch accela${color_reset}"
else
    if [ -d "$project_root" ] && [ "$(ls -A "$project_root" 2>/dev/null | wc -l)" -gt 0 ]; then
        rm -rf "$project_root"
    fi
    git clone --branch accela "$repo_url" "$project_root"
    echo "${color_green}$symbol_check SLStools clonado na branch accela${color_reset}"
fi

echo
echo "Instalando SLSsteam..."
slssteam_dir="$scripts_dir/SLSsteam"
if [ -d "$slssteam_dir" ]; then
    cd "$slssteam_dir"
    git reset --hard HEAD
    git pull --quiet
    cd "$project_root"
    echo "${color_green}$symbol_check SLSsteam atualizado${color_reset}"
else
    git clone "https://github.com/AceSLS/SLSsteam.git" "$slssteam_dir" --quiet
    echo "${color_green}$symbol_check SLSsteam clonado${color_reset}"
fi

echo
echo "Compilando e instalando SLSsteam..."
cd "$slssteam_dir"
make >/dev/null 2>&1 || true
chmod +x setup.sh
./setup.sh install >/dev/null 2>&1
echo "${color_green}$symbol_check SLSsteam instalado com sucesso${color_reset}"

echo
echo "Instalando Accela..."
if [ ! -f "$scripts_dir/Accela-M.zip" ]; then
    echo "${color_red}$symbol_cross Não foi encontrado o arquivo Accela-M.zip em $scripts_dir${color_reset}"
    echo "Coloque o arquivo na pasta antes de continuar."
    exit 1
fi

unzip -o "$scripts_dir/Accela-M.zip" -d "$scripts_dir" >/dev/null 2>&1
cd "$scripts_dir/Accela-M"
chmod +x ./ACCELAINSTALL
./ACCELAINSTALL || {
    echo "${color_red}$symbol_cross Falha na instalação do Accela${color_reset}"
    exit 1
}

if [ -x "$HOME/.local/share/ACCELA/bin/ACCELA" ]; then
    echo "${color_green}$symbol_check Accela instalado com sucesso${color_reset}"
else
    echo "${color_red}$symbol_cross Falha na instalação do Accela${color_reset}"
    exit 1
fi

echo
echo "Clonando SLScheevo..."
slscheevo_dir="$scripts_dir/SLScheevo"
if [ -d "$slscheevo_dir" ]; then
    cd "$slscheevo_dir"
    git reset --hard HEAD
    git pull --quiet
    cd "$project_root"
    echo "${color_green}$symbol_check SLScheevo atualizado${color_reset}"
else
    git clone "https://github.com/xamionex/SLScheevo.git" "$slscheevo_dir" --quiet
    echo "${color_green}$symbol_check SLScheevo clonado${color_reset}"
fi

echo
echo "Baixando Steamless..."
steamless_dir="$scripts_dir/Steamless"
steamless_url="https://github.com/atom0s/Steamless/releases/download/v3.1.0.5/Steamless.v3.1.0.5.-.by.atom0s.zip"
mkdir -p "$steamless_dir"

if [ ! -f "$steamless_dir/Steamless.v3.1.0.5.-.by.atom0s.zip" ]; then
    echo "Baixando Steamless v3.1.0.5..."
    (wget -q "$steamless_url" -O "$steamless_dir/Steamless.v3.1.0.5.-.by.atom0s.zip") & spinner
    echo "${color_green}$symbol_check Steamless baixado${color_reset}"
else
    echo "${color_green}$symbol_check Steamless já atualizado${color_reset}"
fi

unzip -o "$steamless_dir/Steamless.v3.1.0.5.-.by.atom0s.zip" -d "$steamless_dir" >/dev/null 2>&1 || true

echo
echo "${color_yellow}Iniciando a Steam para gerar ~/.config/SLSsteam${color_reset}"
steam_log="/tmp/steam_start.log.$$"
set +e
desktop_id="$(basename "$desktop_file" .desktop)"
if command -v gtk-launch >/dev/null 2>&1; then
    gtk-launch "$desktop_id" >/dev/null 2>&1 &
elif command -v gio >/dev/null 2>&1; then
    gio open "$desktop_file" >/dev/null 2>&1 &
elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$desktop_file" >/dev/null 2>&1 &
else
    env LD_AUDIT="$slssteam_so" nohup "$steam_binary" >"$steam_log" 2>&1 &
fi
sleep 1
max_wait=60
elapsed=0
success=0
while [ $elapsed -lt $max_wait ]; do
    if [ -d "$HOME/.config/SLSsteam" ]; then
        success=1
        break
    fi
    sleep 1
    elapsed=$((elapsed+1))
done

if [ $success -eq 1 ]; then
    echo "${color_green}$symbol_check Steam iniciada e arquivos ~/.config/SLSsteam detectados${color_reset}"
else
    echo "${color_red}$symbol_cross Não foi possível detectar ~/.config/SLSsteam após ${max_wait}s${color_reset}"
    if [ -f "$steam_log" ]; then
        echo "Últimas linhas do log:"
        tail -n 30 "$steam_log" 2>/dev/null || true
    fi
    echo "${color_red}Verifique se a sessão gráfica está ativa e se o desktop entry $desktop_file está sendo usado para iniciar a Steam.${color_reset}"
    exit 1
fi
set -e

echo
echo "${color_yellow}Fechando Steam...${color_reset}"
if command -v steam >/dev/null 2>&1; then
    steam -shutdown >/dev/null 2>&1 || true
fi

shutdown_wait=30
sw=0
while pgrep -u "$USER" -f "[s]team" >/dev/null 2>&1 && [ $sw -lt $shutdown_wait ]; do
    sleep 1
    sw=$((sw+1))
done

if pgrep -u "$USER" -f "[s]team" >/dev/null 2>&1; then
    pkill -15 -u "$USER" -f steam >/dev/null 2>&1 || true
    sleep 2
fi

if pgrep -u "$USER" -f "[s]team" >/dev/null 2>&1; then
    pkill -9 -u "$USER" -f steam >/dev/null 2>&1 || true
fi

if pgrep -u "$USER" -f "[s]team" >/dev/null 2>&1; then
    echo "${color_red}$symbol_cross Não foi possível encerrar todos os processos do Steam${color_reset}"
    exit 1
else
    echo "${color_green}$symbol_check Steam encerrada com sucesso${color_reset}"
fi

slssteam_config_dir="$HOME/.config/SLSsteam"
config_file="$slssteam_config_dir/config.yaml"

echo
echo "${color_yellow}Editando $config_file ${color_reset}"
if [ -f "$config_file" ]; then
    cp "$config_file" "$config_file.bak.$(date +%s)" 2>/dev/null || true
    if grep -qE '^[[:space:]]*PlayNotOwnedGames:' "$config_file"; then
        sed -i -E 's/^[[:space:]]*PlayNotOwnedGames:[[:space:]]*(no|false|0)/PlayNotOwnedGames: yes/I' "$config_file"
        sed -i -E 's/^[[:space:]]*PlayNotOwnedGames:[[:space:]]*(yes|true|1)/PlayNotOwnedGames: yes/I' "$config_file"
    else
        echo "PlayNotOwnedGames: yes" >> "$config_file"
    fi
    echo "${color_green}$symbol_check $config_file editado com sucesso${color_reset}"
else
    echo "${color_red}$symbol_cross $config_file não encontrado${color_reset}"
    exit 1
fi

echo
echo "${color_green}$symbol_check Instalação completa!${color_reset}"