# Revision handbook workflow

This route rebuilds the process that produced the Fluid Mechanics handbooks (Ch 4-5 and Ch 6-9). The output is one LaTeX source plus its PDF, built with `tectonic`. The source of truth is the lecture material. Every formula must trace back to a slide, and every result must point to the equation it came from.

## Step 0: Ask setup questions first (MCQ)

Ask with AskUserQuestion before doing any work. Ask only what changes the build:

1. **Scope:** which decks or chapters are in the exam. Ask as a multi-select (e.g. "Ch4 is not in the syllabus"). Drop out-of-syllabus material. Keep a lead-in if it is needed to understand the rest.
2. **Page budget:** total pages, default about 2 pages per 4 chapters. Single PDF or separate PDFs.
3. **Depth:** formulas + one-line why (default), or fuller derivations (rare; expect more pages).
4. **Procedures:** for procedure-heavy chapters (dimensional analysis, pipe problems), offer a short numbered recipe beside the formulas (default: yes).
5. **Problems:** include worked examples as result formulas only (default), or drop them.

If the user's answers are already in the prompt, skip the question. Never ask a question you can answer from the files.

## Step 1: Inventory each deck (parallel subagents)

Use `references/handbook-inventory-prompt.md`. One agent per deck (split decks over ~40 pages). Each agent renders pages to PNG and reads them, because many slides are equation images and `pdftotext` misses them. Each writes a slide-ordered inventory into `<scratch>/inv/<deck>.md`.

Image-only decks (no text layer) must be read visually. Check with `pdftotext` first and say so in the prompt.

Each inventory lists, per key result: the LaTeX equation, its name, its parent equation (what it comes from), assumptions, a one-line "how the previous result led here", and any slide typo. Worked numbers are dropped; only result formulas are kept.

## Step 2: Plan the spine

Write a plan file before drafting (in the scratch dir or `~/.claude/plans/`). It must contain:

- The **derivation tree**: one root (usually the governing theorem or conservation law) with branches per topic. Each branch node says which parent equation it comes from. Example: RTT -> continuity / momentum / energy -> Bernoulli -> consequences.
- A **topic block list** with a target column count for each block. Weight blocks by how much exam material they carry. Start from the page budget, not the slide count.
- A **label prefix** per block (`c6`, `c7`, ...) so merged labels never collide.
- Which **slide errors** will be corrected, and which items are not in the slides. Those items get a `[not in slides]` tag or a star. Never silently add material.

Show the user the block list and the page split, and get a yes before drafting.

## Step 3: Draft fragments (parallel subagents)

Use `references/handbook-fragment-prompt.md`. One agent per block, each writing only `frag_<block>.tex`. The agent copies style from `templates/handbook_preamble.tex` and the main file's first sections, then test-fits its fragment in a wrapper and reports columns used.

Keep the house style (set by the user's earlier feedback):
- `\key{...}`: bold yellow box, used only for results that matter in the exam.
- Under every `\key` box: a `\scriptsize` "*where* ..." line defining every symbol (meaning, units where useful). If the formula holds a tensor, also write it out as a full matrix (3x3 components; a 4th-order stiffness as the 6x6 Voigt matrix).
- `bl` bullets for concepts; a bold lead term on each bullet.
- `\hd{...}` blue section bars.
- One-line "why / from (n)" beside results. No worked numerics. No exam-trap strip unless asked.
- 2-4 small TikZ sketches per chapter, about 2 cm tall.

## Step 4: Merge and build

1. Start from `templates/handbook_preamble.tex` (already ends with `\begin{document}`). Add a centred title line, a small legend (bold box = key result, starred = not in slides), and a TikZ **flow map** of the derivation tree (about 10 nodes).
2. Add `\begin{multicols}{2}`, the fragments in topic order, then `\end{multicols}\end{document}`. For a block that starts on a new page, put `\newpage` and a block strip before it.
3. Fix the fragment label names so every `\er{...}` resolves in the merged file.
4. Run `scripts/build_handbook.sh <file.tex> <expected_pages>`. It compiles twice (so references resolve), reports overfull boxes, undefined references and the page count, and renders PNGs to `_render/`.

## Step 5: QA by eye, then fit

View every rendered page and check:
- equations clipped at column edges; overfull boxes
- a blank or half-empty column, or a heading stranded at a column end
- `(??)` references (should be zero after two passes)
- font: bold must be visible in `\key` boxes

Fit: if the output overflows, trim in this order: secondary tables and extra examples, then secondary bullets, then optional sketches. Never drop a core chain or a key result. If there is spare room, add sketches or the missing key results before adding prose.

## Step 6: Coverage check (do not skip)

Before delivery, tick every formula in every inventory file against the built PDF. Use the inventory list, not memory. Anything missing is either added or listed as deliberately dropped with a reason. This is the "don't miss any" check the user asked for in every round.

Also check that slide errors from the inventories are fixed or flagged, and list the fixes in the final message.

## Step 7: Deliver

Copy the `.tex` and `.pdf` to the course folder, named `<course>_revision_handbook.pdf` (or the next free name, so an earlier handbook is never overwritten). Report:
- pages and the block split
- anything not in the slides (starred items)
- slide errors corrected
- known gaps (for example, a deck that has no solved answers)

## Pitfalls

Read `references/handbook-pitfalls.md` before the first build. It lists the bold-font, `\Bbbk`, `\Needspace`-in-`multicols`, reference-pass and subagent-fit problems that already cost time once.

## Notes on scope

- Solved-problem compilations (cropped slide images grouped by topic) are a different output. Do not build them here unless asked.
- Handwritten notes need OCR or visual transcription first. Use the handwritten-to-latex skill to get clean source, then run this skill on the result.
