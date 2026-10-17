#!/usr/bin/env python3
"""
valida.py - Validatore XML didattico basato su lxml (funziona anche su Windows).

Installazione:   pip install lxml

Uso:
    python valida.py wf  file.xml               # well-formed?
    python valida.py dtd file.xml               # valido rispetto alla DTD nel DOCTYPE?
    python valida.py xsd schema.xsd file.xml    # valido rispetto a un XML Schema?
"""
import sys

try:
    from lxml import etree
except ImportError:
    sys.exit("Libreria lxml mancante. Installala con:  pip install lxml")

OK = "\033[0;32m✅ {}\033[0m"
KO = "\033[0;31m❌ {}\033[0m"


def stampa_errori(log):
    """Mostra gli errori in formato 'riga N: messaggio'."""
    for e in log:
        print(f"   riga {e.line}: {e.message}")


def controlla_well_formed(percorso):
    try:
        etree.parse(percorso)
    except etree.XMLSyntaxError as exc:
        print(KO.format("Il documento NON è well-formed"))
        stampa_errori(exc.error_log)
        return False
    print(OK.format("Il documento è WELL-FORMED"))
    return True


def controlla_dtd(percorso):
    # load_dtd=True carica la DTD esterna, dtd_validation=True la applica
    parser = etree.XMLParser(dtd_validation=True, load_dtd=True, no_network=True)
    try:
        etree.parse(percorso, parser)
    except etree.XMLSyntaxError as exc:
        print(KO.format("Il documento NON è valido (o non è well-formed)"))
        stampa_errori(exc.error_log)
        return False
    print(OK.format("Il documento è VALIDO rispetto alla DTD"))
    return True


def controlla_xsd(percorso_xsd, percorso_xml):
    try:
        schema = etree.XMLSchema(etree.parse(percorso_xsd))
        documento = etree.parse(percorso_xml)
    except (etree.XMLSyntaxError, etree.XMLSchemaParseError) as exc:
        print(KO.format("Schema o documento non leggibili"))
        stampa_errori(exc.error_log)
        return False
    if schema.validate(documento):
        print(OK.format("Il documento è VALIDO rispetto allo schema"))
        return True
    print(KO.format("Il documento NON è valido rispetto allo schema"))
    stampa_errori(schema.error_log)
    return False


def main(argv):
    if len(argv) < 3 or argv[1] not in {"wf", "dtd", "xsd"}:
        print(__doc__)
        return 2
    modo = argv[1]
    if modo == "wf":
        esito = controlla_well_formed(argv[2])
    elif modo == "dtd":
        esito = controlla_dtd(argv[2])
    else:
        if len(argv) < 4:
            print(__doc__)
            return 2
        esito = controlla_xsd(argv[2], argv[3])
    return 0 if esito else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
