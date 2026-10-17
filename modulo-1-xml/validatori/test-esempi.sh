#!/usr/bin/env bash
# ------------------------------------------------------------------
# test-esempi.sh - Esegue TUTTI gli esempi del Modulo 1 e controlla
# che l'esito sia quello previsto (i file "non validi" devono FALLIRE!).
# Uso:  ./test-esempi.sh
# ------------------------------------------------------------------
cd "$(dirname "$0")/../esempi" || exit 1

command -v xmllint >/dev/null 2>&1 || { echo "xmllint non trovato (apt install libxml2-utils)"; exit 127; }

PASS=0; FAIL=0

# attesa <ok|ko> <descrizione> <comando...>
attesa() {
  local atteso="$1" desc="$2"; shift 2
  local esito=ko
  "$@" >/dev/null 2>&1 && esito=ok
  if [ "$esito" = "$atteso" ]; then
    printf '  ✅ %-52s atteso: %s\n' "$desc" "$atteso"; PASS=$((PASS+1))
  else
    printf '  ❌ %-52s atteso: %s, ottenuto: %s\n' "$desc" "$atteso" "$esito"; FAIL=$((FAIL+1))
  fi
}

echo "== 1. XML well-formed =="
attesa ok "01-sintassi/server-config.xml" xmllint --noout 01-sintassi/server-config.xml
for f in 01-sintassi/errori/*.xml; do
  attesa ko "$f" xmllint --noout "$f"
done

echo "== 2. DTD =="
attesa ok "02-dtd/server-dtd-esterna.xml"     xmllint --noout --valid 02-dtd/server-dtd-esterna.xml
attesa ok "02-dtd/server-dtd-interna.xml"     xmllint --noout --valid 02-dtd/server-dtd-interna.xml
attesa ko "02-dtd/server-dtd-non-valido.xml"  xmllint --noout --valid 02-dtd/server-dtd-non-valido.xml

echo "== 3. XML Schema =="
attesa ok "03-xsd/server-xsd-valido.xml"      xmllint --noout --schema 03-xsd/game-server.xsd 03-xsd/server-xsd-valido.xml
attesa ko "03-xsd/server-xsd-non-valido.xml"  xmllint --noout --schema 03-xsd/game-server.xsd 03-xsd/server-xsd-non-valido.xml

echo
echo "Risultato: $PASS test superati, $FAIL falliti"
[ "$FAIL" -eq 0 ]
