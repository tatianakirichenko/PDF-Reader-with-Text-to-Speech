// PdfReader.cs
using System;
using System.IO;
using System.Text;
using System.Speech.Synthesis;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.parser;

class PdfReader
{
    static string ExtractText(string filePath, string pageRange)
    {
        StringBuilder sb = new StringBuilder();
        using (PdfReader reader = new PdfReader(filePath))
        {
            int totalPages = reader.NumberOfPages;
            int start = 1, end = totalPages;
            if (!string.IsNullOrEmpty(pageRange))
            {
                var parts = pageRange.Split('-');
                if (parts.Length == 2 && int.TryParse(parts[0], out int s) && int.TryParse(parts[1], out int e))
                {
                    start = Math.Max(1, s);
                    end = Math.Min(totalPages, e);
                }
            }
            for (int i = start; i <= end; i++)
            {
                sb.Append(PdfTextExtractor.GetTextFromPage(reader, i));
                sb.Append('\n');
            }
        }
        return sb.ToString();
    }

    static void Speak(string text, double speed = 1.0)
    {
        using (SpeechSynthesizer synth = new SpeechSynthesizer())
        {
            synth.Rate = (int)(speed * 2 - 2); // -10 to 10 range
            synth.Speak(text);
        }
    }

    static void Main(string[] args)
    {
        if (args.Length < 1)
        {
            Console.WriteLine("Usage: PdfReader.exe document.pdf [--page 1-5] [--speed 1.0] [--silent]");
            return;
        }
        string filePath = args[0];
        string pageRange = null;
        double speed = 1.0;
        bool silent = false;
        for (int i = 1; i < args.Length; i++)
        {
            if (args[i] == "--page" && i + 1 < args.Length)
                pageRange = args[++i];
            else if (args[i] == "--speed" && i + 1 < args.Length)
                double.TryParse(args[++i], out speed);
            else if (args[i] == "--silent")
                silent = true;
        }
        if (!File.Exists(filePath))
        {
            Console.WriteLine("File not found.");
            return;
        }
        string text = ExtractText(filePath, pageRange);
        if (!string.IsNullOrEmpty(text))
        {
            Console.WriteLine("Extracted text:\n" + (text.Length > 500 ? text.Substring(0, 500) + "..." : text));
            if (!silent)
                Speak(text, speed);
        }
        else
        {
            Console.WriteLine("No text extracted.");
        }
    }
}
