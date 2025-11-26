#!/usr/bin/env bash
set -euo pipefail

green=$(tput setaf 2)
yellow=$(tput setaf 3)
red=$(tput setaf 1)
reset=$(tput sgr0)
check="✓"
cross="𐄂"

INSTALL_DIR="$HOME/steam-schema-generator"
REPO_URL="https://github.com/niwia/SLSah.git"
DESKTOP_ENTRY_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_ENTRY_DIR/steam-schema-generator.desktop"

# Dependências
REQUIRED_PKGS=("git" "python3" "python3-venv" "python3-pip")
MISSING=()

for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v "${pkg%%-*}" &>/dev/null; then
        MISSING+=("$pkg")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo "${red}$cross Pacotes necessários não encontrados: ${MISSING[@]}${reset}"
    exit 1
fi

# Verificando se o diretório já existe
if [ -d "$INSTALL_DIR" ]; then
    echo "${yellow} Diretório já existe. Atualizando repositório com git pull...${reset}"
    cd "$INSTALL_DIR"
    if git pull >/dev/null 2>&1; then
        echo "${green}$check Repositório atualizado com sucesso${reset}"
    else
        echo "${red}$cross Falha ao atualizar repositório com git pull${reset}"
        exit 1
    fi
else
    echo
    echo "Clonando repositório do SLSah..."
    if git clone "$REPO_URL" "$INSTALL_DIR" -v >/dev/null 2>&1; then
        echo "${green}$check Repositório clonado com sucesso${reset}"
    else
        echo "${red}$cross Falha ao clonar repositório. Detalhes:"
        git clone "$REPO_URL" "$INSTALL_DIR" -v 
        exit 1
    fi
fi

# Garantindo que o script 'run.sh' tenha permissão de execução
chmod +x "$INSTALL_DIR/run.sh"

# Criando ambiente virtual
echo
echo "Criando ambiente virtual..."
if python3 -m venv "$INSTALL_DIR/.venv" >/dev/null 2>&1; then
    echo "${green}$check Ambiente virtual criado com sucesso${reset}"
else
    echo "${red}$cross Falha ao criar ambiente virtual${reset}"
    exit 1
fi

# Instalando dependências
echo
echo "Instalando dependências do requirements.txt..."
source "$INSTALL_DIR/.venv/bin/activate"
if pip install --upgrade pip >/dev/null 2>&1 && pip install -r "$INSTALL_DIR/requirements.txt" >/dev/null 2>&1; then
    echo "${green}$check Dependências instaladas com sucesso${reset}"
else
    echo "${red}$cross Falha ao instalar dependências${reset}"
    exit 1
fi
deactivate

# Verificando a biblioteca Steam
echo
echo "Verificando a biblioteca Steam..."
{
    LIBRARY_FILE=$(find "$HOME" -type f -name "libraryfolders.vdf" 2>/dev/null | head -n 1 || true)
    if [ -n "${LIBRARY_FILE:-}" ]; then
        TARGET_DIR="$HOME/.local/share/Steam/steamapps"
        TARGET_FILE="$TARGET_DIR/libraryfolders.vdf"
        mkdir -p "$TARGET_DIR"
        if [ ! -L "$TARGET_FILE" ] || [ "$(readlink "$TARGET_FILE" 2>/dev/null || true)" != "$LIBRARY_FILE" ]; then
            ln -sf "$LIBRARY_FILE" "$TARGET_FILE" >/dev/null 2>&1 || true
        fi
        echo "${green}$check Biblioteca Steam vinculada com sucesso${reset}"
    else
        echo "${red}$cross Biblioteca Steam não encontrada${reset}"
    fi
} || true

# Detectando terminal para execução
echo
echo "Detectando terminal para execução..."
if command -v gnome-terminal >/dev/null 2>&1; then
    TERMINAL="gnome-terminal --"
elif command -v konsole >/dev/null 2>&1; then
    TERMINAL="konsole -e"
elif command -v xfce4-terminal >/dev/null 2>&1; then
    TERMINAL="xfce4-terminal -e"
elif command -v x-terminal-emulator >/dev/null 2>&1; then
    TERMINAL="x-terminal-emulator -e"
else
    TERMINAL="bash -c"
    echo "${red}$cross Terminal não encontrado, utilizando bash padrão${reset}"
fi

# Criando atalho na área de trabalho
echo
echo "Criando atalho na área de trabalho..."
mkdir -p "$DESKTOP_ENTRY_DIR"
cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=Steam Schema Generator
Comment=Generate Steam schema files
Exec=$TERMINAL "$INSTALL_DIR/run.sh"
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=Utility;
EOL
chmod +x "$DESKTOP_FILE"

# Atualizando banco de dados de aplicativos
echo
echo "Atualizando banco de dados de aplicativos..."
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$DESKTOP_ENTRY_DIR" >/dev/null 2>&1 || true
    echo "${green}$check Banco de dados de aplicativos atualizado com sucesso${reset}"
else
    echo "${red}$cross Falha ao atualizar banco de dados de aplicativos${reset}"
fi

# Finalização
echo
echo "${green}$check Instalação do SLSah concluída com sucesso!${reset}"
