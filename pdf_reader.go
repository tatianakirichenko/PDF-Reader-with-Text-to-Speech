// pdf_reader.go
package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"strconv"
	"strings"

	"github.com/ledongthuc/pdf"
)

func extractText(filePath string, pageRange string) string {
	file, r, err := pdf.Open(filePath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error opening PDF: %v\n", err)
		os.Exit(1)
	}
	defer file.Close()
	totalPages := r.NumPage()
	start := 1
	end := totalPages
	if pageRange != "" {
		parts := strings.Split(pageRange, "-")
		if len(parts) == 2 {
			s, _ := strconv.Atoi(parts[0])
			e, _ := strconv.Atoi(parts[1])
			if s > 0 && e <= totalPages && s <= e {
				start = s
				end = e
			}
		}
	}
	var text strings.Builder
	for i := start; i <= end; i++ {
		page := r.Page(i)
		content, _ := page.GetPlainText(nil)
		text.WriteString(content)
		text.WriteString("\n")
	}
	return text.String()
}

func speak(text string, speed float64) {
	var cmd *exec.Cmd
	switch runtime.GOOS {
	case "darwin":
		cmd = exec.Command("say", "-r", fmt.Sprintf("%d", int(175*speed)), text)
	case "linux":
		cmd = exec.Command("espeak", "-s", fmt.Sprintf("%d", int(175*speed)), text)
	default:
		fmt.Println("TTS not supported on this OS.")
		return
	}
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	_ = cmd.Run()
}

func main() {
	fileFlag := flag.String("file", "", "PDF file path")
	pageFlag := flag.String("page", "", "Page range (e.g., 1-5)")
	speedFlag := flag.Float64("speed", 1.0, "Speech speed (0.5-2.0)")
	silentFlag := flag.Bool("silent", false, "Do not speak")
	flag.Parse()
	if *fileFlag == "" {
		fmt.Println("Usage: pdf_reader -file document.pdf [-page 1-5] [-speed 1.0] [-silent]")
		os.Exit(1)
	}
	text := extractText(*fileFlag, *pageFlag)
	if text != "" {
		fmt.Println("Extracted text:\n", truncate(text, 500))
		if !*silentFlag {
			speak(text, *speedFlag)
		}
	} else {
		fmt.Println("No text extracted.")
	}
}

func truncate(s string, n int) string {
	if len(s) <= n {
		return s
	}
	return s[:n] + "..."
}
