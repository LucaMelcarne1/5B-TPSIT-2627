import java.io.File;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

/**
 * ValidaXsd - valida un documento XML contro un XML Schema usando solo la
 * libreria standard di Java (javax.xml.validation), nessuna dipendenza esterna.
 *
 * Compilazione:  javac ValidaXsd.java
 * Esecuzione:    java ValidaXsd <schema.xsd> <documento.xml>
 *
 * Esempio:
 *   java ValidaXsd ../esempi/03-xsd/game-server.xsd ../esempi/03-xsd/server-xsd-valido.xml
 */
public class ValidaXsd {

    /** Raccoglie TUTTI gli errori invece di fermarsi al primo. */
    static class RaccoltaErrori implements ErrorHandler {
        final List<String> errori = new ArrayList<>();

        @Override public void warning(SAXParseException e) { /* ignorati */ }

        @Override public void error(SAXParseException e) {
            errori.add("riga " + e.getLineNumber() + ": " + e.getMessage());
        }

        @Override public void fatalError(SAXParseException e) throws SAXException {
            errori.add("riga " + e.getLineNumber() + " (FATALE): " + e.getMessage());
            throw e; // un errore di well-formedness interrompe la validazione
        }
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.println("Uso: java ValidaXsd <schema.xsd> <documento.xml>");
            System.exit(2);
        }

        // 1. Carica lo schema (la "factory" sa leggere XSD)
        SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
        Schema schema = factory.newSchema(new File(args[0]));

        // 2. Crea il validatore e collega il gestore degli errori
        Validator validator = schema.newValidator();
        RaccoltaErrori gestore = new RaccoltaErrori();
        validator.setErrorHandler(gestore);

        // 3. Valida il documento
        try {
            validator.validate(new StreamSource(new File(args[1])));
        } catch (SAXException e) {
            // già registrato dal gestore (errore fatale)
        }

        // Stampa sempre in UTF-8, qualunque sia la codifica predefinita della console
        PrintStream out = new PrintStream(System.out, true, StandardCharsets.UTF_8);

        if (gestore.errori.isEmpty()) {
            out.println("✅ Il documento è VALIDO rispetto allo schema");
        } else {
            out.println("❌ Il documento NON è valido (" + gestore.errori.size() + " errori):");
            gestore.errori.forEach(msg -> out.println("   " + msg));
            System.exit(1);
        }
    }
}
