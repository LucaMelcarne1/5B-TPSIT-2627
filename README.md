# 📘 Modulo 1 — XML, DTD e XML Schema

In questo modulo impari a **scrivere** un file XML, a dire **come deve essere fatto** (DTD e XSD) e a **controllare** che sia corretto.

Come esempio usiamo il **file di configurazione di un Game Server**.

## 🛠️ Prima di iniziare: prepara VS Code

1. Apri VS Code e vai su **Estensioni** (`Ctrl+Shift+X`).
2. Cerca **XML** (autore: *Red Hat*, id `redhat.vscode-xml`) e clicca **Installa**.
3. Apri la cartella della repository: **File → Apri cartella**.

Da ora VS Code controlla i file `.xml` **mentre scrivi**:

- una **sottolineatura rossa** segna l'errore (passa il mouse sopra per leggere il messaggio)
- l'elenco di tutti gli errori è nel pannello **Problemi** (`Ctrl+Shift+M`)

> [!NOTE]
> Le versioni recenti dell'estensione non richiedono Java. Se VS Code te lo chiedesse, aggiorna l'estensione.

> [!TIP]
> **Impara provando!** In ogni sezione c'è un riquadro **▶ Provalo tu**: modifica il file, rompilo apposta e leggi l'errore.

---

## 1️⃣ XML: la sintassi

**XML** (*eXtensible Markup Language*) serve a **descrivere dati** con dei tag. I tag **non sono predefiniti** come in HTML: li scegli tu.

📄 File: [`01-sintassi/server.xml`](01-sintassi/server.xml)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- Configurazione del Game Server -->
<server nome="ArenaCraft" regione="EU">
  <porta>25565</porta>
  <modalita>survival</modalita>
  <giocatori>
    <giocatore id="g1" ruolo="admin">
      <nickname>DragonSlayer</nickname>
      <livello>87</livello>
    </giocatore>
  </giocatori>
</server>
```

Le parti di un documento XML:

| Parte | Esempio | Cos'è |
|---|---|---|
| **Prologo** | `<?xml version="1.0" encoding="UTF-8"?>` | prima riga: versione e codifica |
| **Elemento** | `<porta>25565</porta>` | tag di apertura + contenuto + tag di chiusura |
| **Radice** | `<server> ... </server>` | l'elemento che contiene tutti gli altri (**uno solo**) |
| **Attributo** | `nome="ArenaCraft"` | informazione dentro il tag di apertura |
| **Commento** | `<!-- nota -->` | ignorato dal programma |

Un documento XML è un **albero**: la radice contiene i figli, che possono contenere altri figli.

```text
server
├── porta        → 25565
├── modalita     → survival
└── giocatori
    └── giocatore (id="g1")
        ├── nickname → DragonSlayer
        └── livello  → 87
```

### Le regole (documento *well-formed*)

1. C'è **una sola radice**.
2. Ogni tag aperto va **chiuso**.
3. I tag si chiudono **nell'ordine inverso** in cui si aprono.
4. XML distingue **maiuscole e minuscole**: `<Livello>` ≠ `<livello>`.
5. I valori degli attributi vanno **tra virgolette**.
6. I caratteri `<` e `&` nel testo vanno scritti come **entità**.

### Entità

| Scrivi | Ottieni |
|---|---|
| `&lt;` | `<` |
| `&gt;` | `>` |
| `&amp;` | `&` |
| `&quot;` | `"` |
| `&apos;` | `'` |

```xml
<nickname>Tom &amp; Jerry</nickname>
<messaggio>livello &lt; 10</messaggio>
```

Se hai tanto testo con simboli speciali, usa **CDATA**: dentro non serve scrivere le entità.

```xml
<script><![CDATA[ if (livello < 10 && ping > 200) { kick(); } ]]></script>
```

### Elemento o attributo?

```xml
<giocatore id="g1" ruolo="admin">   <!-- id e ruolo: informazioni "su" giocatore -->
  <nickname>DragonSlayer</nickname> <!-- nickname: il dato vero e proprio -->
</giocatore>
```

> [!TIP]
> Gli **attributi** descrivono (id, tipo, stato). Gli **elementi** contengono i dati. Se un dato può **ripetersi** o avere altri dati dentro, usa un elemento.

### ⚠️ Gli errori più comuni

| ❌ Sbagliato | ✅ Giusto | Regola |
|---|---|---|
| `<livello>87</Livello>` | `<livello>87</livello>` | maiuscole/minuscole |
| `<nickname>Dragon` | `<nickname>Dragon</nickname>` | chiudere i tag |
| `<a><b></a></b>` | `<a><b></b></a>` | ordine di chiusura |
| `<server nome=ArenaCraft>` | `<server nome="ArenaCraft">` | virgolette |
| `Tom & Jerry` | `Tom &amp; Jerry` | entità |
| due elementi radice | un solo elemento radice | una sola radice |

### ▶ Provalo tu

1. Apri [`server.xml`](01-sintassi/server.xml): non ha errori.
2. Cancella `</porta>` → compare una sottolineatura rossa. Leggi il messaggio.
3. Rimettilo, poi scrivi `nome=ArenaCraft` senza virgolette.
4. Scrivi `Tom & Jerry` dentro `<nickname>`.

### Well-formed e valido

- **Well-formed** (*ben formato*): rispetta le regole di sintassi. Lo controlla **ogni** programma che legge XML.
- **Valido**: è ben formato **e** rispetta anche le regole di una **DTD** o di uno **Schema**.

---

## 2️⃣ DTD (Document Type Definition)

Una **DTD** è un elenco di regole che dice **quali elementi e attributi esistono, in che ordine e quante volte**. Se il file le rispetta, è **valido**.

### DTD interna ed esterna

**Interna**: le regole stanno nel documento, dentro `[ ... ]`.

📄 File: [`02-dtd/log-interna.xml`](02-dtd/log-interna.xml)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE log [
  <!ELEMENT log (evento+)>
  <!ELEMENT evento (ora, messaggio)>
  <!ATTLIST evento livello (INFO|WARN|ERROR) #REQUIRED>
  <!ELEMENT ora (#PCDATA)>
  <!ELEMENT messaggio (#PCDATA)>
]>
<log>
  <evento livello="ERROR">
    <ora>09:54:40</ora>
    <messaggio>Connessione al database scaduta</messaggio>
  </evento>
</log>
```

**Esterna**: le regole stanno in un file `.dtd` separato, richiamato con `SYSTEM`.

```xml
<!DOCTYPE server SYSTEM "game-server.dtd">
```

| | Interna | Esterna |
|---|---|---|
| Dove sono le regole | nel documento | in un file `.dtd` |
| Si può riusare in più file | no | **sì** |

> [!IMPORTANT]
> Il nome dopo `DOCTYPE` deve essere uguale al nome dell'**elemento radice** (`log`, `server`...).

### Dichiarare un elemento: `<!ELEMENT>`

| Scrivi | Significato |
|---|---|
| `(#PCDATA)` | solo **testo** |
| `EMPTY` | elemento **vuoto** (ha solo attributi) |
| `(a, b, c)` | a, poi b, poi c: **in quest'ordine** |
| `(a \| b)` | a **oppure** b |

E dopo il nome si può aggiungere un simbolo:

| Simbolo | Significato | Volte |
|---|---|---|
| *(nessuno)* | uno solo | 1 |
| `?` | facoltativo | 0 o 1 |
| `*` | zero o più | 0, 1, 2… |
| `+` | uno o più | 1, 2, 3… |

```dtd
<!ELEMENT giocatori (giocatore+)>   <!-- almeno un giocatore -->
<!ELEMENT bannati (bannato*)>       <!-- zero o più bannati -->
```

### Dichiarare gli attributi: `<!ATTLIST>`

```dtd
<!ATTLIST giocatore
    id    ID                          #REQUIRED
    ruolo (admin|moderatore|utente)   "utente">
```

| Tipo | Significato |
|---|---|
| `CDATA` | testo qualsiasi |
| `(a\|b\|c)` | **un valore tra quelli elencati** |
| `ID` | identificatore **unico** nel documento |
| `IDREF` | **riferimento** a un `ID` esistente |

| Valore predefinito | Significato |
|---|---|
| `#REQUIRED` | **obbligatorio** |
| `#IMPLIED` | **facoltativo** |
| `"utente"` | facoltativo; se manca vale `utente` |

> [!NOTE]
> `ID` è come la **chiave primaria** di un database, `IDREF` come la **chiave esterna**. Un `ID` **non può iniziare con un numero**: `g1` va bene, `1` no.

### La DTD del Game Server

📄 File: [`02-dtd/game-server.dtd`](02-dtd/game-server.dtd)

```dtd
<!ELEMENT server (porta, modalita, giocatori, bannati?)>
<!ATTLIST server
    nome    CDATA          #REQUIRED
    regione (EU|US|ASIA)   "EU">

<!ELEMENT porta    (#PCDATA)>
<!ELEMENT modalita (#PCDATA)>

<!ELEMENT giocatori (giocatore+)>
<!ELEMENT giocatore (nickname, livello)>
<!ATTLIST giocatore
    id    ID                          #REQUIRED
    ruolo (admin|moderatore|utente)   "utente">
<!ELEMENT nickname (#PCDATA)>
<!ELEMENT livello  (#PCDATA)>

<!ELEMENT bannati (bannato*)>
<!ELEMENT bannato EMPTY>
<!ATTLIST bannato
    giocatore IDREF #REQUIRED
    motivo    CDATA #REQUIRED>
```

Come si legge: *un `server` contiene porta, modalita, giocatori e (facoltativi) bannati, in questo ordine. Ha un `nome` obbligatorio e una `regione` che può essere EU, US o ASIA.*

### ▶ Provalo tu

1. Apri [`server-esterna.xml`](02-dtd/server-esterna.xml): è valido, nessun errore.
2. Cambia `regione="EU"` in `regione="MARS"`. Cosa dice VS Code?
3. Sposta `<modalita>` prima di `<porta>`.
4. Cambia `giocatore="g3"` in `giocatore="g9"` (un `IDREF` che non esiste).
5. Apri [`server-non-valido.xml`](02-dtd/server-non-valido.xml): contiene **6 errori**. Trovali tutti con il pannello **Problemi**.

| # | Errore nel file | Regola violata |
|---|---|---|
| 1 | manca `nome` | `#REQUIRED` |
| 2 | `regione="AFRICA"` | solo EU, US, ASIA |
| 3 | `modalita` prima di `porta` | l'ordine conta |
| 4 | `ruolo="boss"` | solo admin, moderatore, utente |
| 5 | manca `livello` | `giocatore` vuole nickname **e** livello |
| 6 | `giocatore="g9"` | nessun `ID` chiamato g9 |

### ⚠️ I limiti della DTD

La DTD sa **come è fatto** il documento, ma **non sa che tipo di dati** contiene. Per lei `<porta>abc</porta>` e `<porta>25565</porta>` sono uguali: sono entrambi "testo".

- non può dire che `porta` è un **numero**
- non può limitare i valori di un **elemento** (solo quelli di un attributo)
- non gestisce i **namespace**

Per questo è nato **XML Schema**.

---

## 3️⃣ XML Schema (XSD)

**XML Schema** fa lo stesso lavoro della DTD, ma meglio. È scritto **in XML** e il file ha estensione `.xsd`.

| | DTD | XSD |
|---|---|---|
| Sintassi | speciale | **XML** |
| Tipi di dato (numero, data...) | no | **sì** |
| Limiti sui valori (min, max, formato) | no | **sì** |
| Namespace | no | **sì** |

### Scheletro di uno schema

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xs:element name="porta" type="xs:integer"/>

</xs:schema>
```

Tutti i tag dello schema iniziano con `xs:`.

### Collegare lo schema al documento XML

Nell'elemento radice del file XML si scrive dove si trova lo schema:

```xml
<server xmlns="https://scuola.example.org/gameserver"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="https://scuola.example.org/gameserver game-server.xsd"
        nome="ArenaCraft" regione="EU">
```

> [!NOTE]
> Se lo schema **non** usa namespace, si scrive invece `xsi:noNamespaceSchemaLocation="ordine.xsd"` (lo userai nel laboratorio).

### Namespace (`xmlns`)

Un **namespace** è un "cognome" dato ai tuoi elementi, per non confonderli con quelli di altri vocabolari XML (come i *package* in Java).

| Scritto | Significato |
|---|---|
| `xmlns="https://..."` | namespace dei tag senza prefisso |
| `xmlns:xs="http://www.w3.org/2001/XMLSchema"` | i tag `xs:...` sono quelli di XML Schema |
| `targetNamespace="https://..."` | il namespace degli elementi definiti dallo schema |

> [!IMPORTANT]
> L'indirizzo del namespace è solo un **nome univoco**: non deve essere una pagina web esistente.

### Tipi semplici più usati

| Tipo | Contiene | Esempio |
|---|---|---|
| `xs:string` | testo | `DragonSlayer` |
| `xs:integer` | numero intero | `25565` |
| `xs:decimal` | numero con la virgola (si scrive il **punto**) | `59.90` |
| `xs:boolean` | vero/falso | `true`, `false` |
| `xs:date` | data `AAAA-MM-GG` | `2026-10-17` |

### Restrizioni: limitare i valori

Si crea un **nuovo tipo** partendo da uno esistente e aggiungendo dei limiti.

**Un intervallo** (la porta):

```xml
<xs:simpleType name="PortaType">
  <xs:restriction base="xs:integer">
    <xs:minInclusive value="1024"/>
    <xs:maxInclusive value="65535"/>
  </xs:restriction>
</xs:simpleType>
```

**Un elenco di valori** (la modalità di gioco):

```xml
<xs:simpleType name="ModalitaType">
  <xs:restriction base="xs:string">
    <xs:enumeration value="survival"/>
    <xs:enumeration value="creative"/>
    <xs:enumeration value="adventure"/>
  </xs:restriction>
</xs:simpleType>
```

**Un formato** con un'espressione regolare (il nickname):

```xml
<xs:simpleType name="NicknameType">
  <xs:restriction base="xs:string">
    <xs:pattern value="[A-Za-z0-9_]+"/>
    <xs:minLength value="3"/>
    <xs:maxLength value="16"/>
  </xs:restriction>
</xs:simpleType>
```

| Regola | Significato |
|---|---|
| `minInclusive` / `maxInclusive` | minimo / massimo **compreso** |
| `minExclusive` / `maxExclusive` | minimo / massimo **escluso** |
| `minLength` / `maxLength` | lunghezza minima / massima |
| `enumeration` | uno dei valori elencati |
| `pattern` | deve rispettare l'**espressione regolare** |

Un po' di espressioni regolari:

| Scrivi | Significato | Esempio |
|---|---|---|
| `[A-Z]` `[0-9]` | un carattere di quell'insieme | `[0-9]` |
| `{4}` | ripetuto 4 volte | `[0-9]{4}` |
| `+` | una o più volte | `[a-z]+` |
| `\.` | un punto vero | `192\.168` |

> [!NOTE]
> In XSD il `pattern` deve corrispondere a **tutto** il valore: non servono `^` e `$`.

### Tipi complessi: elementi con figli e attributi

```xml
<xs:complexType name="GiocatoreType">
  <xs:sequence>
    <xs:element name="nickname" type="NicknameType"/>
    <xs:element name="livello"  type="LivelloType"/>
  </xs:sequence>
  <xs:attribute name="id"    type="xs:ID"     use="required"/>
  <xs:attribute name="ruolo" type="RuoloType" default="utente"/>
</xs:complexType>
```

- `xs:sequence` = i figli compaiono **in quest'ordine**
- `use="required"` = attributo **obbligatorio**
- `default="utente"` = valore usato se l'attributo manca
- `minOccurs="0"` = elemento **facoltativo**; `maxOccurs="unbounded"` = **quante volte vuoi**

```xml
<xs:element name="giocatore" type="GiocatoreType" maxOccurs="unbounded"/>
```

### Lo schema completo

📄 File: [`03-xsd/game-server.xsd`](03-xsd/game-server.xsd) (pieno di commenti: leggilo!)

### ▶ Provalo tu

1. Apri [`03-xsd/server-valido.xml`](03-xsd/server-valido.xml): nessun errore.
2. Cambia `<porta>25565</porta>` in `<porta>80</porta>` → errore! (la DTD non l'avrebbe notato).
3. Scrivi `<livello>ottantasette</livello>`.
4. Cambia `<modalita>survival</modalita>` in `hardcore`.
5. Apri [`server-non-valido.xml`](03-xsd/server-non-valido.xml): contiene **6 errori**. Trovali tutti.

| # | Errore nel file | Regola violata |
|---|---|---|
| 1 | `regione="AFRICA"` | `enumeration` |
| 2 | `porta` = `80` | `minInclusive` 1024 |
| 3 | `modalita` = `hardcore` | `enumeration` |
| 4 | nickname `Dragon Slayer!` | `pattern` (niente spazi né `!`) |
| 5 | `livello` = `150` | `maxInclusive` 100 |
| 6 | `bannato` senza `motivo` | attributo `required` |

> [!TIP]
> Per approfondire, in XSD esistono anche `xs:unique`, `xs:key` e `xs:keyref`: controllano che i valori non si ripetano e che i riferimenti siano corretti, come le chiavi di un database.

---

## 📝 Riepilogo

| Voglio... | Uso |
|---|---|
| scrivere dati con tag | **XML** (ben formato) |
| dire quali elementi e attributi esistono, in che ordine | **DTD** |
| dire anche di che tipo sono i dati e quali valori sono ammessi | **XSD** |

**Controlla di aver capito. Sai spiegare:**

- [ ] la differenza tra *well-formed* e *valido*?
- [ ] cosa significano `?`, `*` e `+` in una DTD?
- [ ] a cosa servono `ID` e `IDREF`?
- [ ] perché con la DTD `<porta>abc</porta>` passa e con lo XSD no?
- [ ] cosa fa `xs:restriction`?

## 🚀 Ora tocca a te

➡️ **[Vai al laboratorio](laboratorio/README.md)**: ripara un file rotto, scrivi una **DTD per un server Minecraft** e uno **schema XSD per un ordine online**.
