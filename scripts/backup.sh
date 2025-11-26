#!/bin/bash

set -e

project_root="$HOME/SLStools/scripts"
backup_dir="$project_root/steam_backup"
tutorial_file="$backup_dir/tutorial.txt"

color_green=$(tput setaf 2)
color_red=$(tput setaf 1)
color_reset=$(tput sgr0)

symbol_check="✓"
symbol_cross="𐄂"
symbol_divider="⚒"

echo
echo "---------------------------------------"
echo "     BACKUP STEAM DATA $symbol_divider     "
echo "---------------------------------------"
echo "     Fazendo Backup                    "
echo "---------------------------------------"

echo
echo "[sudo] Será solicitada a senha para varredura completa..."
sudo -v

mkdir -p "$backup_dir"

cat <<EOF > "$tutorial_file"
stats
local deb
~/.steam/steam/appcache/stats/
~/.local/share/Steam/appcache/stats/
compatdata
local deb
~/.steam/steam/steamapps/compatdata/
~/.local/share/Steam/steamapps/compatdata/
Verifique discos externos e montagens em /mnt ou /media
EOF

echo
echo "Buscando pastas 'stats' do usuário atual..."

stats_paths=$(find "$HOME/.steam/steam/appcache" "$HOME/.local/share/Steam/appcache" -type d -name "stats" ! -path "*/Trash/*" 2>/dev/null | sort -u)

if [ -z "$stats_paths" ]; then
    echo "${color_red}$symbol_cross Nenhuma pasta 'stats' encontrada${color_reset}"
else
    for path in $stats_paths; do
        echo "Encontrado: $path"
        origin=$(basename "$(dirname "$path")")
        mkdir -p "$backup_dir/stats_${origin}"
        if ! cp -r "$path/"* "$backup_dir/stats_${origin}/" 2>/dev/null; then
            echo "${color_red}$symbol_cross Falha ao copiar $path${color_reset}"
        fi
    done
    echo "${color_green}$symbol_check Backup de 'stats' concluído${color_reset}"
fi

echo
echo "Buscando pastas 'compatdata'..."
compat_paths=$(sudo find /mnt /media /home "$HOME/.steam" "$HOME/.local/share" /var /snap \
  -type d -name "compatdata" ! -path "*/Trash/*" 2>/dev/null | sort -u)

if [ -z "$compat_paths" ]; then
    echo "${color_red}$symbol_cross Nenhuma pasta 'compatdata' encontrada${color_reset}"
else
    for path in $compat_paths; do
        disk=$(df "$path" | tail -1 | awk '{print $1}' | sed 's|/dev/||')
        disk_name=$(basename "$disk")
        echo "Encontrado: $path"
        mkdir -p "$backup_dir/compatdata_${disk_name}"
        if ! sudo cp -r "$path/"* "$backup_dir/compatdata_${disk_name}/" 2>/dev/null; then
            echo "${color_red}$symbol_cross Falha ao copiar $path${color_reset}"
        fi
    done
    echo "${color_green}$symbol_check Backup de 'compatdata' concluído${color_reset}"
fi

sudo chown -R "$USER:$USER" "$backup_dir"

echo
echo "${color_green}$symbol_check Backup salvo em: $backup_dir${color_reset}"