# pdf_reader.rb
require 'pdf-reader'
require 'open3'

def extract_text(file_path, page_range)
  reader = PDF::Reader.new(file_path)
  total_pages = reader.page_count
  start_page = 1
  end_page = total_pages
  if page_range
    parts = page_range.split('-')
    if parts.length == 2
      start_page = [1, parts[0].to_i].max
      end_page = [total_pages, parts[1].to_i].min
    end
  end
  text = ""
  (start_page..end_page).each do |page_num|
    text += reader.page(page_num).text + "\n"
  end
  text
end

def speak(text, speed)
  os = RUBY_PLATFORM
  if os =~ /darwin/
    system("say", "-r", (175 * speed).to_s, text)
  elsif os =~ /linux/
    system("espeak", "-s", (175 * speed).to_s, text)
  else
    puts "TTS not supported on this OS."
  end
end

if ARGV.length < 1
  puts "Usage: ruby pdf_reader.rb document.pdf [--page 1-5] [--speed 1.0] [--silent]"
  exit 1
end

file_path = ARGV[0]
page_range = nil
speed = 1.0
silent = false

i = 1
while i < ARGV.length
  case ARGV[i]
  when "--page"
    page_range = ARGV[i+1]
    i += 2
  when "--speed"
    speed = ARGV[i+1].to_f
    i += 2
  when "--silent"
    silent = true
    i += 1
  else
    i += 1
  end
end

text = extract_text(file_path, page_range)
if !text.empty?
  puts "Extracted text:\n#{text[0..500]}#{text.length > 500 ? '...' : ''}"
  unless silent
    speak(text, speed)
  end
else
  puts "No text extracted."
end
