---
name: stem-notes
description: Supplementary notes generation for STEM. Turns lecture slides, textbook chapters, scanned problem sheets, images (png/jpg) or PowerPoint/Word files into LaTeX formula/definition sheets, fully worked problem solutions, and summary notes, extracting figures from PDFs to embed and, for whole books, building a reusable knowledge skill first. Use when the user asks for notes, a formula sheet, cheat sheet, worked solutions or revision material from reference/source files.
---

# STEM supplementary notes (LaTeX)

Generate study material as `.tex` files from any STEM source material. The user drives every choice through multiple-choice questions (AskUserQuestion), so ask before building.

## Settings
- Book skill: book-to-skill

If the user picks a different or renamed book skill in the MCQs below, edit the line above in this file (the user's installed copy) so later runs use it.

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
- If the user calls a source a "book"/"textbook", or `pdfinfo` shows it is long (roughly >100 pages), flag it for the **Book** question in round 1 below — don't decide silently, ask. Also check `~/.claude/skills/*/SKILL.md` for one already covering that title (e.g. a prior `anderson-flight`-style skill) to offer as "use existing" instead of regenerating.

### 2. Check the tooling (read-only first)
Run `which pdfinfo pdftotext pdftoppm soffice tectonic pdflatex`. Anything missing that is needed goes into the first MCQ round, with its size (see `references/tooling.md`). **Never install without an MCQ answer.** LibreOffice is only needed when Office files are present. If a book route is chosen, also check the configured book skill exists at `~/.claude/skills/<Book skill>/SKILL.md` — missing means the **Book skill setup** question is needed. If the user answers a question with a question (e.g. "how much storage?"), answer it, then re-ask.

### 3. Intake MCQs
Ask the rounds in `references/questions.md`, at most 4 questions per AskUserQuestion call. Put the recommended option first and mark it "(Recommended)". Only ask the question groups for the outputs the user selected. The **compile question is always asked, last**. Read the answers literally: free-text answers override the options.

### 4. Book route (only if chosen in round 1)
- Install the book skill only on an explicit MCQ answer (see `references/questions.md`); free-text names/paths override the default and get written to the Settings line above.
- Invoke the configured book skill (Skill tool) on the book to generate its knowledge-skill folder (`SKILL.md`, `chapters/*.md`, `cheatsheet.md`, `glossary.md`, etc.), unless an existing one was chosen instead.
- Treat that generated skill's markdown files as the source for step 5 instead of re-reading every page of the original PDF. Still view the original PDF pages for any figure or equation the markdown dropped, and for figure extraction (step 6).
- Tell the user in the final report that the generated skill is reusable afterwards — for questions, worked problems, or more notes later, e.g. `/<skill-name> <topic>`.

### 5. Read everything
- PDFs: use the Read tool with `pages` (**max 20 pages per call**, so split larger ranges) and issue all page-range reads for all files in **one parallel batch**. The Read tool needs poppler's `pdftoppm`. Skip this for pages already covered by the book route's generated skill (step 4).
- Images: Read them directly.
- PPTX/DOCX: convert to PDF in the scratchpad (`soffice --headless --convert-to pdf --outdir <scratchpad> file`), then read as PDF.
- Note for every question or example: source file, slide/page, problem number, whether the source already solves it (fully or partly), and any printed answer.

### 6. Extract figures (only if the sources contain any, per the Figures MCQ)
- List embedded raster images: `pdfimages -list file.pdf`, then `pdfimages -png -f N -l N file.pdf "<output>/figures/pN"` for pages that need it.
- For vector-drawn diagrams/plots with no embedded image (or that pdfimages can't isolate), render and crop the page instead: `pdftoppm -png -r 200 -f N -l N -x X -y Y -W W -H H -singlefile file.pdf "<output>/figures/pN-fig1"`, picking the crop box from the page you already viewed in step 5. Try both methods and keep whichever produced a clean, legible file.
- Skip logos, decorations, and other non-content images.
- Write `<output>/figures/figures.md`: one row per kept figure — file name, source, page, what it shows.
- Follow the Figures MCQ answer for what happens next: catalog only, auto-insert the relevant ones, or catalog-then-let-the-user-pick (a follow-up multiSelect MCQ listing `figures.md`'s rows, ≤4 per AskUserQuestion call).

### 7. Solve and verify
- Work every problem in scope. For anything non-trivial (curve fits, integrals, moment balances, multi-step numerics), check the numbers with a short `python3` script in the scratchpad.
- Compare with printed answers. **If they disagree, recheck, then report the discrepancy in the document and to the user.** Never bend the working to match a printed answer.
- Flag source typos (wrong signs, wrong terms, inconsistent data) in a footnote or a "Why it is here" note.

### 8. Write the .tex files
- Start from the matching template in `templates/`: keep its preamble and replace the `%% TODO` placeholders.
- Follow `references/style-guide.md`: tag every item with source · slide/page · problem number, add a coverage table, restate each question in full, box the answers.
- Insert chosen figures with `\includegraphics[width=...]{figures/<file>}` plus a caption carrying the source tag.
- Use ASCII-only source. Comments are one-line `%` comments only, never multi-line banner comments.
- Default output folder is `latex/` next to the sources, unless the user chose otherwise.

### 9. Compile only if the user chose to
- tectonic: `tectonic -X compile file.tex`. MacTeX: `latexmk -pdf file.tex`. Fix errors and recompile until clean.
- If the user says stop, stop the task immediately (TaskStop) and do not retry.

### 10. Report
Briefly list: the files written, what each covers, figures extracted (count and the `figures.md` path), questions skipped (already solved in the source), discrepancies found, and compile status. If a book skill was generated or reused, name it and how to reuse it later (`/<skill-name> <topic>`). If you did not compile, say so plainly.
