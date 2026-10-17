# 📦 TPSIT — Formati di Dati: XML e JSON

**Tutorial pratico e progressivo sullo scambio di dati strutturati**, per la materia **TPSIT** (*Tecnologie e Progettazione di Sistemi Informatici e di Telecomunicazioni*) — **5ª classe** degli Istituti Tecnici, indirizzo **Informatica**.

Stile *"alla W3Schools"*: spiegazioni essenziali, esempi mirati, **Learn by Doing**. Ma con scenari che parlano ai ragazzi: **server di gioco**, **log di sistema**, **API social ed e-commerce**, **architetture client-server**.

| Modulo | Argomento | Stato |
|---|---|:---:|
| 📘 [**Modulo 1**](modulo-1-xml/README.md) | XML — sintassi, DTD, XML Schema (XSD) | ✅ Disponibile |
| 📗 [**Modulo 2**](modulo-2-json/README.md) | JSON — sintassi, JSON vs XML, parsing, JSON Schema | 🚧 In preparazione |

---

## 🎓 Perché i formati di dati nel corso di TPSIT

Nei sistemi distribuiti i programmi non vivono da soli: un'app mobile dialoga con un server, un microservizio con un altro, un game server legge la propria configurazione e scrive i log. Tutto questo funziona solo se le due parti **concordano sul formato dei dati** scambiati.

```text
┌──────────┐   richiesta (XML / JSON)   ┌──────────┐   query    ┌──────────┐
│  Client  │ ─────────────────────────▶ │  Server  │ ─────────▶ │ Database │
│ (app/web)│ ◀───────────────────────── │   API    │ ◀───────── │          │
└──────────┘   risposta (XML / JSON)    └──────────┘            └──────────┘
```

Un buon formato di dati deve essere:

| Qualità | Domanda |
|---|---|
| **Leggibile** | Una persona riesce a capire cosa c'è scritto? |
| **Portabile** | Funziona con qualsiasi linguaggio e sistema operativo? |
| **Validabile** | Posso verificare *automaticamente* che i dati siano corretti prima di usarli? |
| **Efficiente** | Quanto spazio occupa e quanto costa leggerlo? |

In questo corso studierai i **due formati dominanti** e imparerai a sceglierli con criterio.

## 🧭 Competenze sviluppate

Al termine del corso saprai:

- scrivere e leggere documenti **XML** e **JSON** corretti
- definire e applicare **regole di validazione** (DTD, XSD, JSON Schema)
- **leggere e scrivere** dati strutturati da codice (Python, JavaScript, Java)
- **confrontare** XML e JSON e motivare la scelta in un progetto
- diagnosticare un errore a partire dal **messaggio del validatore**

## 🔑 Prerequisiti

| Serve | Livello richiesto |
|---|---|
| Programmazione | Variabili, cicli, funzioni, oggetti/classi in almeno un linguaggio (Java, JavaScript o Python) |
| HTML | Conoscere tag, attributi, annidamento |
| Terminale | Saper aprire una shell, spostarsi tra le cartelle, lanciare un comando |
| Reti | Idea di base di modello **client-server** e di richiesta/risposta HTTP |
| Git (facoltativo) | `git clone` per scaricare la repository |

## 🛠️ Strumenti

| Strumento | A cosa serve | Installazione |
|---|---|---|
| **VS Code** | editor consigliato; l'estensione *XML* (Red Hat) valida mentre scrivi | [code.visualstudio.com](https://code.visualstudio.com) |
| **xmllint** | validazione XML da terminale | Linux: `sudo apt install libxml2-utils` · macOS: già presente |
| **Python 3 + lxml** | validatore alternativo (anche Windows) | `pip install lxml` |
| **JDK** | esempi Java (`ValidaXsd.java`) | qualsiasi JDK recente |
| **Node.js** | esempi JavaScript (Modulo 2) | [nodejs.org](https://nodejs.org) |

> [!TIP]
> Non hai installato nulla? Per il Modulo 1 ti basta **un editor e Python** (`pip install lxml`): lo script [`valida.py`](modulo-1-xml/validatori/valida.py) fa tutto.

## 🚀 Come iniziare

```bash
git clone https://github.com/<tuo-utente>/tpsit-formati-dati.git
cd tpsit-formati-dati/modulo-1-xml/validatori

# Controlla che il tuo ambiente funzioni: tutti i test devono passare
./test-esempi.sh
```

Poi apri il [**Modulo 1**](modulo-1-xml/README.md) e segui l'ordine: **teoria → esempi → ▶ Provalo tu → laboratorio**.

## 🗂️ Struttura della repository

```text
tpsit-formati-dati/
├── README.md                          ← sei qui
│
├── modulo-1-xml/                      ✅ XML, DTD, XSD
│   ├── README.md                      ← teoria completa (stile W3Schools)
│   ├── esempi/
│   │   ├── 01-sintassi/
│   │   │   ├── server-config.xml      ← XML well-formed (Game Server)
│   │   │   └── errori/                ← 8 file volutamente sbagliati
│   │   ├── 02-dtd/
│   │   │   ├── game-server.dtd
│   │   │   ├── server-dtd-esterna.xml
│   │   │   ├── server-dtd-interna.xml ← log di sistema
│   │   │   └── server-dtd-non-valido.xml
│   │   └── 03-xsd/
│   │       ├── game-server.xsd
│   │       ├── server-xsd-valido.xml
│   │       └── server-xsd-non-valido.xml
│   ├── validatori/
│   │   ├── valida.sh                  ← xmllint
│   │   ├── valida.py                  ← lxml (multipiattaforma)
│   │   ├── ValidaXsd.java             ← javax.xml.validation
│   │   └── test-esempi.sh             ← esegue tutti gli esempi
│   └── laboratorio/
│       ├── README.md                  ← 3 sfide + soluzioni nascoste
│       └── *.xml                      ← file di partenza degli esercizi
│
└── modulo-2-json/                     🚧 JSON (in preparazione)
    ├── README.md
    ├── esempi/                        ← sintassi, parsing JS/Java, JSON Schema
    ├── validatori/
    └── laboratorio/
```

## 🧩 Gli scenari del corso

| Scenario | Dove lo trovi | Cosa imparerai |
|---|---|---|
| 🎮 **Game Server** (configurazione, giocatori, ban) | `server-config.xml`, `game-server.dtd`, `game-server.xsd` | sintassi, DTD, ID/IDREF, XSD, `key`/`keyref` |
| 📜 **Log di sistema** | `server-dtd-interna.xml` | DTD interna, enumerazioni |
| 🧱 **Server Minecraft** | laboratorio, esercizio 2 | scrivere una DTD da zero |
| 🛒 **Ordine e-commerce** | laboratorio, esercizi 1 e 3 | errori di sintassi, XSD con restrizioni |
| 📱 **API social** *(Modulo 2)* | in preparazione | JSON, parsing, JSON Schema |
| 🔌 **Scambio Client-Server** *(Modulo 2)* | in preparazione | serializzazione, XML vs JSON |

## 🧱 Come sono fatte le lezioni

Ogni modulo ha la stessa struttura:

1. **Teoria** — brevi paragrafi, tabelle, esempi di codice commentati
2. **File di esempio** — pronti da eseguire, con la versione *corretta* e quella *sbagliata*
3. **▶ Provalo tu** — piccoli esperimenti guidati: modifica un file e osserva l'errore
4. **Quiz** — autovalutazione con risposte nascoste
5. **Laboratorio** — sfide autonome con **soluzione nascosta**

Nei documenti troverai questi riquadri:

> [!NOTE]
> Informazione utile da ricordare.

> [!TIP]
> Un trucco o una buona pratica.

> [!IMPORTANT]
> Un concetto su cui si inciampa spesso.

> [!WARNING]
> Un errore tipico che farà fallire la validazione.

<details>
<summary>Mostra Soluzione</summary>

Le soluzioni degli esercizi sono nascoste così: **prima prova, poi controlla!**

</details>

## ⚖️ XML e JSON a colpo d'occhio

*(Il confronto dettagliato, con casi d'uso, è nel Modulo 2.)*

| | **XML** | **JSON** |
|---|---|---|
| Nato per | documenti e dati strutturati | scambio dati leggero tra programmi |
| Aspetto | tag di apertura/chiusura | coppie `chiave: valore` |
| Tipi di dato nativi | solo testo (i tipi li dà lo **schema**) | stringa, numero, booleano, `null`, array, oggetto |
| Validazione | DTD, **XSD** | **JSON Schema** |
| Namespace e attributi | ✅ | ❌ |
| Peso | più verboso | più compatto |
| Uso tipico | configurazioni, SOAP, SVG, documenti Office | API REST, app web e mobile |

```xml
<player id="P001"><nickname>DragonSlayer</nickname><level>87</level></player>
```

```json
{ "id": "P001", "nickname": "DragonSlayer", "level": 87 }
```

## 👩‍🏫 Per i docenti

**Proposta di scansione** (adattabile al proprio monte ore):

| Fase | Contenuto | Ore indicative |
|---|---|:---:|
| 1 | XML: sintassi + esercizio 1 | 2 |
| 2 | DTD + esercizio 2 | 3 |
| 3 | XSD + esercizio 3 | 4 |
| 4 | JSON: sintassi, JSON vs XML | 2 |
| 5 | Parsing/serializzazione e JSON Schema + laboratorio | 4 |
| 6 | Verifica finale | 1–2 |

**Suggerimenti**

- Fai eseguire `validatori/test-esempi.sh` all'inizio: verifica che gli strumenti funzionino per tutti.
- Le cartelle `errori/` e i file `*-non-valido.xml` sono pensati per la **didattica del messaggio d'errore**: chiedi agli studenti di *prevedere* l'errore prima di lanciare il validatore.
- Nel laboratorio i file `*-errato.xml` fungono da **test al contrario**: una DTD o uno schema che li accetta è troppo permissivo.

## 📌 Roadmap

- [x] Modulo 1 — XML, DTD, XSD (teoria, esempi, validatori, laboratorio)
- [ ] Modulo 2 — JSON: sintassi e tipi di dato
- [ ] Modulo 2 — JSON vs XML: tabella comparativa e casi d'uso
- [ ] Modulo 2 — Parsing e serializzazione (JavaScript / Java)
- [ ] Modulo 2 — JSON Schema
- [ ] Modulo 2 — Laboratorio e verifica finale
