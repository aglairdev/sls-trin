#!/bin/bash

set -e

ROOT_DIR="$(pwd)"
repo="sls-trin"

# Cores e símbolos
green=$(tput setaf 2)
red=$(tput setaf 1)
gray=$(tput setaf 7)
reset=$(tput sgr0)

check="✓"
cross="𐄂"
divider="┿"

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
echo "------------------------------"
echo "           SLS TRIN $divider         "
echo "------------------------------"
echo "  SLSsteam + ACCELA + SLSah   "
echo "------------------------------"

# Dependências
DEPENDENCIAS=("git" "make" "unzip" "g++" "pkg-config" "figlet" "whiptail" "libssl-dev")

echo
echo "Verificando e instalando dependências..."
for DEP in "${DEPENDENCIAS[@]}"; do
    if ! command -v "$DEP" >/dev/null 2>&1 && ! dpkg -s "$DEP" >/dev/null 2>&1; then
        if command -v apt >/dev/null 2>&1; then
            (sudo apt install -y "$DEP" >/dev/null 2>&1) & spinner
        elif command -v dnf >/dev/null 2>&1; then
            (sudo dnf install -y "$DEP" >/dev/null 2>&1) & spinner
        elif command -v pacman >/dev/null 2>&1; then
            (sudo pacman -S --needed --noconfirm "$DEP" >/dev/null 2>&1) & spinner
        fi
    fi
done

export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/i386-linux-gnu/pkgconfig"

# SLSsteam
echo
echo "Instalando SLSsteam..."
(
    rm -rf "$ROOT_DIR/SLSsteam"
    git clone "https://github.com/AceSLS/SLSsteam" "$ROOT_DIR/SLSsteam" >/dev/null 2>&1
    cd "$ROOT_DIR/SLSsteam"
    make >/dev/null 2>&1
    cd "$ROOT_DIR"
) & spinner
echo "${green}$check SLSsteam instalado com sucesso${reset}"

# ACCELA
echo
echo "Instalando ACCELA..."
(
    rm -rf "$ROOT_DIR/$repo"
    git clone "https://github.com/aglairdev/$repo.git" "$ROOT_DIR/$repo" >/dev/null 2>&1
) & spinner

if [ ! -f "$ROOT_DIR/$repo/Accela-M.zip" ]; then
    echo "${red}$cross Arquivo Accela-M.zip não encontrado em $repo!${reset}"
    echo "Coloque o arquivo na pasta antes de continuar."
    exit 1
fi

(
    unzip -o "$ROOT_DIR/$repo/Accela-M.zip" -d "$ROOT_DIR/$repo" >/dev/null 2>&1
    cd "$ROOT_DIR/$repo/ACCELA-M"
    chmod +x ./ACCELAINSTALL
    yes | ./ACCELAINSTALL >/dev/null 2>&1
    cd "$ROOT_DIR"
) & spinner
echo "${green}$check ACCELA instalada com sucesso${reset}"

# SLSah
echo
echo "Instalando SLSah..."
if [ ! -f "$ROOT_DIR/$repo/SLSah-M.sh" ]; then
    echo "${red}$cross Script SLSah-M.sh não encontrado!${reset}"
    exit 1
fi

(
    chmod +x "$ROOT_DIR/$repo/SLSah-M.sh"
    "$ROOT_DIR/$repo/SLSah-M.sh" >/dev/null 2>&1
) & spinner
echo "${green}$check SLSah instalada com sucesso${reset}"

# Finalização
echo
echo "──────────────────────────────────────────────────────────────────────"
echo "${green}$check SLSsteam, ACCELA e SLSah instalados com sucesso${reset}"
echo "──────────────────────────────────────────────────────────────────────"

