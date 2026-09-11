---
name: stem-notes
description: Supplementary notes generation for STEM. Turns lecture slides, textbook chapters, scanned problem sheets, images (png/jpg) or PowerPoint/Word files into LaTeX formula/definition sheets, fully worked problem solutions, and summary notes. Use when the user asks for notes, a formula sheet, cheat sheet, worked solutions or revision material from reference/source files.
---

# STEM supplementary notes (LaTeX)

Generate study material as `.tex` files from any STEM source material. The user drives every choice through multiple-choice questions (AskUserQuestion), so ask before building.

Supporting files (read them when you reach the matching step):
- `references/tooling.md`: software, install commands and sizes, conversion commands
- `references/questions.md`: the MCQ question bank (intake rounds, including the compile question)
- `references/style-guide.md`: layout, labelling, solution format, verification and discrepancy rules
- `templates/formula_sheet.tex`, `templates/solutions.tex`, `templates/summary_notes.tex`: preambles to copy

## Workflow

### 1. Inventory the sources
- List the files the user pointed at (folder or `@` paths). Accept PDF, PNG/JPG, PPTX/DOCX.
- For each PDF run `pdfinfo` (page count) and `pdftotext -layout` into the session scratchpad, then count words. **Fewer than ~50 words per page means a scanned or image-heavy file**: read every page as an image; the text dump is useless.
- Slide decks often keep equations and figures only as images. Even when text exists, still view the pages.

### 2. Check the tooling (read-only first)
Run `which pdfinfo pdftotext pdftoppm soffice tectonic pdflatex`. Anything missing that is needed goes into the first MCQ round, with its size (see `references/tooling.md`). **Never install without an MCQ answer.** LibreOffice is only needed when Office files are present. If the user answers a question with a question (e.g. "how much storage?"), answer it, then re-ask.

### 3. Intake MCQs
Ask the rounds in `references/questions.md`, at most 4 questions per AskUserQuestion call. Put the recommended option first and mark it "(Recommended)". Only ask the question groups for the outputs the user selected. The **compile question is always asked, last**. Read the answers literally: free-text answers override the options.

### 4. Read everything
- PDFs: use the Read tool with `pages` (**max 20 pages per call**, so split larger ranges) and issue all page-range reads for all files in **one parallel batch**. The Read tool needs poppler's `pdftoppm`.
- Images: Read them directly.
- PPTX/DOCX: convert to PDF in the scratchpad (`soffice --headless --convert-to pdf --outdir <scratchpad> file`), then read as PDF.
- Note for every question or example: source file, slide/page, problem number, whether the source already solves it (fully or partly), and any printed answer.

### 5. Solve and verify
- Work every problem in scope. For anything non-trivial (curve fits, integrals, moment balances, multi-step numerics), check the numbers with a short `python3` script in the scratchpad.
- Compare with printed answers. **If they disagree, recheck, then report the discrepancy in the document and to the user.** Never bend the working to match a printed answer.
- Flag source typos (wrong signs, wrong terms, inconsistent data) in a footnote or a "Why it is here" note.

### 6. Write the .tex files
- Start from the matching template in `templates/`: keep its preamble and replace the `%% TODO` placeholders.
- Follow `references/style-guide.md`: tag every item with source · slide/page · problem number, add a coverage table, restate each question in full, box the answers.
- Use ASCII-only source. Comments are one-line `%` comments only, never multi-line banner comments.
- Default output folder is `latex/` next to the sources, unless the user chose otherwise.

### 7. Compile only if the user chose to
- tectonic: `tectonic -X compile file.tex`. MacTeX: `latexmk -pdf file.tex`. Fix errors and recompile until clean.
- If the user says stop, stop the task immediately (TaskStop) and do not retry.

### 8. Report
Briefly list: the files written, what each covers, questions skipped (already solved in the source), discrepancies found, and compile status. If you did not compile, say so plainly.
