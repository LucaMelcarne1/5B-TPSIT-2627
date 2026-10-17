#!/usr/bin/env bash
# ------------------------------------------------------------------
# valida.sh - Validatore XML didattico basato su xmllint (libxml2)
#
# Uso:
#   ./valida.sh wf  <file.xml>               controlla se il file è WELL-FORMED
#   ./valida.sh dtd <file.xml>               valida contro la DTD indicata nel DOCTYPE
#   ./valida.sh xsd <schema.xsd> <file.xml>  valida contro un XML Schema
#
# Installazione di xmllint:
#   Debian/Ubuntu : sudo apt install libxml2-utils
#   Fedora        : sudo dnf install libxml2
#   macOS         : già incluso (oppure: brew install libxml2)
#   Windows       : usa WSL oppure lo script valida.py
# ------------------------------------------------------------------

set -u

VERDE='\033[0;32m'; ROSSO='\033[0;31m'; GIALLO='\033[0;33m'; RESET='\033[0m'

uso() {
  sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
}

if ! command -v xmllint >/dev/null 2>&1; then
  echo -e "${ROSSO}xmllint non trovato.${RESET} Installa libxml2-utils (vedi intestazione dello script)."
  exit 127
fi

[ $# -lt 2 ] && uso

modo="$1"

case "$modo" in
  wf)
    file="$2"
    echo -e "${GIALLO}▶ Controllo well-formed:${RESET} $file"
    if xmllint --noout "$file"; then
      echo -e "${VERDE}✅ Il documento è WELL-FORMED${RESET}"
    else
      echo -e "${ROSSO}❌ Il documento NON è well-formed${RESET}"
      exit 1
    fi
    ;;
  dtd)
    file="$2"
    echo -e "${GIALLO}▶ Validazione DTD:${RESET} $file"
    if xmllint --noout --valid "$file"; then
      echo -e "${VERDE}✅ Il documento è VALIDO rispetto alla DTD${RESET}"
    else
      echo -e "${ROSSO}❌ Il documento NON è valido (o non è well-formed)${RESET}"
      exit 1
    fi
    ;;
  xsd)
    [ $# -lt 3 ] && uso
    schema="$2"; file="$3"
    echo -e "${GIALLO}▶ Validazione XSD:${RESET} $file  ←  $schema"
    if xmllint --noout --schema "$schema" "$file"; then
      echo -e "${VERDE}✅ Il documento è VALIDO rispetto allo schema${RESET}"
    else
      echo -e "${ROSSO}❌ Il documento NON è valido rispetto allo schema${RESET}"
      exit 1
    fi
    ;;
  *)
    uso
    ;;
esac
