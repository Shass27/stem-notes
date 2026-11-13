# Pitfalls found while building the Ch4-5 and Ch6-9 handbooks

Each entry is a problem we actually hit, with the fix that worked.

- **Bold does not render with mathptmx.** `\textbf`, headings and `\boldmath` looked regular. Use `newtxtext,newtxmath` for Times with real bold.
- **`\Bbbk` clash.** `newtxmath` plus `amssymb` redefines `\Bbbk`. Do not load `amssymb`; `newtxmath` covers the symbols.
- **Nested `$` inside `\nt{}`.** `\nt` must switch to `\text` in math mode (`\ifmmode`). Otherwise math errors appear.
- **`\scriptsize` in math.** Invalid there. Use `\text{\scriptsize ...}` or leave the note outside the equation.
- **TikZ plot syntax.** `domain=` must be given as `plot[domain=a:b,samples=20](\x,{...})`. A bare `\x` coordinate fails.
- **Overfull equations.** Split with `gathered`, and move notes out of the equation into the bullet.
- **Unbalanced `bl` environments.** Folding equations into bullets easily leaves an unmatched `\begin{bl}` or `\end{bl}`. Check with the build log before rendering.
- **`\Needspace` inside `multicols`.** A heading near a column end forced a page break and left page 2 mostly blank. Fix: drop `\Needspace` from `\hd` for multi-page `multicols` blocks, or split into separate `multicols` blocks per section.
- **Font fit.** The default font ran to 3 pages; Times fitted the same content on 2. Pick the narrower serif before cutting content.
- **Cross-references.** Every `\er{label}` needs two tectonic passes. Single-pass builds show `(??)`. A fragment compiled alone also shows `(??)` for labels in the main file; that is expected and resolves on merge.
- **BSD `sed -i` on macOS.** Fails on some edits. Use Python for in-place string replacement, with an `assert old in text` before each replace.
- **Subagent fragments drift in size.** Fragments came in at 1.8 to 4.75 columns against a 2.0 to 4.8 target. Measure each fragment in a wrapper, then trim the least important bullets first.
- **Solved-problem crops.** Crops estimated from 60 dpi renders were loose or tight by a few percent. Trim with `\includegraphics[page=N,trim=l b r t,clip]` and verify a sample visually. Put source PDFs in a folder without spaces in the path.
- **Page-count bloat from helper text.** The agents added "exam checklist" and "common slips" boxes beyond the source. Cut these first when the page budget is tight.
