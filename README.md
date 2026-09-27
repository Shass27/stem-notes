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
4. For a whole book, offers to build a reusable knowledge skill first (see
   **Workflows** below) instead of reading every page.
5. Reads every source page/slide/image in full.
6. Extracts figures from PDFs (`pdfimages` for embedded raster images,
   page-render + crop for vector diagrams) into a `figures/` folder with an
   index, and asks whether to insert them, catalog them for later, or skip.
7. Solves and verifies every problem in scope, checking non-trivial numbers
   with a short Python script, and flags any discrepancy with a printed
   answer instead of silently matching it.
8. Writes ASCII-only `.tex` files from the templates in `templates/`.
9. Optionally compiles to PDF (`tectonic` or `latexmk`), fixing errors until
   it compiles cleanly.
10. Reports what was written, what was skipped, and any discrepancies found.

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

## Workflows

**Lecture slides / problem sheets -> notes** (the default flow): point the
skill at your source files, answer the intake questions, get `.tex` files
(and figures, if any) back.

**Book -> knowledge skill -> notes**: for a whole textbook, stem-notes asks
whether to build a reusable knowledge skill first with
[book-to-skill](https://github.com/virgiliojr94/book-to-skill), rather than
reading every page. This workflow step, and the tool it calls, is the work of
[virgiliojr94](https://github.com/virgiliojr94) — credit for it belongs to
them, not to stem-notes:

```bash
git clone https://github.com/virgiliojr94/book-to-skill ~/.claude/skills/book-to-skill
# or: npx skills add virgiliojr94/book-to-skill
```

1. Run book-to-skill on the book (e.g. `/book-to-skill book.pdf my-book`) to
   get a knowledge skill (`SKILL.md`, `chapters/*.md`, `cheatsheet.md`,
   `glossary.md`) — see `anderson-flight` or `callister-materials-science`
   for examples already in this skills folder.
2. Run stem-notes on that generated skill's files to produce formula sheets,
   worked solutions, or summary notes from it.
3. Keep using the generated book skill afterwards on its own (`/my-book
   <topic>`) for questions, worked problems, or more notes — it isn't
   single-use.

If you already have that book skill installed under a different name, or
prefer a different converter skill entirely, stem-notes asks and remembers
your choice in the `Book skill:` line of `SKILL.md`.

**Figures**: extracted PDF figures land in `latex/figures/` with a
`figures.md` index. You can ask later, e.g. "add figure p12-1 to the summary
notes", without re-running extraction.

## Output

By default, generated `.tex` files (and PDFs, if compiled) are written to a
`latex/` subfolder next to the source files, unless the user chooses
otherwise. Extracted figures go in `latex/figures/`.

## License

MIT — see `LICENSE`.
