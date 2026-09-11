# Tooling

Check with `which pdfinfo pdftotext pdftoppm soffice tectonic pdflatex latexmk python3`. Ask (MCQ, with sizes) before installing anything.

| Tool | Used for | Install (macOS / Homebrew) | Disk |
|---|---|---|---|
| poppler (`pdfinfo`, `pdftotext`, `pdftoppm`) | page counts, text extraction, rendering PDF pages as images (the Read tool needs `pdftoppm`) | `brew install poppler` | ~35 MB |
| LibreOffice (`soffice`) | converting .pptx/.docx to PDF (only when Office files are present) | `brew install --cask libreoffice` | ~700 MB |
| tectonic | compiling LaTeX; downloads packages on demand | `brew install tectonic` | ~20 MB + 100–300 MB package cache |
| BasicTeX | minimal pdflatex | `brew install --cask basictex` | ~300 MB |
| MacTeX | full TeX distribution | `brew install --cask mactex` | 5–7 GB |
| python3 | checking numerical answers | preinstalled | — |

Linux equivalents: `apt-get install poppler-utils libreoffice texlive`; tectonic comes from its installer or the package manager.

## Commands

```bash
pdfinfo "file.pdf" | grep Pages                        # page count
pdftotext -layout "file.pdf" "$SCRATCH/file.txt"        # text layer (layout kept)
wc -w "$SCRATCH/file.txt"                               # < ~50 words/page -> scanned, read as images
soffice --headless --convert-to pdf --outdir "$SCRATCH" "deck.pptx"   # Office -> PDF
tectonic -X compile file.tex                            # compile (tectonic)
latexmk -pdf file.tex                                   # compile (MacTeX/BasicTeX)
```

## Reading pages
- Read tool: `Read(file_path, pages="1-20")`, **at most 20 pages per call**. Split larger ranges, e.g. "1-20", "21-40", and send them all in one parallel batch.
- A PDF read returns page images only when poppler is installed. Without it the call errors with "pdftoppm is not installed".
- Images (png/jpg) are read directly with Read.
