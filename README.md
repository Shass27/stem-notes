# stem-notes

A Claude Code skill that turns STEM source material (lecture slides, textbook
chapters, scanned problem sheets, images, PowerPoint/Word files) into LaTeX
study documents: formula/definition sheets, fully worked problem solutions,
and summary notes.

## How it works

The user is driven through the whole process with multiple-choice questions
(`AskUserQuestion`) — nothing is generated silently. The skill:

1. Inventories the given sources (PDF, PNG/JPG, PPTX/DOCX) and checks whether
   each PDF is text-based or scanned.
2. Checks for required tooling (`poppler`, `soffice`, `tectonic`/`pdflatex`)
   and asks before installing anything.
3. Asks intake questions: which outputs to generate, output location, visual
   style, and per-output questions (density, scope, depth, ordering, etc.).
4. Reads every source page/slide/image in full.
5. Solves and verifies every problem in scope, checking non-trivial numbers
   with a short Python script, and flags any discrepancy with a printed
   answer instead of silently matching it.
6. Writes ASCII-only `.tex` files from the templates in `templates/`.
7. Optionally compiles to PDF (`tectonic` or `latexmk`), fixing errors until
   it compiles cleanly.
8. Reports what was written, what was skipped, and any discrepancies found.

## Layout

- `SKILL.md` — the workflow the skill follows, step by step.
- `references/questions.md` — the MCQ question bank used for intake.
- `references/tooling.md` — required tools, install commands/sizes, and the
  shell commands used to inspect/convert sources.
- `references/style-guide.md` — layout, labelling, and solution-format rules
  for each output type.
- `templates/formula_sheet.tex` — formula/definition sheet preamble.
- `templates/solutions.tex` — worked-solutions preamble.
- `templates/summary_notes.tex` — summary-notes preamble.

## Output

By default, generated `.tex` files (and PDFs, if compiled) are written to a
`latex/` subfolder next to the source files, unless the user chooses
otherwise.

## License

MIT — see `LICENSE`.
