// PdfReader.java
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import java.io.File;
import java.io.IOException;
import java.lang.ProcessBuilder;

public class PdfReader {
    public static String extractText(String filePath, String pageRange) throws IOException {
        try (PDDocument doc = PDDocument.load(new File(filePath))) {
            int totalPages = doc.getNumberOfPages();
            int start = 1, end = totalPages;
            if (pageRange != null) {
                String[] parts = pageRange.split("-");
                if (parts.length == 2) {
                    int s = Integer.parseInt(parts[0]);
                    int e = Integer.parseInt(parts[1]);
                    start = Math.max(1, s);
                    end = Math.min(totalPages, e);
                }
            }
            PDFTextStripper stripper = new PDFTextStripper();
            stripper.setStartPage(start);
            stripper.setEndPage(end);
            return stripper.getText(doc);
        }
    }

    public static void speak(String text, double speed) throws IOException, InterruptedException {
        String os = System.getProperty("os.name").toLowerCase();
        ProcessBuilder pb;
        if (os.contains("mac")) {
            pb = new ProcessBuilder("say", "-r", String.valueOf((int)(175 * speed)), text);
        } else if (os.contains("linux")) {
            pb = new ProcessBuilder("espeak", "-s", String.valueOf((int)(175 * speed)), text);
        } else {
            System.out.println("TTS not supported on this OS.");
            return;
        }
        Process p = pb.start();
        p.waitFor();
    }

    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.out.println("Usage: java PdfReader document.pdf [--page 1-5] [--speed 1.0] [--silent]");
            return;
        }
        String filePath = args[0];
        String pageRange = null;
        double speed = 1.0;
        boolean silent = false;
        for (int i = 1; i < args.length; i++) {
            if (args[i].equals("--page") && i+1 < args.length) {
                pageRange = args[++i];
            } else if (args[i].equals("--speed") && i+1 < args.length) {
                speed = Double.parseDouble(args[++i]);
            } else if (args[i].equals("--silent")) {
                silent = true;
            }
        }
        String text = extractText(filePath, pageRange);
        if (text != null && !text.isEmpty()) {
            System.out.println("Extracted text:\n" + (text.length() > 500 ? text.substring(0, 500) + "..." : text));
            if (!silent) {
                speak(text, speed);
            }
        } else {
            System.out.println("No text extracted.");
        }
    }
}
