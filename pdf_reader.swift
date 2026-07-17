// pdf_reader.swift
import Foundation
import PDFKit
#if os(macOS)
import AppKit
#endif

func extractText(filePath: String, pageRange: String?) -> String {
    guard let url = URL(string: filePath), let pdf = PDFDocument(url: url) else {
        return ""
    }
    let totalPages = pdf.pageCount
    var start = 1, end = totalPages
    if let range = pageRange {
        let parts = range.split(separator: "-")
        if parts.count == 2, let s = Int(parts[0]), let e = Int(parts[1]) {
            start = max(1, s)
            end = min(totalPages, e)
        }
    }
    var text = ""
    for i in start...end {
        if let page = pdf.page(at: i-1) {
            if let pageText = page.string {
                text += pageText + "\n"
            }
        }
    }
    return text
}

func speak(text: String, speed: Double) {
    #if os(macOS)
    let synthesizer = NSSpeechSynthesizer()
    let rate = 175.0 * speed
    synthesizer.rate = Float(rate)
    synthesizer.startSpeaking(text)
    // Wait until speaking finishes (simple)
    while synthesizer.isSpeaking {
        Thread.sleep(forTimeInterval: 0.1)
    }
    #else
    // Linux fallback to espeak
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/espeak")
    task.arguments = ["-s", String(Int(175 * speed)), text]
    try? task.run()
    task.waitUntilExit()
    #endif
}

func truncate(_ s: String, _ n: Int) -> String {
    return s.count > n ? String(s.prefix(n)) + "..." : s
}

let args = CommandLine.arguments.dropFirst()
if args.count < 1 {
    print("Usage: swift pdf_reader.swift document.pdf [-page 1-5] [-speed 1.0] [-silent]")
    exit(1)
}
var filePath = args[0]
var pageRange: String? = nil
var speed = 1.0
var silent = false

var i = 1
while i < args.count {
    switch args[i] {
    case "-page", "--page":
        if i+1 < args.count {
            pageRange = args[i+1]
            i += 2
        } else { i += 1 }
    case "-speed", "--speed":
        if i+1 < args.count {
            speed = Double(args[i+1]) ?? 1.0
            i += 2
        } else { i += 1 }
    case "-silent", "--silent":
        silent = true
        i += 1
    default:
        i += 1
    }
}

let text = extractText(filePath: filePath, pageRange: pageRange)
if !text.isEmpty {
    print("Extracted text:\n\(truncate(text, 500))")
    if !silent {
        speak(text: text, speed: speed)
    }
} else {
    print("No text extracted.")
}
