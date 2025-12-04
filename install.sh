#!/bin/bash

set -e

project_root="$HOME/SLStools"
repo_url="https://github.com/aglairdev/SLStools.git"
conquistas_dir="$project_root/conquistas"
scripts_dir="$project_root/scripts"

color_green=$(tput setaf 2)
color_red=$(tput setaf 1)
color_yellow=$(tput setaf 3)
color_reset=$(tput sgr0)

symbol_check="✓"
symbol_cross="𐄂"
divider="⚒"

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
echo "|------------------------------------|"
echo "       INSTALAÇÃO SLStools ${divider}    "
echo "|------------------------------------|"

echo "[sudo] Será solicitada a senha para continuar..."
sudo -v

dependencies=(
    git make unzip g++ pkg-config figlet whiptail libssl-dev
    g++-multilib gcc-multilib libc6-dev-i386 libssl-dev:i386
    python3.13 python3.13-venv python3.12-venv python3.10-venv
    libxcb-cursor0 libxcb-xinerama0 libxcb-icccm4 libxcb-image0
    libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-shape0
    libxcb-xfixes0 libxkbcommon-x11-0 libglu1-mesa
    qt6-base-dev qt6-base-dev-tools libglib2.0-bin
)

echo "Instalando dependências..."
for package in "${dependencies[@]}"; do
    echo "Instalando: $package"
    if ! dpkg -s "$package" >/dev/null 2>&1 && ! command -v "$package" >/dev/null 2>&1; then
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
    echo "${color_green}$symbol_check Steam encontrada: $steam_binary${color_reset}"
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
    mkdir -p "$scripts_dir"
    git clone "https://github.com/AceSLS/SLSsteam.git" "$slssteam_dir" --quiet
    echo "${color_green}$symbol_check SLSsteam clonado${color_reset}"
fi

echo
echo "Compilando e instalando SLSsteam..."
cd "$slssteam_dir"
make >/dev/null 2>&1 || true
chmod +x setup.sh
set +e
./setup.sh install >/dev/null 2>&1
set -e
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
    mkdir -p "$conquistas_dir"
    git clone "https://github.com/xamionex/SLScheevo.git" "$slscheevo_dir" --quiet
    echo "${color_green}$symbol_check SLScheevo clonado${color_reset}"
fi

echo
echo "Baixando Ludusavi..."
ludusavi_dir="$scripts_dir/ludusavi"
ludusavi_url="https://github.com/mtkennerly/ludusavi/releases/latest/download/ludusavi-v0.30.0-linux.tar.gz"

mkdir -p "$ludusavi_dir"
cd "$ludusavi_dir"

if [ ! -f "ludusavi-v0.30.0-linux.tar.gz" ]; then
    echo "Baixando Ludusavi v0.30.0..."
    (wget -q "$ludusavi_url" -O "ludusavi-v0.30.0-linux.tar.gz") & spinner
    echo "${color_green}$symbol_check Ludusavi baixado${color_reset}"
else
    echo "${color_green}$symbol_check Ludusavi já está atualizado${color_reset}"
fi

desktop_app_dir="$HOME/.local/share/applications"
mkdir -p "$desktop_app_dir"

desktop_file="$desktop_app_dir/steam.desktop"
slssteam_so="$HOME/.local/share/SLSsteam/SLSsteam.so"
ld_audit_exec="env LD_AUDIT=\"$slssteam_so\""

cat > "$desktop_file" <<EOF
[Desktop Entry]
Name=Steam
Comment=Application for managing and playing games on Steam
Exec=$ld_audit_exec $steam_binary %U
Icon=steam
Terminal=false
Type=Application
Categories=Network;FileTransfer;Game;
MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
Actions=Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;
PrefersNonDefaultGPU=true
X-KDE-RunOnDiscreteGpu=true
EOF

chmod 644 "$desktop_file"
if command -v gio >/dev/null 2>&1; then
    gio set "$desktop_file" "metadata::trusted" true >/dev/null 2>&1 || true
fi
echo "${color_green}$symbol_check Atalho criado/atualizado em $desktop_app_dir${color_reset}"

find_desktop_dir() {
    local d
    if command -v xdg-user-dir >/dev/null 2>&1; then
        d="$(xdg-user-dir DESKTOP 2>/dev/null || true)"
        if [ -n "$d" ] && [ -d "$d" ]; then
            echo "$d"
            return
        fi
    fi
    local candidates=("Desktop" "desktop" "Área de trabalho" "Área de Trabalho")
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

DESKTOP_DIR="$(find_desktop_dir)"
mkdir -p "$DESKTOP_DIR"

desktop_shortcut="$DESKTOP_DIR/steam.desktop"

cp "$desktop_file" "$desktop_shortcut"
chmod 644 "$desktop_shortcut"
echo "${color_green}$symbol_check Atalho na área de trabalho criado/atualizado${color_reset}"

if command -v gio >/dev/null 2>&1; then
    gio set "$desktop_shortcut" "metadata::trusted" true >/dev/null 2>&1 || true
    chmod a+x "$desktop_shortcut" >/dev/null 2>&1 || true
    echo "${color_green}$symbol_check Atalho marcado como confiável e permissões ajustadas${color_reset}"
elif command -v gvfs-set-attribute >/dev/null 2>&1; then
    gvfs-set-attribute -t boolean "$desktop_shortcut" metadata::trusted true >/dev/null 2>&1 || true
    chmod a+x "$desktop_shortcut" >/dev/null 2>&1 || true
    echo "${color_green}$symbol_check Atalho marcado como confiável (gvfs) e permissões ajustadas${color_reset}"
else
    chmod a+x "$desktop_shortcut" >/dev/null 2>&1 || true
    echo "${color_red}$symbol_cross 'gio' não encontrado; marque o atalho como confiável manualmente se necessário${color_reset}"
fi

echo
echo "# Início do processo de descompactação #"

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
set +e
./setup.sh install >/dev/null 2>&1
set -e
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
echo "Instalação completa!"

