#!/usr/bin/env bash
# Instala as extensões listadas em vscode-settings/extensions.txt (ou no arquivo passado como argumento)
# Uso: ./install-extensions-insiders.sh [arquivo]

list="${1:-$(dirname "$0")/vscode-settings/extensions.txt}"

if [[ ! -f "$list" ]]; then
  echo "Arquivo $list não encontrado" >&2
  exit 1
fi

tr -d '\r' < "$list" | while read -r extension || [[ -n $extension ]];
do
  [[ -z "$extension" ]] && continue
  code-insiders --install-extension "$extension" --force
done
