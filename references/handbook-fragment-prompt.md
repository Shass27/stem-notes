# Subagent prompt: draft one chapter fragment (Step 3)

Spawn one general-purpose agent per topic block, in parallel. Each writes only its own fragment file, never the main .tex.

Task text to send (fill the braces):

> Draft ONE LaTeX fragment for a revision handbook. Read {MAIN_TEX} first, lines 1-19 (preamble and macros) plus the first two sections, to copy the style: `\hd{}` section bars, `bl` bullet environment, `\key{}` boxed bold results with `\label`, `\nt{}` notes, `\er{label}` back-references, small TikZ sketches.
> Write ONLY {SCRATCH}/frag_{BLOCK}.tex (body only: \hd, bl, equations, tikz, tabular). Prefix every new label with `{PREFIX}`. Do NOT edit {MAIN_TEX}.
> Style: bold yellow `\key` for important results only; one-line "why / from (n)" beside each result; under every `\key` box a `\scriptsize` "where" line defining each symbol, plus the full matrix form of any tensor in it (3x3, or the 6x6 Voigt matrix for C_ijkl); formulas, not worked numerics; mark [not in slides] items.
> Target length: {COLUMNS} columns (about {PAGES} pages in two-column layout).
> Use these inventory notes: {INVENTORY FILE(S)}.
> Test-fit: wrap it (copy preamble lines 1-19, then `\begin{multicols}{2}\input{frag_{BLOCK}}\end{multicols}\end{document}`), compile with tectonic, and report the used height in columns. Adjust to the target. Final reply: fragment path, columns used, and anything unsure. No internal IDs.

Rules for the orchestrator:
- Each block gets its own label prefix so merged labels never collide.
- Tell the agent the earlier labels it may reference with `\er`, taken from the main file's `\label` list.
- Expect fragments to land within about ±15% of target. Trim the least important bullets first; never drop a key result.
