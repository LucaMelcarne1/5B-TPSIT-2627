# 📘 Modulo 1 — XML, DTD e XML Schema (XSD)

> **Obiettivo:** imparare a *descrivere*, *scrivere* e *validare* dati strutturati con XML, usando come scenari un **Game Server**, i **log di sistema** e un **ordine e-commerce**.

| ⏱️ Tempo stimato | 🎯 Livello | 🧰 Strumenti |
|---|---|---|
| 8–10 ore (teoria + laboratorio) | 5ª Informatica | editor di testo (VS Code), `xmllint` **oppure** Python/`lxml` **oppure** Java |

## ✅ Al termine del modulo saprai

- [ ] scrivere un documento XML **well-formed** e riconoscere gli errori più comuni
- [ ] definire la struttura di un documento con una **DTD** (interna ed esterna)
- [ ] usare **ID / IDREF** per creare riferimenti tra elementi
- [ ] scrivere uno **XML Schema** con tipi semplici, tipi complessi, restrizioni e namespace
- [ ] spiegare **perché XSD è più potente di DTD** e quando conviene ancora una DTD
- [ ] validare documenti da riga di comando e da codice (Python / Java)

## 🗺️ Indice

1. [Introduzione a XML](#1-introduzione-a-xml)
2. [XML — Sintassi](#2-xml--sintassi)
3. [XML DTD](#3-xml-dtd-document-type-definition)
4. [XML Schema (XSD)](#4-xml-schema-xsd)
5. [Come si valida un documento](#5-come-si-valida-un-documento)
6. [Riepilogo e quiz](#6-riepilogo-e-quiz)
7. [Laboratorio autonomo](laboratorio/README.md)

## 📂 File di questo modulo

| Cartella | Contenuto |
|---|---|
| [`esempi/01-sintassi/`](esempi/01-sintassi) | `server-config.xml` (well-formed) + cartella `errori/` con 8 file **volutamente sbagliati** |
| [`esempi/02-dtd/`](esempi/02-dtd) | `game-server.dtd`, DTD esterna e interna, un file **non valido** |
| [`esempi/03-xsd/`](esempi/03-xsd) | `game-server.xsd`, un documento valido e uno non valido |
| [`validatori/`](validatori) | `valida.sh` (xmllint), `valida.py` (lxml), `ValidaXsd.java`, `test-esempi.sh` |
| [`laboratorio/`](laboratorio) | 3 esercizi con soluzione nascosta |

> [!TIP]
> **Learn by doing!** Ogni sezione ha un riquadro **▶ Provalo tu**: apri il file, eseguilo, poi *rompilo apposta* e leggi il messaggio d'errore. È il modo più veloce per imparare.

---

## 1. Introduzione a XML

**XML** (*eXtensible Markup Language*) è un linguaggio a marcatori per **descrivere dati**. È una raccomandazione del **W3C** (versione 1.0 del 1998).

- È **testuale**: si legge e si scrive con qualsiasi editor.
- È **autodescrittivo**: i tag spiegano cosa contengono i dati.
- È **estensibile**: i tag non sono predefiniti, **li inventi tu**.
- È **indipendente** da piattaforma e linguaggio di programmazione.

```xml
<player id="P001">
  <nickname>DragonSlayer</nickname>
  <level>87</level>
</player>
```

### XML vs HTML

| | **HTML** | **XML** |
|---|---|---|
| Scopo | *Mostrare* i dati | *Descrivere e trasportare* i dati |
| Tag | Predefiniti (`<p>`, `<h1>`…) | Inventati dall'autore |
| Errori di sintassi | Il browser è tollerante | Il parser **si ferma** al primo errore |
| Maiuscole/minuscole | Indifferente | **Case-sensitive** |

### Dove lo incontri davvero

| Ambito | Esempio |
|---|---|
| Configurazione | `pom.xml` di Maven, `AndroidManifest.xml`, file di configurazione di Spring |
| Interfacce grafiche | Layout Android (`activity_main.xml`), FXML di JavaFX |
| Grafica vettoriale | File **SVG** |
| Feed e web | **RSS / Atom**, `sitemap.xml` |
| Servizi web | **SOAP / WSDL** |
| Documenti Office | `.docx`, `.xlsx`, `.pptx` sono archivi ZIP che contengono file XML |

> [!NOTE]
> Per lo scambio dati nelle API moderne si usa spesso JSON (Modulo 2), ma XML resta fondamentale dove servono **validazione rigorosa**, **namespace** e **documenti strutturati**.

---

## 2. XML — Sintassi

### 2.1 Il tuo primo documento

File completo: [`esempi/01-sintassi/server-config.xml`](esempi/01-sintassi/server-config.xml)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- Configurazione del Game Server ArenaCraft -->
<gameServer name="ArenaCraft EU-1" region="EU" version="2.4.1">

  <network>
    <ip>192.168.1.10</ip>
    <port>25565</port>
    <maxPlayers>100</maxPlayers>
  </network>

  <gameMode>survival</gameMode>

  <players>
    <player id="P001" role="admin">
      <nickname>DragonSlayer</nickname>
      <level>87</level>
    </player>
  </players>

</gameServer>
```

### 2.2 L'albero XML

Un documento XML è sempre un **albero**: ha **una sola radice** (*root*) e ogni elemento può contenere altri elementi (*figli*).

```text
gameServer                    ← elemento radice
├── @name = "ArenaCraft EU-1" ← attributo
├── network                   ← elemento figlio
│   ├── ip        → "192.168.1.10"   ← nodo di testo
│   ├── port      → "25565"
│   └── maxPlayers→ "100"
├── gameMode      → "survival"
└── players
    └── player
        ├── @id = "P001"
        ├── nickname → "DragonSlayer"
        └── level    → "87"
```

I **tipi di nodo** che incontrerai (e che il parser DOM ti restituisce):

| Nodo | Esempio |
|---|---|
| Elemento | `<port>25565</port>` |
| Attributo | `region="EU"` |
| Testo | `25565` |
| Commento | `<!-- nota -->` |
| Istruzione di elaborazione | `<?xml-stylesheet href="stile.css"?>` |
| Sezione CDATA | `<![CDATA[ ... ]]>` |

### 2.3 Il prologo

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
```

| Parte | Obbligatoria? | Significato |
|---|---|---|
| `version` | **Sì** | Versione di XML (usa `1.0`) |
| `encoding` | No | Codifica dei caratteri. Default UTF-8: dichiarala sempre, soprattutto se usi lettere accentate |
| `standalone` | No | `yes` = il documento non dipende da DTD esterne |

> [!WARNING]
> Il prologo, se presente, deve essere **la primissima cosa del file**: nemmeno una riga vuota o un commento può precederlo (vedi [`07-prologo-non-in-prima-riga.xml`](esempi/01-sintassi/errori/07-prologo-non-in-prima-riga.xml)).

### 2.4 Le regole d'oro (documento *well-formed*)

| # | Regola | Esempio corretto |
|---|---|---|
| 1 | **Una sola radice** | `<a>…</a>` e basta |
| 2 | Ogni tag aperto va **chiuso** | `<level>87</level>` |
| 3 | I tag vanno **annidati correttamente** | `<a><b></b></a>` e non `<a><b></a></b>` |
| 4 | XML è **case-sensitive** | `<Player>` ≠ `<player>` |
| 5 | I valori degli attributi vanno **tra apici** | `id="P001"` |
| 6 | Un attributo **non può ripetersi** nello stesso elemento | `<p id="1" role="x">` |
| 7 | I caratteri riservati `<` e `&` vanno **sostituiti** con entità | `&lt;` `&amp;` |
| 8 | Gli elementi vuoti si scrivono `<br/>` oppure `<br></br>` | `<world type="flat"/>` |

### 2.5 Nomi degli elementi

- possono contenere lettere, cifre, `-`, `_`, `.`
- **non** possono iniziare con una cifra o un segno di punteggiatura
- **non** possono contenere spazi
- **non** devono iniziare con `xml` (in qualsiasi combinazione di maiuscole/minuscole): è riservato
- evita i due punti `:` (servono per i namespace)

> [!TIP]
> Scegli nomi **descrittivi e coerenti**: `<maxPlayers>` o `<max_players>`, ma non un po' l'uno e un po' l'altro.

### 2.6 Elementi o attributi?

La stessa informazione si può scrivere in due modi:

```xml
<!-- come attributi -->
<player id="P001" role="admin" level="87"/>

<!-- come elementi -->
<player>
  <id>P001</id>
  <role>admin</role>
  <level>87</level>
</player>
```

| Usa **elementi** quando… | Usa **attributi** quando… |
|---|---|
| il dato è il **contenuto** vero e proprio | il dato è un **metadato** (id, tipo, stato) |
| il dato può **ripetersi** o avere sotto-struttura | il valore è **semplice e unico** |
| l'ordine è importante | l'ordine non conta (gli attributi non hanno ordine) |

> [!NOTE]
> Regola pratica: **gli attributi descrivono i dati, gli elementi *sono* i dati**. Un attributo non può contenere figli né ripetersi: nei casi dubbi scegli un elemento.

### 2.7 Commenti, CDATA e istruzioni di elaborazione

```xml
<!-- Un commento: non può contenere due trattini consecutivi -->

<startupScript><![CDATA[
  if (players < 10 && mode == "event") { announce("Evento <speciale>!"); }
]]></startupScript>
```

- Dentro una sezione **CDATA** il parser **non interpreta nulla**: puoi scrivere `<`, `>`, `&` liberamente. L'unica sequenza vietata è `]]>`.
- I commenti **non** possono stare dentro un tag (`<player <!-- no --> id="1">` è un errore).

### 2.8 Entità

Le **entità** sono scorciatoie che il parser sostituisce con un testo. Ne esistono 5 predefinite:

| Entità | Carattere | Quando è obbligatoria |
|---|---|---|
| `&lt;` | `<` | sempre nel testo |
| `&amp;` | `&` | sempre nel testo |
| `&gt;` | `>` | facoltativa (utile per `]]>`) |
| `&quot;` | `"` | dentro un attributo delimitato da `"` |
| `&apos;` | `'` | dentro un attributo delimitato da `'` |

Si possono anche usare i **riferimenti numerici**: `&#9876;` produce ⚔ (e `&#x2694;` è lo stesso carattere in esadecimale).
Le entità **personalizzate** si definiscono in una DTD (vedi [§3.5](#35-entità)).

### 2.9 Gli errori più comuni

La cartella [`esempi/01-sintassi/errori/`](esempi/01-sintassi/errori) contiene un file per ogni errore. Ognuno ha un commento che spiega cosa non va.

| File | Errore | Messaggio di `xmllint` |
|---|---|---|
| [`01-tag-non-chiuso.xml`](esempi/01-sintassi/errori/01-tag-non-chiuso.xml) | `<nickname>` mai chiuso | `Opening and ending tag mismatch: nickname line 4 and player` |
| [`02-annidamento-errato.xml`](esempi/01-sintassi/errori/02-annidamento-errato.xml) | `</entry>` prima di `</message>` | `Opening and ending tag mismatch: message line 4 and entry` |
| [`03-attributo-senza-apici.xml`](esempi/01-sintassi/errori/03-attributo-senza-apici.xml) | `port=25565` | `AttValue: " or ' expected` |
| [`04-due-radici.xml`](esempi/01-sintassi/errori/04-due-radici.xml) | due elementi radice | `Extra content at the end of the document` |
| [`05-carattere-riservato.xml`](esempi/01-sintassi/errori/05-carattere-riservato.xml) | `<` e `&` nel testo | `StartTag: invalid element name` |
| [`06-case-sensitive.xml`](esempi/01-sintassi/errori/06-case-sensitive.xml) | `<Player>` … `</player>` | `Opening and ending tag mismatch: Player line 3 and player` |
| [`07-prologo-non-in-prima-riga.xml`](esempi/01-sintassi/errori/07-prologo-non-in-prima-riga.xml) | commento prima del prologo | `XML declaration allowed only at the start of the document` |
| [`08-attributo-duplicato.xml`](esempi/01-sintassi/errori/08-attributo-duplicato.xml) | `id` ripetuto | `Attribute id redefined` |

> [!NOTE]
> Il parser XML è **intransigente**: si ferma al **primo** errore fatale. Correggi, riesegui, e ripeti finché il documento non passa.

### ▶ Provalo tu

```bash
cd modulo-1-xml/validatori

# Questo passa:
./valida.sh wf ../esempi/01-sintassi/server-config.xml

# Questi falliscono: leggi i messaggi!
./valida.sh wf ../esempi/01-sintassi/errori/02-annidamento-errato.xml
./valida.sh wf ../esempi/01-sintassi/errori/05-carattere-riservato.xml
```

Poi **rompi apposta** `server-config.xml`: togli un `</port>`, cambia `id="P001"` in `id=P001`, scrivi `Tom & Jerry` nel `<motd>`.

### 2.10 Well-formed ≠ Valid

| | **Well-formed** (ben formato) | **Valid** (valido) |
|---|---|---|
| Cosa controlla | La **sintassi** XML | La **struttura e i contenuti** rispetto a una DTD o a uno Schema |
| Chi lo richiede | **Tutti** i parser XML | Solo se richiesto esplicitamente |
| Esempio di violazione | tag non chiuso | `<level>` mancante in un `<player>` |

Ogni documento valido è well-formed, **ma non viceversa**.

---

## 3. XML DTD (Document Type Definition)

### 3.1 Perché serve

Immagina che il tuo server debba leggere i file di configurazione scritti da altri. Come fai a sapere che ogni `<player>` ha un `id`? Che `<network>` contiene `ip`, `port` e `maxPlayers` **in quest'ordine**?

Una **DTD** è un insieme di regole che dichiara:

- quali **elementi** sono ammessi e in che **ordine / quantità**
- quali **attributi** ha ciascun elemento, di che tipo, se obbligatori
- quali **entità** sono definite

Un documento che rispetta la DTD si dice **valido**.

### 3.2 DTD interna ed esterna

**Interna** — le regole stanno *dentro* il documento, tra `[` e `]`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE syslog [
  <!ELEMENT syslog (entry+)>
  <!ELEMENT entry (timestamp, source, message)>
  <!ATTLIST entry level (INFO|WARN|ERROR) #REQUIRED>
  <!ELEMENT timestamp (#PCDATA)>
  <!ELEMENT source    (#PCDATA)>
  <!ELEMENT message   (#PCDATA)>
]>
<syslog>
  <entry level="ERROR">
    <timestamp>2026-10-17T09:54:40</timestamp>
    <source>database</source>
    <message>Connessione al DB scaduta (timeout 30s)</message>
  </entry>
</syslog>
```

File completo: [`server-dtd-interna.xml`](esempi/02-dtd/server-dtd-interna.xml)

**Esterna** — le regole stanno in un file `.dtd` separato, richiamato con `SYSTEM`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE gameServer SYSTEM "game-server.dtd">
<gameServer name="ArenaCraft EU-1"> ... </gameServer>
```

| | DTD **interna** | DTD **esterna** |
|---|---|---|
| Dove sono le regole | nel documento | in un file `.dtd` |
| Riutilizzabile da più documenti | ❌ | ✅ |
| Documento autonomo | ✅ | ❌ (serve il file `.dtd`) |
| Uso tipico | prove, esempi, documenti singoli | progetti reali, standard condivisi |

> [!NOTE]
> Esiste anche la forma `PUBLIC "identificatore-pubblico" "file.dtd"`, usata per le DTD standard (per esempio quelle di XHTML). Nei progetti scolastici userai quasi sempre `SYSTEM`.

> [!IMPORTANT]
> Il nome dopo `DOCTYPE` deve coincidere con il nome dell'**elemento radice** (`gameServer`, `syslog`…).

### 3.3 Dichiarare gli elementi — `<!ELEMENT>`

```text
<!ELEMENT nome  modello-di-contenuto>
```

| Modello di contenuto | Significato | Esempio |
|---|---|---|
| `(#PCDATA)` | solo testo | `<!ELEMENT nickname (#PCDATA)>` |
| `EMPTY` | nessun contenuto (solo attributi) | `<!ELEMENT world EMPTY>` |
| `ANY` | qualsiasi contenuto *(sconsigliato: annulla i controlli)* | `<!ELEMENT note ANY>` |
| `(a, b, c)` | **sequenza**: a poi b poi c, **in ordine** | `(ip, port, maxPlayers)` |
| `(a \| b)` | **scelta**: a **oppure** b | `(email \| telefono)` |

**Indicatori di occorrenza** (si mettono *dopo* il nome o il gruppo):

| Simbolo | Significato | Numero di volte |
|---|---|---|
| *(nessuno)* | esattamente una volta | 1 |
| `?` | opzionale | 0 o 1 |
| `*` | zero o più | 0, 1, 2, … |
| `+` | una o più | 1, 2, 3, … |

Esempio dal nostro server:

```dtd
<!ELEMENT gameServer (motd?, network, gameMode, plugins?, players, bans?)>
<!ELEMENT players (player+)>      <!-- almeno un giocatore -->
<!ELEMENT plugins (plugin*)>      <!-- zero o più plugin -->
```

Si legge: *un `gameServer` contiene un `motd` facoltativo, poi un `network`, poi un `gameMode`, poi `plugins` facoltativo, poi `players`, poi `bans` facoltativo.*

> [!WARNING]
> Con la **virgola** l'**ordine è obbligatorio**. Se nel file XML scrivi `<gameMode>` prima di `<network>`, il documento **non è valido** (lo vedrai nel file di errori).

**Contenuto misto** (testo e tag insieme, per esempio un messaggio di chat con parole in grassetto):

```dtd
<!ELEMENT messaggio (#PCDATA | b | i)*>
```

### 3.4 Dichiarare gli attributi — `<!ATTLIST>`

```text
<!ATTLIST nome-elemento
    nome-attributo  tipo  dichiarazione-di-default>
```

**Tipi di attributo**

| Tipo | Significato | Esempio |
|---|---|---|
| `CDATA` | testo qualsiasi | `name CDATA #REQUIRED` |
| `(a\|b\|c)` | **enumerazione**: un valore tra quelli elencati | `region (EU\|US\|ASIA) "EU"` |
| `ID` | identificatore **univoco** in tutto il documento | `id ID #REQUIRED` |
| `IDREF` | **riferimento** a un `ID` esistente | `player IDREF #REQUIRED` |
| `IDREFS` | più riferimenti separati da spazi | `amici IDREFS #IMPLIED` |
| `NMTOKEN` | una "parola" senza spazi | `lang NMTOKEN #IMPLIED` |

**Dichiarazioni di default**

| Dichiarazione | Significato |
|---|---|
| `#REQUIRED` | l'attributo è **obbligatorio** |
| `#IMPLIED` | l'attributo è **facoltativo** |
| `"valore"` | facoltativo; se manca, il parser usa questo valore |
| `#FIXED "valore"` | l'attributo, se presente, deve avere **esattamente** quel valore |

#### ID e IDREF: i "collegamenti" di XML

```xml
<player id="P004"> ... </player>                 <!-- dichiara l'ID -->
<ban player="P004" by="P001"> ... </ban>         <!-- riferimenti agli ID -->
```

- Un valore `ID` deve essere **univoco in tutto il documento**, anche tra elementi diversi.
- Deve essere un **nome XML valido**: **non può iniziare con una cifra**. `id="P004"` va bene, `id="4"` **no**.
- Un `IDREF` che punta a un ID inesistente rende il documento **non valido**.

> [!TIP]
> Pensa a `ID` come alla **chiave primaria** e a `IDREF` come alla **chiave esterna** di un database.

### 3.5 Entità

Una **entità generale** dichiarata nella DTD si usa nel documento con `&nome;`:

```dtd
<!ENTITY studio "ArenaCraft Studios">
```

```xml
<motd>Benvenuto su un server &studio;!</motd>
```

Il parser sostituirà `&studio;` con `ArenaCraft Studios`. È comodo per testi ripetuti (copyright, nomi di prodotto, messaggi standard).

### 3.6 Esempio completo: la DTD del Game Server

File: [`esempi/02-dtd/game-server.dtd`](esempi/02-dtd/game-server.dtd)

```dtd
<!ENTITY studio "ArenaCraft Studios">

<!ELEMENT gameServer (motd?, network, gameMode, plugins?, players, bans?)>
<!ATTLIST gameServer
    name    CDATA          #REQUIRED
    version CDATA          #IMPLIED
    region  (EU|US|ASIA)   "EU">

<!ELEMENT motd (#PCDATA)>

<!ELEMENT network (ip, port, maxPlayers)>
<!ELEMENT ip         (#PCDATA)>
<!ELEMENT port       (#PCDATA)>
<!ELEMENT maxPlayers (#PCDATA)>

<!ELEMENT gameMode (#PCDATA)>

<!ELEMENT plugins (plugin*)>
<!ELEMENT plugin (#PCDATA)>
<!ATTLIST plugin enabled (true|false) "true">

<!ELEMENT players (player+)>
<!ELEMENT player (nickname, level)>
<!ATTLIST player
    id   ID                     #REQUIRED
    role (admin|moderator|user) "user">
<!ELEMENT nickname (#PCDATA)>
<!ELEMENT level    (#PCDATA)>

<!ELEMENT bans (ban*)>
<!ELEMENT ban (reason)>
<!ATTLIST ban
    player IDREF #REQUIRED
    by     IDREF #REQUIRED>
<!ELEMENT reason (#PCDATA)>
```

Il documento valido che la rispetta è [`server-dtd-esterna.xml`](esempi/02-dtd/server-dtd-esterna.xml).

### 3.7 Validare con la DTD

Il file [`server-dtd-non-valido.xml`](esempi/02-dtd/server-dtd-non-valido.xml) è **well-formed** ma viola la DTD in 7 punti (ogni errore è numerato nei commenti del file).

```bash
./valida.sh dtd ../esempi/02-dtd/server-dtd-esterna.xml        # ✅ valido
./valida.sh dtd ../esempi/02-dtd/server-dtd-non-valido.xml     # ❌ errori
```

Estratto dell'output reale:

```text
server-dtd-non-valido.xml:8: element gameServer: validity error : Value "AFRICA" for attribute region of gameServer is not among the enumerated set
server-dtd-non-valido.xml:20: element difficulty: validity error : No declaration for element difficulty
server-dtd-non-valido.xml:28: element player: validity error : ID P001 already defined
server-dtd-non-valido.xml:28: element player: validity error : Value "owner" for attribute role of player is not among the enumerated set
```

| Errore nel file | Regola della DTD violata |
|---|---|
| manca `name` su `gameServer` | `#REQUIRED` |
| `region="AFRICA"` | enumerazione `(EU\|US\|ASIA)` |
| `gameMode` prima di `network` | sequenza con ordine fisso |
| `<difficulty>` | elemento non dichiarato |
| due `id="P001"` | `ID` deve essere univoco |
| `role="owner"` e `<level>` mancante | enumerazione + sequenza |
| `player="P999"` | `IDREF` non risolto |

### ▶ Provalo tu

1. In `server-dtd-esterna.xml` cambia `region="EU"` in `region="MARS"` e rivalida.
2. Aggiungi `<difficulty>hard</difficulty>` dentro `<gameServer>`: cosa dice il parser?
3. Sposta `<players>` prima di `<gameMode>`.
4. Scrivi `<port>abc</port>` e rivalida. **Sorpresa:** passa! Perché? → leggi il paragrafo successivo.

### 3.8 I limiti della DTD

> [!WARNING]
> Una DTD sa dire *come è fatto* il documento, ma **non sa dire che tipo di dati contiene**. Per una DTD, `<port>abc</port>` è identico a `<port>25565</port>`: entrambi sono "testo".

| Limite | Conseguenza |
|---|---|
| Nessun **tipo di dato** (numero, data, booleano…) | non puoi imporre che `port` sia un intero |
| Nessuna **restrizione sui valori** di un elemento | `gameMode` può contenere qualsiasi stringa (l'enumerazione vale solo per gli *attributi*) |
| Nessun supporto ai **namespace** | difficile combinare vocabolari XML diversi |
| Sintassi **non XML** | servono strumenti dedicati per leggerla e modificarla |
| `ID` globale e senza tipo | non puoi dire "questo IDREF punta *solo* a un `player`" |
| Occorrenze solo `?` `*` `+` | non puoi dire "da 3 a 8 elementi" |

Per superare questi limiti è nato **XML Schema**.

---

## 4. XML Schema (XSD)

### 4.1 Perché XSD supera la DTD

**XML Schema** (raccomandazione W3C del 2001) è un linguaggio per descrivere la struttura di documenti XML, **scritto esso stesso in XML**. Il file ha estensione `.xsd`.

| Caratteristica | **DTD** | **XSD** |
|---|---|---|
| Sintassi | speciale (non XML) | **XML** |
| Tipi di dato | quasi solo testo | **oltre 40 tipi** (`xs:integer`, `xs:date`, `xs:boolean`…) |
| Restrizioni sui valori | solo enumerazioni sugli attributi | **facets**: min/max, lunghezza, **regex**, enumerazioni su elementi e attributi |
| Namespace | ❌ | ✅ |
| Occorrenze | `?` `*` `+` | `minOccurs` / `maxOccurs` con **numeri esatti** |
| Riuso e derivazione | limitati | tipi **nominati**, estensione e restrizione |
| Vincoli di integrità | `ID` / `IDREF` globali | `xs:key`, `xs:keyref`, `xs:unique` con ambito e tipo |
| Compattezza | ✅ molto compatta | ❌ più verbosa |

> [!NOTE]
> La DTD non è "sbagliata": per una struttura semplice è più veloce da scrivere. Ma appena servono **tipi, regole sui valori o namespace**, XSD è la scelta giusta.

### 4.2 Scheletro di uno schema

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xs:element name="port" type="xs:integer"/>

</xs:schema>
```

Nel documento XML si indica dove trovare lo schema con attributi del namespace `xsi`:

| Situazione | Attributo da usare nell'elemento radice |
|---|---|
| Schema **senza** namespace | `xsi:noNamespaceSchemaLocation="ordine.xsd"` |
| Schema **con** `targetNamespace` | `xsi:schemaLocation="URI-namespace file.xsd"` (coppie *namespace → file*) |

In entrambi i casi serve dichiarare `xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"`.

### 4.3 Namespace (`xmlns`)

Un **namespace** è un "cognome" per i nomi dei tuoi elementi, così da non confonderli con quelli di altri vocabolari. È lo stesso problema dei **package Java**: due classi `List` convivono perché stanno in package diversi.

```xml
<gameServer xmlns="https://tpsit.example.org/gameserver" ...>
```

| Concetto | Significato |
|---|---|
| `xmlns="URI"` | **namespace predefinito**: vale per tutti gli elementi senza prefisso |
| `xmlns:xs="URI"` | **prefisso** `xs`: gli elementi `xs:…` appartengono a quel namespace |
| `targetNamespace="URI"` | il namespace dei **nuovi elementi e tipi** definiti dallo schema |
| `elementFormDefault="qualified"` | gli elementi **locali** devono stare anch'essi nel namespace (la scelta più comune) |

L'intestazione dello schema del nostro server:

```xml
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns:gs="https://tpsit.example.org/gameserver"
           targetNamespace="https://tpsit.example.org/gameserver"
           elementFormDefault="qualified">
```

> [!IMPORTANT]
> L'URI di un namespace è solo un **identificatore univoco**: **non** deve essere raggiungibile in rete. `https://tpsit.example.org/gameserver` non punta a nessuna pagina, e va benissimo così.

> [!NOTE]
> Il namespace predefinito si applica agli **elementi**, **non agli attributi** senza prefisso. Per questo nel documento si scrive `region="EU"` e non `gs:region="EU"`.

### 4.4 Tipi semplici predefiniti

Un **tipo semplice** descrive un valore **testuale senza sotto-elementi né attributi**.

| Tipo | Contiene | Esempio valido |
|---|---|---|
| `xs:string` | testo qualsiasi | `DragonSlayer` |
| `xs:integer` | intero (anche negativo) | `-42`, `25565` |
| `xs:positiveInteger` | intero ≥ 1 | `100` |
| `xs:nonNegativeInteger` | intero ≥ 0 | `0`, `7` |
| `xs:decimal` | numero decimale (punto, non virgola) | `59.90` |
| `xs:double` | virgola mobile | `3.14e2` |
| `xs:boolean` | booleano | `true`, `false`, `1`, `0` |
| `xs:date` | data `AAAA-MM-GG` | `2026-10-17` |
| `xs:time` | ora `hh:mm:ss` | `09:52:00` |
| `xs:dateTime` | data e ora | `2026-10-17T09:52:00` |
| `xs:anyURI` | URI/URL | `https://example.org` |
| `xs:ID` / `xs:IDREF` | come in DTD | `P001` |

> [!WARNING]
> `xs:boolean` ammette `true`, `false`, `1`, `0` ma **non** `True`, `TRUE`, `yes`. E `xs:date` vuole **esattamente** il formato `AAAA-MM-GG`: `17/10/2026` viene rifiutato.

### 4.5 Elementi e attributi semplici

```xml
<xs:element   name="port"    type="xs:integer"/>
<xs:attribute name="enabled" type="xs:boolean" default="true"/>
```

**Occorrenze** degli elementi:

```xml
<xs:element name="player" type="gs:PlayerType" minOccurs="1" maxOccurs="unbounded"/>
```

| Attributo | Default | Significato |
|---|---|---|
| `minOccurs` | `1` | numero minimo di occorrenze (`0` = opzionale) |
| `maxOccurs` | `1` | numero massimo (`unbounded` = nessun limite) |

**Opzioni degli attributi:**

| `use=` | Significato |
|---|---|
| `required` | obbligatorio |
| `optional` | facoltativo (è il default) |
| `default="x"` | valore usato se l'attributo manca |
| `fixed="x"` | deve valere sempre `x` |

### 4.6 Tipi complessi

Un **tipo complesso** descrive un elemento che contiene **altri elementi** e/o ha **attributi**.

```xml
<xs:complexType name="NetworkType">
  <xs:sequence>
    <xs:element name="ip"         type="gs:IPv4Type"/>
    <xs:element name="port"       type="gs:PortType"/>
    <xs:element name="maxPlayers" type="gs:MaxPlayersType"/>
  </xs:sequence>
</xs:complexType>
```

**Indicatori di ordine**

| Indicatore | Significato | Equivalente DTD |
|---|---|---|
| `xs:sequence` | i figli compaiono **in quest'ordine** | `(a, b, c)` |
| `xs:choice` | **uno solo** tra i figli elencati | `(a \| b \| c)` |
| `xs:all` | tutti i figli, **in qualsiasi ordine** (ciascuno 0 o 1 volta) | *non esiste* |

**Elemento con testo *e* attributi** (`simpleContent`):

```xml
<xs:complexType name="PluginType">
  <xs:simpleContent>
    <xs:extension base="xs:string">
      <xs:attribute name="enabled" type="xs:boolean" default="true"/>
    </xs:extension>
  </xs:simpleContent>
</xs:complexType>
```

Valida questo: `<plugin enabled="true">AntiCheat</plugin>`.

**Attributi dentro un tipo complesso:**

```xml
<xs:complexType name="PlayerType">
  <xs:sequence>
    <xs:element name="nickname" type="gs:NicknameType"/>
    <xs:element name="level"    type="gs:LevelType"/>
    <xs:element name="joined"   type="xs:date" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="id"   type="gs:PlayerIdType" use="required"/>
  <xs:attribute name="role" type="gs:RoleType"     default="user"/>
</xs:complexType>
```

> [!TIP]
> **Nominati vs anonimi.** Un tipo con `name="..."` si può **riusare** in più punti; un tipo dichiarato dentro un elemento senza nome (*anonimo*) vale solo lì. Per schemi leggibili e riutilizzabili preferisci i tipi nominati.

### 4.7 Restrizioni (facets)

Si crea un **nuovo tipo semplice** *restringendo* un tipo esistente con `xs:restriction` e uno o più **facets**.

| Facet | Cosa limita | Esempio |
|---|---|---|
| `minInclusive` / `maxInclusive` | valore minimo / massimo **compreso** | `value="1024"` |
| `minExclusive` / `maxExclusive` | valore minimo / massimo **escluso** | `minExclusive value="0"` |
| `length` / `minLength` / `maxLength` | lunghezza del testo | `maxLength value="16"` |
| `pattern` | **espressione regolare** | `value="P[0-9]{3}"` |
| `enumeration` | elenco di valori ammessi | `value="survival"` |
| `totalDigits` / `fractionDigits` | cifre totali / decimali | `fractionDigits value="2"` |
| `whiteSpace` | gestione degli spazi | `value="collapse"` |

**Esempio 1 — intervallo numerico** (la porta di un server):

```xml
<xs:simpleType name="PortType">
  <xs:restriction base="xs:integer">
    <xs:minInclusive value="1024"/>
    <xs:maxInclusive value="65535"/>
  </xs:restriction>
</xs:simpleType>
```

**Esempio 2 — enumerazione** (finalmente anche su un *elemento*, cosa impossibile con la DTD):

```xml
<xs:simpleType name="GameModeType">
  <xs:restriction base="xs:string">
    <xs:enumeration value="survival"/>
    <xs:enumeration value="creative"/>
    <xs:enumeration value="adventure"/>
    <xs:enumeration value="spectator"/>
  </xs:restriction>
</xs:simpleType>
```

**Esempio 3 — espressione regolare** (indirizzo IPv4):

```xml
<xs:simpleType name="IPv4Type">
  <xs:restriction base="xs:string">
    <xs:pattern value="((25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})"/>
  </xs:restriction>
</xs:simpleType>
```

**Mini-prontuario delle regex XSD**

| Simbolo | Significato | Esempio |
|---|---|---|
| `[A-Z]` `[0-9]` `[a-z_]` | un carattere dell'insieme | `[A-Za-z0-9_]` |
| `\d` `\s` `\w` | cifra / spazio / carattere di parola | `\d{4}` |
| `{n}` `{n,m}` | esattamente *n* / da *n* a *m* volte | `[0-9]{3}` |
| `+` `*` `?` | 1 o più / 0 o più / 0 o 1 | `[a-z]+` |
| `\|` | alternativa | `EUR\|USD` |
| `( )` | raggruppamento | `(\.[0-9]+)?` |
| `\.` | un punto vero (il `.` da solo vale "qualsiasi") | `192\.168` |

> [!IMPORTANT]
> In XSD il `pattern` deve corrispondere **all'intero valore**: l'ancoraggio è implicito. **Non** si scrivono `^` e `$` (qui non sono caratteri speciali e non servono).

### 4.8 Validazione avanzata: `key`, `keyref`, `unique`

`xs:ID` / `xs:IDREF` esistono anche in XSD, ma i vincoli di integrità sono molto più precisi:

| Costrutto | Significato | Analogo SQL |
|---|---|---|
| `xs:unique` | i valori selezionati **non si ripetono** | `UNIQUE` |
| `xs:key` | come `unique`, ma **obbligatori** (non possono mancare) | `PRIMARY KEY` |
| `xs:keyref` | i valori devono **esistere** in una `key` o `unique` | `FOREIGN KEY` |

Ciascuno usa un `xs:selector` (quali elementi) e uno o più `xs:field` (quale valore), con espressioni XPath (qui con il prefisso del namespace `gs:`):

```xml
<xs:key name="playerKey">
  <xs:selector xpath="gs:players/gs:player"/>
  <xs:field    xpath="@id"/>
</xs:key>

<xs:unique name="nicknameUnique">
  <xs:selector xpath="gs:players/gs:player"/>
  <xs:field    xpath="gs:nickname"/>
</xs:unique>

<xs:keyref name="banPlayerRef" refer="gs:playerKey">
  <xs:selector xpath="gs:bans/gs:ban"/>
  <xs:field    xpath="@player"/>
</xs:keyref>
```

In più, grazie ai tipi, l'`id` deve anche rispettare il pattern `P[0-9]{3}`: la DTD non lo avrebbe mai potuto controllare.

> [!NOTE]
> `xmllint` e il validatore integrato di Java implementano **XSD 1.0**. Le asserzioni (`xs:assert`) fanno parte di **XSD 1.1** e non sono supportate da questi strumenti.

### 4.9 Lo schema completo e la sua validazione

- Schema: [`esempi/03-xsd/game-server.xsd`](esempi/03-xsd/game-server.xsd) (commentato riga per riga)
- Documento valido: [`server-xsd-valido.xml`](esempi/03-xsd/server-xsd-valido.xml)
- Documento non valido: [`server-xsd-non-valido.xml`](esempi/03-xsd/server-xsd-non-valido.xml) — 11 errori, tutti di **tipo o di vincolo**, che una DTD **non avrebbe individuato**

```bash
./valida.sh xsd ../esempi/03-xsd/game-server.xsd ../esempi/03-xsd/server-xsd-valido.xml      # ✅
./valida.sh xsd ../esempi/03-xsd/game-server.xsd ../esempi/03-xsd/server-xsd-non-valido.xml  # ❌
```

| Errore nel file | Faccetta / vincolo violato |
|---|---|
| `version="2.4"` | `pattern` `[0-9]+\.[0-9]+\.[0-9]+` |
| `ip` = `300.168.1.10` | `pattern` IPv4 |
| `port` = `80` | `minInclusive` 1024 |
| `maxPlayers` = `1000` | `maxInclusive` 500 |
| `gameMode` = `hardcore` | `enumeration` |
| nickname `Dragon Slayer!` | `pattern` `[A-Za-z0-9_]+` |
| `level` = `150` | `maxInclusive` 100 |
| `joined` = `17/10/2026` | tipo `xs:date` |
| due nickname `Dragon_Slayer` | `xs:unique` |
| `<ban>` senza `<reason>` | struttura (`xs:sequence`) |
| `player="P999"` | `xs:keyref` |

### ▶ Provalo tu

1. In `server-xsd-valido.xml` cambia `<port>25565</port>` in `<port>80</port>`: la DTD lo avrebbe accettato, lo schema no.
2. Scrivi `<level>ottantasette</level>`.
3. Cambia `enabled="true"` in `enabled="yes"`.
4. **Estendi lo schema:** aggiungi un elemento facoltativo `<difficulty>` a `gameServer` con i valori `easy`, `normal`, `hard`, poi usalo nel documento.

---

## 5. Come si valida un documento

| Strumento | Comando | Note |
|---|---|---|
| **xmllint** | `./valida.sh wf\|dtd\|xsd …` | installa con `sudo apt install libxml2-utils` (Linux); già presente su macOS |
| **Python (lxml)** | `python valida.py wf\|dtd\|xsd …` | `pip install lxml`; funziona anche su Windows |
| **Java** | `javac ValidaXsd.java` poi `java ValidaXsd schema.xsd file.xml` | usa solo la libreria standard (`javax.xml.validation`) |
| **VS Code** | estensione *XML* di Red Hat | segnala gli errori **mentre scrivi** |

Per eseguire **tutti** gli esempi in un colpo solo e controllare che quelli "buoni" passino e quelli "sbagliati" falliscano:

```bash
cd modulo-1-xml/validatori
./test-esempi.sh
```

Risultato atteso: `Risultato: 14 test superati, 0 falliti`.

> [!TIP]
> In Java il cuore della validazione sono tre righe:
> ```java
> SchemaFactory f = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
> Schema schema   = f.newSchema(new File("game-server.xsd"));
> schema.newValidator().validate(new StreamSource(new File("server.xml")));
> ```
> Se il documento non è valido, `validate()` lancia una `SAXException`. Il file [`ValidaXsd.java`](validatori/ValidaXsd.java) mostra la versione completa con la raccolta di *tutti* gli errori.

---

## 6. Riepilogo e quiz

### Cheat sheet

| Concetto | Sintassi |
|---|---|
| Prologo | `<?xml version="1.0" encoding="UTF-8"?>` |
| Elemento vuoto | `<world type="flat"/>` |
| CDATA | `<![CDATA[ testo libero ]]>` |
| DTD interna | `<!DOCTYPE radice [ … ]>` |
| DTD esterna | `<!DOCTYPE radice SYSTEM "file.dtd">` |
| Elemento in DTD | `<!ELEMENT a (b, c?, d*)>` |
| Attributo in DTD | `<!ATTLIST a id ID #REQUIRED>` |
| Elemento in XSD | `<xs:element name="a" type="xs:string"/>` |
| Restrizione in XSD | `<xs:restriction base="xs:integer"> … </xs:restriction>` |
| Occorrenze in XSD | `minOccurs="0" maxOccurs="unbounded"` |

### Quiz di autovalutazione

**1.** Un documento può essere *valido* senza essere *well-formed*?

<details>
<summary>Mostra risposta</summary>

**No.** La validità presuppone la buona formazione: un parser deve prima riuscire a leggere il documento. Il contrario invece è possibile (un file well-formed può non rispettare la DTD).

</details>

**2.** Perché `<player id="1">` non è valido se `id` è dichiarato di tipo `ID` in una DTD?

<details>
<summary>Mostra risposta</summary>

Perché un valore di tipo `ID` deve essere un **nome XML valido**, e un nome **non può iniziare con una cifra**. Va bene `id="P1"`.

</details>

**3.** Con quale dichiarazione imponi in una DTD che `<ip>` contenga solo valori IPv4 validi?

<details>
<summary>Mostra risposta</summary>

**Non puoi.** La DTD conosce solo `#PCDATA` (testo generico). Per imporre un formato serve XSD con un `xs:pattern`.

</details>

**4.** Che differenza c'è tra `xs:sequence` e `xs:all`?

<details>
<summary>Mostra risposta</summary>

In `xs:sequence` i figli devono comparire **nell'ordine dichiarato**; in `xs:all` possono comparire **in qualsiasi ordine** (e ciascuno al massimo una volta).

</details>

**5.** Cosa succede se lo schema ha `targetNamespace="https://x.org/a"` ma il documento non dichiara quel namespace?

<details>
<summary>Mostra risposta</summary>

Il documento **non è valido**: l'elemento radice `gameServer` (senza namespace) non corrisponde all'elemento `{https://x.org/a}gameServer` definito dallo schema. Serve `xmlns="https://x.org/a"` nell'elemento radice del documento.

</details>

---

## 🚀 Passo successivo

➡️ **[Vai al laboratorio autonomo](laboratorio/README.md)**: correggi un file rotto, scrivi una **DTD per un server Minecraft** e uno **schema XSD per un ordine e-commerce**.

➡️ Poi prosegui con il **[Modulo 2 — JSON](../modulo-2-json/README.md)** per confrontare i due formati.
