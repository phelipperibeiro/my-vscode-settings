#!/usr/bin/env bash
# Remove as extensões instaladas que não estão em vscode-settings/extensions.txt
# Uso: ./clear-old-extensions.sh [code|code-insiders] [-y]

cli="code"
assume_yes=false
for arg in "$@"; do
  case "$arg" in
    -y|--yes) assume_yes=true ;;
    *) cli="$arg" ;;
  esac
done

list="$(dirname "$0")/vscode-settings/extensions.txt"

if [[ ! -f "$list" ]]; then
  echo "Arquivo $list não encontrado" >&2
  exit 1
fi

wanted="$(tr -d '\r' < "$list" | tr 'A-Z' 'a-z' | sed '/^\s*$/d')"
to_remove="$($cli --list-extensions | tr -d '\r' | grep -vixFf <(echo "$wanted"))"

if [[ -z "$to_remove" ]]; then
  echo "Nada para remover."
  exit 0
fi

echo "Extensões que serão removidas do $cli:"
echo "$to_remove" | sed 's/^/  - /'

if [[ "$assume_yes" != true ]]; then
  read -r -p "Continuar? [y/N] " answer
  [[ "$answer" =~ ^[yY]$ ]] || { echo "Cancelado."; exit 0; }
fi

echo "$to_remove" | while read -r extension; do
  $cli --uninstall-extension "$extension"
done
