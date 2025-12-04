#!/bin/bash

set -e

backup_dir="$PWD/steam_conquistas"
stats_dir="$backup_dir/stats"
onde_restaurar="$backup_dir/onde-restaurar.txt"

color_green=$(tput setaf 2)
color_red=$(tput setaf 1)
color_reset=$(tput sgr0)

symbol_check="✓"
symbol_cross="𐄂"
symbol_divider="⚒"

echo
echo "------------------------------------------------"
echo "     BACKUP DE CONQUISTAS STEAM $symbol_divider     "
echo "------------------------------------------------"

echo
echo "[sudo] Será solicitada a senha para varredura completa..."
sudo -v

mkdir -p "$stats_dir"

echo
echo "Buscando pastas 'stats' do usuário atual..."

stats_paths=$(find "$HOME/.steam/steam/appcache" "$HOME/.local/share/Steam/appcache" -type d -name "stats" ! -path "*/Trash/*" 2>/dev/null | sort -u)

if [ -z "$stats_paths" ]; then
    echo "${color_red}$symbol_cross Nenhuma pasta 'stats' encontrada${color_reset}"
else
    for path in $stats_paths; do
        echo "Copiando de: $path"
        if ! cp -r "$path/"* "$stats_dir/" 2>/dev/null; then
            echo "${color_red}$symbol_cross Falha ao copiar $path${color_reset}"
        fi
    done
    echo "${color_green}$symbol_check Backup de todas as conquistas concluído${color_reset}"
fi

sudo chown -R "$USER:$USER" "$backup_dir"

echo
echo "${color_green}$symbol_check Backup das conquistas salvo em: $stats_dir${color_reset}"

echo "Sobrescrever a pasta stats em:
~/.steam/steam/appcache/" > "$onde_restaurar"

