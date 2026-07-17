# pdf_reader.py
import sys
import argparse
import PyPDF2
import pyttsx3

def extract_text(pdf_path, page_range=None):
    text = ""
    with open(pdf_path, 'rb') as f:
        reader = PyPDF2.PdfReader(f)
        total_pages = len(reader.pages)
        if page_range:
            start, end = page_range
            start = max(0, start-1)
            end = min(total_pages, end)
        else:
            start, end = 0, total_pages
        for i in range(start, end):
            text += reader.pages[i].extract_text() + "\n"
    return text

def speak(text, speed=1.0, voice=None):
    engine = pyttsx3.init()
    if voice:
        voices = engine.getProperty('voices')
        for v in voices:
            if voice in v.name:
                engine.setProperty('voice', v.id)
                break
    engine.setProperty('rate', int(engine.getProperty('rate') * speed))
    engine.say(text)
    engine.runAndWait()

def main():
    parser = argparse.ArgumentParser(description='PDF Reader with TTS')
    parser.add_argument('file', help='PDF file path')
    parser.add_argument('--page', help='Page range: start-end (e.g., 1-5)')
    parser.add_argument('--speed', type=float, default=1.0, help='Speech speed (0.5-2.0)')
    parser.add_argument('--voice', help='Voice name (e.g., "Victoria" on macOS)')
    parser.add_argument('--silent', action='store_true', help='Only extract text, do not speak')
    args = parser.parse_args()

    page_range = None
    if args.page:
        parts = args.page.split('-')
        if len(parts) == 2:
            page_range = (int(parts[0]), int(parts[1]))
    text = extract_text(args.file, page_range)
    if text:
        print("Extracted text:\n", text[:500] + "..." if len(text) > 500 else text)
        if not args.silent:
            speak(text, args.speed, args.voice)
    else:
        print("No text extracted.")

if __name__ == "__main__":
    main()
