# Style guide

## General
- Font: Latin Modern (`lmodern`, `T1`). Default look: black and white with light-grey boxes (`gray!8`–`gray!12`). Page header via `fancyhdr`.
- ASCII-only `.tex` source. One-line `%` comments only.
- Identify each source by a short key defined at the top, e.g. `L2 = FMclass_2.pdf`, `K = ME2240 Lectures 8-10`. Write references as `L7-8 s10` (slide 10) or `Chapter 3 · Page 4 · Problem 3-73`.
- Use SI units unless the source uses US units. State the standard values used ($g=9.81$, $\rho_w=1000$).

## Formula / definition sheet (`templates/formula_sheet.tex`)
- Optional nomenclature table first (symbol | meaning | SI unit, two column-pairs).
- One `\section` per source/lecture, with the lecture tag right-aligned in the heading.
- Definitions: compact `defs` list, one line per term (`\item[Term:] text`).
- Formulas: `xltabular` with the row macro `\F{quantity}{formula}{units}{ref}`; the formula cell is shaded grey; the header `\FH` repeats on every page. Leave the first argument empty to continue a group.
- For a cheat sheet (2–3 columns), switch to `multicols` and `\small`/`\footnotesize`, and drop the units column if space is tight.
- Footnote any correction of a source error.

## Solutions (`templates/solutions.tex`)
- Top of the document: title, one-line scope statement, a **coverage table** (No. | source | page/slide | status unsolved/partial | topic), and a "Skipped (already solved in source)" line when the scope excludes solved items.
- Each problem:
  1. `question` box, titled `Problem X` with the tag on the right; the question restated **in full**, including figure data described in words.
  2. Optional `\small\itshape Why it is here:` note for partially solved items.
  3. `\hd{Given}`, `\hd{Assumptions}`, `\hd{Solution}` (derive symbolically first, then substitute numbers with units).
  4. `answer` box with `\boxed{}` results; text answers for conceptual items.
- Conceptual questions: use `\hd{Key idea}` instead of Given/Assumptions.
- Figures: small TikZ sketches only where the geometry matters (FBDs, velocity profiles).

## Summary notes (`templates/summary_notes.tex`)
- One section per lecture/chapter: a short prose overview, then `defs`, then key equations (display math, numbered), `keyidea` boxes, and optional worked examples.

## Verification and honesty
- Check every non-trivial number with python3 in the scratchpad.
- If a printed answer disagrees: recheck the reading of the figure and the assumptions. If it still disagrees, give your result, state the printed value, and explain the likely cause (unit or density choice, figure ambiguity, typo). Mention it in the final report.
- If data is missing (e.g. an unstated manometer fluid), state the assumption explicitly in `\hd{Assumptions}`.
