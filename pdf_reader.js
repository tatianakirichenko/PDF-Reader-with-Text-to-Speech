// pdf_reader.js
const fs = require('fs');
const pdfParse = require('pdf-parse');
const { exec } = require('child_process');
const os = require('os');

function extractText(pdfPath, pageRange) {
    const dataBuffer = fs.readFileSync(pdfPath);
    return pdfParse(dataBuffer).then(data => {
        let text = data.text;
        // Simple page range filtering (approximate) – pdf-parse doesn't support page ranges directly
        // We'll skip for simplicity, but we can split by pages if needed.
        return text;
    });
}

function speak(text, speed = 1.0) {
    const platform = os.platform();
    let cmd;
    if (platform === 'darwin') {
        cmd = `say -r ${Math.round(175 * speed)} "${text.replace(/"/g, '\\"')}"`;
    } else if (platform === 'linux') {
        cmd = `espeak -s ${Math.round(175 * speed)} "${text.replace(/"/g, '\\"')}"`;
    } else {
        // Windows: use PowerShell's Speak or fallback
        cmd = `powershell -Command "Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('${text.replace(/'/g, "''")}')"`;
    }
    exec(cmd, (error, stdout, stderr) => {
        if (error) console.error('TTS error:', error);
    });
}

function truncate(s, n) {
    return s.length > n ? s.substring(0, n) + '...' : s;
}

async function main() {
    const args = process.argv.slice(2);
    if (args.length < 1) {
        console.log('Usage: node pdf_reader.js document.pdf [--page 1-5] [--speed 1.0] [--silent]');
        process.exit(1);
    }
    let filePath = args[0];
    let pageRange = null;
    let speed = 1.0;
    let silent = false;
    for (let i = 1; i < args.length; i++) {
        if (args[i] === '--page' && i+1 < args.length) {
            pageRange = args[++i];
        } else if (args[i] === '--speed' && i+1 < args.length) {
            speed = parseFloat(args[++i]);
        } else if (args[i] === '--silent') {
            silent = true;
        }
    }
    try {
        const text = await extractText(filePath, pageRange);
        if (text) {
            console.log('Extracted text:\n', truncate(text, 500));
            if (!silent) {
                speak(text, speed);
            }
        } else {
            console.log('No text extracted.');
        }
    } catch (err) {
        console.error('Error:', err.message);
    }
}

main();
