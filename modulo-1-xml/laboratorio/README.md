# 🧪 Laboratorio — Modulo 1: XML, DTD e XSD

Tre sfide di difficoltà crescente. Lavora **da solo/a**, con il terminale aperto: il validatore è il tuo "arbitro".

| # | Sfida | Difficoltà | Tempo | Cosa consegni |
|---|---|:---:|:---:|---|
| 1 | [Ripara l'ordine e-commerce](#-esercizio-1--ripara-lordine-e-commerce) | ⭐ | 15 min | `01-da-correggere.xml` corretto |
| 2 | [DTD per un server Minecraft](#-esercizio-2--dtd-per-un-server-minecraft) | ⭐⭐ | 40 min | `minecraft.dtd` |
| 3 | [XSD per un ordine e-commerce](#-esercizio-3--xsd-per-un-ordine-e-commerce) | ⭐⭐⭐ | 60 min | `ordine.xsd` |

> [!TIP]
> **Regola d'oro del laboratorio:** prima di aprire la soluzione, *prova almeno tre volte* e leggi con attenzione i messaggi del validatore. Un errore capito vale più di dieci soluzioni copiate.

### Come verificare il tuo lavoro

Posizionati in questa cartella (`modulo-1-xml/laboratorio`) ed esegui:

```bash
# Well-formed
../validatori/valida.sh wf  01-da-correggere.xml

# Valido rispetto alla DTD indicata nel DOCTYPE
../validatori/valida.sh dtd 02-minecraft-server.xml

# Valido rispetto a uno schema
../validatori/valida.sh xsd ordine.xsd 03-ordine.xml
```

(In alternativa: `python ../validatori/valida.py …`, oppure direttamente `xmllint`.)

---

## 🔧 Esercizio 1 — Ripara l'ordine e-commerce

⭐ · *Obiettivo: riconoscere e correggere gli errori di sintassi.*

Il file [`01-da-correggere.xml`](01-da-correggere.xml) è il payload di un ordine di un negozio online, scritto di fretta alle 3 di notte. **Non è well-formed**: contiene almeno **5 errori**.

**Traccia**

1. Esegui `../validatori/valida.sh wf 01-da-correggere.xml` e leggi il primo errore.
2. Correggilo, riesegui, e ripeti finché non vedi ✅.
3. Per ciascun errore scrivi **una riga** che spiega quale regola XML era violata.

**Vincolo:** non cancellare elementi per "far passare" il file. Il contenuto dell'ordine deve restare completo.

<details>
<summary>💡 Suggerimento</summary>

Il parser si ferma al **primo** errore, quindi ne troverai uno alla volta. Controlla: gli apici degli attributi, le maiuscole/minuscole nei tag di apertura e chiusura, i tag rimasti aperti, i caratteri riservati nel testo.

</details>

<details>
<summary>✅ Mostra Soluzione</summary>

**File corretto:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- Payload di un ordine e-commerce: versione corretta -->
<ordine id="ORD-2026-0042">
  <cliente>
    <nome>Giulia Rossi</nome>
    <email>giulia.rossi@example.com</email>
  </cliente>
  <articoli>
    <articolo sku="SKU-1001" quantita="2">
      <descrizione>Cuffie Gaming RGB &amp; microfono</descrizione>
      <prezzo>59.90</prezzo>
    </articolo>
    <articolo sku="SKU-2002" quantita="1">
      <descrizione>Mouse "Pro" 16000 DPI</descrizione>
      <prezzo>34.50</prezzo>
    </articolo>
  </articoli>
</ordine>
```

**Gli errori:**

| # | Originale | Correzione | Regola violata |
|---|---|---|---|
| 1 | `<Ordine id=ORD-2026-0042>` | `id="ORD-2026-0042"` | i valori degli attributi vanno **tra apici** |
| 2 | `<Ordine>` … `</ordine>` | `<ordine>` … `</ordine>` | XML è **case-sensitive** |
| 3 | `<email>…` mai chiuso | aggiunto `</email>` | ogni tag aperto va **chiuso** |
| 4 | `RGB & microfono` | `RGB &amp; microfono` | `&` è un carattere **riservato** |
| 5 | `<prezzo>…</Prezzo>` | `</prezzo>` | XML è **case-sensitive** |

**Attenzione a un falso allarme:** le virgolette in `Mouse "Pro" 16000 DPI` **non** sono un errore. Nel *testo* di un elemento i doppi apici sono ammessi; vanno trattati con `&quot;` solo dentro un attributo delimitato da `"`.

</details>

---

## 🎮 Esercizio 2 — DTD per un server Minecraft

⭐⭐ · *Obiettivo: scrivere una DTD completa con sequenze, occorrenze, enumerazioni, ID e IDREF.*

Sei l'amministratore di **SurvivalCraft**, un server Minecraft. Il file [`02-minecraft-server.xml`](02-minecraft-server.xml) contiene la configurazione e richiama una DTD che **non esiste ancora**:

```xml
<!DOCTYPE server SYSTEM "minecraft.dtd">
```

**Traccia:** crea il file **`minecraft.dtd`** (in questa cartella) che rispetti **tutte** le specifiche seguenti.

| Elemento | Specifica |
|---|---|
| `server` | contiene, **in quest'ordine**: `motd`, `world`, `rules` (obbligatori), poi `whitelist`, `ops`, `mods` (**facoltativi**) |
| `server` (attributi) | `name` **obbligatorio**; `port` facoltativo con default `25565` |
| `motd` | solo testo |
| `world` | **nessun contenuto**; attributi: `type` ∈ {`default`, `flat`, `amplified`} (default `default`), `difficulty` ∈ {`peaceful`, `easy`, `normal`, `hard`} (default `normal`), `seed` facoltativo |
| `rules` | **nessun contenuto**; attributi `pvp` e `hardcore` ∈ {`true`, `false`} (default `true` e `false`), `maxPlayers` con default `20` |
| `whitelist` | **almeno un** `player`; attributo `enabled` ∈ {`true`, `false`} (default `true`) |
| `player` | solo testo (il nome); attributo `id` di tipo **identificatore univoco**, obbligatorio |
| `ops` | **almeno un** `op` |
| `op` | **nessun contenuto**; `player` = **riferimento** a un `player` esistente (obbligatorio); `level` ∈ {`1`, `2`, `3`, `4`} (default `4`) |
| `mods` | **zero o più** `mod`, ciascuno solo testo |

**Verifica**

```bash
# DEVE passare ✅
../validatori/valida.sh dtd 02-minecraft-server.xml

# DEVE fallire ❌ (almeno 5 errori: la tua DTD deve accorgersene)
../validatori/valida.sh dtd 02-minecraft-server-errato.xml
```

Il file [`02-minecraft-server-errato.xml`](02-minecraft-server-errato.xml) è un test "al contrario": se la tua DTD lo accetta, è **troppo permissiva**.

**Domanda di riflessione:** perché `difficulty` è stato modellato come **attributo** di `world` e non come elemento `<difficulty>hard</difficulty>`?

<details>
<summary>💡 Suggerimento</summary>

- Elementi **senza contenuto** → `EMPTY`.
- "Obbligatori in ordine" → sequenza con la **virgola**; "facoltativo" → `?`; "almeno uno" → `+`; "zero o più" → `*`.
- Per i valori ammessi usa l'**enumerazione** `(a|b|c)` direttamente nell'`ATTLIST`.
- `player/@id` → `ID`; `op/@player` → `IDREF`. Ricorda che un `ID` **non può iniziare con una cifra**.

</details>

<details>
<summary>✅ Mostra Soluzione</summary>

**`minecraft.dtd`**

```dtd
<!-- minecraft.dtd - regole per la configurazione del server -->

<!-- Radice: motd, world e rules sono obbligatori; whitelist, ops e mods sono opzionali -->
<!ELEMENT server (motd, world, rules, whitelist?, ops?, mods?)>
<!ATTLIST server
    name CDATA #REQUIRED
    port CDATA "25565">

<!ELEMENT motd (#PCDATA)>

<!-- world non ha contenuto: tutta l'informazione sta negli attributi -->
<!ELEMENT world EMPTY>
<!ATTLIST world
    type       (default|flat|amplified)          "default"
    difficulty (peaceful|easy|normal|hard)       "normal"
    seed       CDATA                             #IMPLIED>

<!ELEMENT rules EMPTY>
<!ATTLIST rules
    pvp        (true|false) "true"
    hardcore   (true|false) "false"
    maxPlayers CDATA        "20">

<!ELEMENT whitelist (player+)>
<!ATTLIST whitelist enabled (true|false) "true">
<!ELEMENT player (#PCDATA)>
<!ATTLIST player id ID #REQUIRED>

<!ELEMENT ops (op+)>
<!ELEMENT op EMPTY>
<!ATTLIST op
    player IDREF  #REQUIRED
    level  (1|2|3|4) "4">

<!ELEMENT mods (mod*)>
<!ELEMENT mod (#PCDATA)>
```

**Errori che la DTD individua nel file `errato`:**

| Problema nel file | Regola della DTD |
|---|---|
| `<server>` senza `name` | `#REQUIRED` |
| `difficulty="extreme"` | enumerazione `(peaceful\|easy\|normal\|hard)` |
| `pvp="forse"` | enumerazione `(true\|false)` |
| due `player` con `id="p1"` | `ID` univoco |
| `op player="p9"` | `IDREF` verso un ID inesistente |

**Risposta alla domanda di riflessione:** una DTD può limitare i valori **solo degli attributi** (con l'enumerazione). Per un elemento di testo come `<difficulty>` può dire soltanto `#PCDATA`, quindi `<difficulty>extreme</difficulty>` sarebbe stato accettato. Modellare `difficulty` come attributo è il modo per avere un controllo reale. Con **XSD** questo compromesso non serve: l'enumerazione funziona anche sugli elementi.

</details>

---

## 🛒 Esercizio 3 — XSD per un ordine e-commerce

⭐⭐⭐ · *Obiettivo: scrivere uno XML Schema con tipi semplici, restrizioni, tipi complessi e `simpleContent`.*

Il file [`03-ordine.xml`](03-ordine.xml) è il payload di un ordine. Richiama lo schema **che devi scrivere tu**:

```xml
<ordine xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="ordine.xsd" ...>
```

**Traccia:** crea il file **`ordine.xsd`** (in questa cartella; schema **senza** namespace) con queste regole.

| Elemento / attributo | Regola |
|---|---|
| `ordine` | sequenza: `cliente`, `articoli`, `spedizione` |
| `ordine/@id` | obbligatorio, formato `ORD-` + 4 cifre + `-` + 4 cifre (es. `ORD-2026-0042`) |
| `ordine/@data` | obbligatorio, di tipo **data** |
| `cliente` | sequenza: `nome` (testo), `email` |
| `email` | formato semplice `qualcosa@dominio.estensione` (nessuno spazio, un solo `@`, estensione di almeno 2 lettere) |
| `articoli` | **uno o più** `articolo` |
| `articolo` | sequenza: `descrizione` (testo), `prezzo` |
| `articolo/@sku` | obbligatorio, formato `SKU-` + 4 cifre |
| `articolo/@quantita` | obbligatorio, intero **da 1 a 10** |
| `prezzo` | numero decimale **> 0** con **al massimo 2 decimali**, **più** attributo obbligatorio `valuta` ∈ {`EUR`, `USD`} |
| `spedizione` | solo `standard` oppure `express` |

**Verifica**

```bash
# DEVE passare ✅
../validatori/valida.sh xsd ordine.xsd 03-ordine.xml

# DEVE fallire ❌ (almeno 7 errori di tipo)
../validatori/valida.sh xsd ordine.xsd 03-ordine-errato.xml
```

<details>
<summary>💡 Suggerimento</summary>

- Crea prima i **tipi semplici** (`xs:simpleType` + `xs:restriction`), poi i tipi complessi che li usano.
- `prezzo` ha **testo + attributo**: ti serve un `xs:complexType` con `xs:simpleContent` e `xs:extension`.
- "da 1 a 10" → parti da `xs:positiveInteger` e aggiungi `maxInclusive`, oppure usa `xs:integer` con `minInclusive` e `maxInclusive`.
- "maggiore di 0" (escluso lo zero) → `minExclusive`. "Al massimo 2 decimali" → `fractionDigits`.
- Nei `pattern` **non** servono `^` e `$`.

</details>

<details>
<summary>✅ Mostra Soluzione</summary>

**`ordine.xsd`**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <!-- ===== Tipi semplici con restrizioni ===== -->
  <xs:simpleType name="OrdineIdType">
    <xs:restriction base="xs:string">
      <xs:pattern value="ORD-[0-9]{4}-[0-9]{4}"/>
    </xs:restriction>
  </xs:simpleType>

  <xs:simpleType name="EmailType">
    <xs:restriction base="xs:string">
      <xs:pattern value="[^@\s]+@[^@\s]+\.[a-zA-Z]{2,}"/>
    </xs:restriction>
  </xs:simpleType>

  <xs:simpleType name="SkuType">
    <xs:restriction base="xs:string">
      <xs:pattern value="SKU-[0-9]{4}"/>
    </xs:restriction>
  </xs:simpleType>

  <xs:simpleType name="QuantitaType">
    <xs:restriction base="xs:positiveInteger">
      <xs:maxInclusive value="10"/>
    </xs:restriction>
  </xs:simpleType>

  <xs:simpleType name="ImportoType">
    <xs:restriction base="xs:decimal">
      <xs:minExclusive value="0"/>
      <xs:fractionDigits value="2"/>
    </xs:restriction>
  </xs:simpleType>

  <xs:simpleType name="ValutaType">
    <xs:restriction base="xs:string">
      <xs:enumeration value="EUR"/>
      <xs:enumeration value="USD"/>
    </xs:restriction>
  </xs:simpleType>

  <xs:simpleType name="SpedizioneType">
    <xs:restriction base="xs:string">
      <xs:enumeration value="standard"/>
      <xs:enumeration value="express"/>
    </xs:restriction>
  </xs:simpleType>

  <!-- ===== Tipo complesso con contenuto semplice + attributo ===== -->
  <xs:complexType name="PrezzoType">
    <xs:simpleContent>
      <xs:extension base="ImportoType">
        <xs:attribute name="valuta" type="ValutaType" use="required"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- ===== Struttura del documento ===== -->
  <xs:element name="ordine">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="cliente">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="nome"  type="xs:string"/>
              <xs:element name="email" type="EmailType"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="articoli">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="articolo" maxOccurs="unbounded">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="descrizione" type="xs:string"/>
                    <xs:element name="prezzo"      type="PrezzoType"/>
                  </xs:sequence>
                  <xs:attribute name="sku"      type="SkuType"      use="required"/>
                  <xs:attribute name="quantita" type="QuantitaType" use="required"/>
                </xs:complexType>
              </xs:element>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="spedizione" type="SpedizioneType"/>
      </xs:sequence>
      <xs:attribute name="id"   type="OrdineIdType" use="required"/>
      <xs:attribute name="data" type="xs:date"      use="required"/>
    </xs:complexType>
  </xs:element>

</xs:schema>
```

**Errori che lo schema individua in `03-ordine-errato.xml`:**

| Problema nel file | Vincolo violato |
|---|---|
| `id="ORD-42"` | `pattern` `ORD-[0-9]{4}-[0-9]{4}` |
| `data="17-10-2026"` | tipo `xs:date` (serve `AAAA-MM-GG`) |
| `email` = `giulia.rossi` | `pattern` dell'email |
| `sku="1001"` | `pattern` `SKU-[0-9]{4}` |
| `quantita="0"` | `xs:positiveInteger` (≥ 1) |
| `valuta="YEN"` | `enumeration` {EUR, USD} |
| prezzo `-59.90` | `minExclusive` 0 |
| `spedizione` = `drone` | `enumeration` {standard, express} |

**Nota:** con `xmllint` il file di prova produce **8 messaggi d'errore**, uno per ogni violazione della tabella.

</details>

---

## 🏆 Sfide bonus

Per chi ha finito in anticipo (nessuna soluzione fornita: usa i validatori come arbitro).

1. **DTD → XSD.** Riscrivi la `minecraft.dtd` come schema XSD. Cosa guadagni? (Suggerimento: `maxPlayers` può diventare un intero tra 1 e 200; `port` un intero tra 1024 e 65535.)
2. **Chiavi.** Nello schema dell'esercizio 2 usa `xs:key` e `xs:keyref` al posto di `ID` / `IDREF`, imponendo che gli `id` abbiano la forma `p` + numero.
3. **Coupon.** Nell'ordine aggiungi un elemento **facoltativo** `coupon` con formato `SCONTO-` + 2 cifre, e un attributo `stato` ∈ {`attivo`, `scaduto`}.
4. **Log di sistema.** Scrivi XML e **XSD** per un file di log con righe `entry` che hanno `level` ∈ {`INFO`, `WARN`, `ERROR`}, un `timestamp` di tipo `xs:dateTime` e un messaggio. Aggiungi un `xs:unique` sugli identificatori di richiesta.

## ✅ Checklist finale

- [ ] So spiegare la differenza tra *well-formed* e *valido*
- [ ] So scrivere una DTD con sequenze, occorrenze, enumerazioni, `ID` e `IDREF`
- [ ] So elencare almeno 3 limiti della DTD che XSD supera
- [ ] So scrivere uno schema con `xs:simpleType`, `xs:complexType`, `xs:sequence` e `xs:pattern`
- [ ] So validare un documento da riga di comando

➡️ Prossimo: **[Modulo 2 — JSON](../../modulo-2-json/README.md)**
