📖 PDF Reader with Text‑to‑Speech – Multi‑Language Edition
A versatile PDF reader that extracts text from any PDF file and reads it aloud using Text‑to‑Speech (TTS) synthesis.
Supports interactive mode (choose page range, speed, voice) and command‑line mode (quick read).
Built in 7 programming languages – each implementation leverages platform‑native TTS or cross‑platform libraries.

✨ Features
Extract text – reads all pages or a specific page range from a PDF.

Text‑to‑Speech – speaks the extracted text using system voices.

Adjustable speed – slow, normal, fast (where supported).

Voice selection – choose from available system voices (on supported platforms).

Silent mode – extract text without speaking (just print).

Cross‑platform – works on Windows, macOS, and Linux (with appropriate dependencies).

🗂 Languages & Files
Language	File
Python	pdf_reader.py
Go	pdf_reader.go
JavaScript (Node)	pdf_reader.js
C#	PdfReader.cs
Java	PdfReader.java
Ruby	pdf_reader.rb
Swift	pdf_reader.swift
🚀 How to Run
Each file is standalone – run it with the appropriate interpreter/compiler.
Dependencies: see the README for each language.

Language	Command
Python	python pdf_reader.py document.pdf [--page 1-5] [--speed 1.0]
Go	go run pdf_reader.go document.pdf [-page 1-5] [-speed 1.0]
JavaScript	node pdf_reader.js document.pdf [--page 1-5] [--speed 1.0]
C#	dotnet run -- document.pdf [--page 1-5] [--speed 1.0]
Java	java PdfReader document.pdf [--page 1-5] [--speed 1.0]
Ruby	ruby pdf_reader.rb document.pdf [--page 1-5] [--speed 1.0]
Swift	swift pdf_reader.swift document.pdf [-page 1-5] [-speed 1.0]
📦 Dependencies by Language
Language	PDF Library	TTS Library / Command
Python	PyPDF2	pyttsx3 (cross‑platform)
Go	ledongthuc/pdf	espeak or say (system)
JavaScript	pdf-parse	say (macOS) or espeak (Linux) / ps (Windows)
C#	iTextSharp	System.Speech (Windows) / espeak (Linux/macOS)
Java	Apache PDFBox	FreeTTS or system say/espeak
Ruby	pdf-reader	espeak or say (system)
Swift	PDFKit (macOS)	NSSpeechSynthesizer (macOS) / espeak (Linux)
📜 License
MIT – use freely.
