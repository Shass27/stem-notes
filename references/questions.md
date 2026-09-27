# MCQ question bank

Use AskUserQuestion with at most 4 questions per call. Put the recommended option first, labelled "(Recommended)". Headers must be 12 characters or fewer. Skip groups for outputs that were not selected. Adapt wording to the subject (e.g. "slide" or "page"). Honour free-text answers.

## Round 1: setup and scope
1. **Setup** (only if something is missing): "I need <tool> to <purpose>. How should I get it?" Options: install via brew (size) / lighter alternative / skip, with a stated consequence. For LibreOffice: "Install LibreOffice (~700 MB)" / "I'll export the files to PDF myself" / "Skip Office files".
2. **Book** (only if a source was flagged as a book in step 1 of SKILL.md): "\<file\> looks like a whole book (N pages). How should I handle it?"
   - "Build a knowledge skill with \<Book skill\> first (Recommended)": reusable afterwards for questions, worked problems, more notes
   - "Use existing skill \<name\>" (only offered if step 1 found one covering this title)
   - "Read the pages directly, as normal"
3. **Book skill setup** (only if "Build a knowledge skill" was chosen and it is not installed): "I need \<Book skill\> to build the knowledge skill. How should I get it?"
   - "Install book-to-skill (Recommended)": `git clone https://github.com/virgiliojr94/book-to-skill ~/.claude/skills/book-to-skill`
   - "I have it under a different name" (free text) → write that name to the Settings line in SKILL.md
   - "Use another related skill" (free text) → write that name to the Settings line in SKILL.md
   - "Skip, read the pages directly"
4. **Outputs** (multiSelect): "What should I generate from these sources?"
   - Formula / definition sheet
   - Problem-set solutions
   - Summary notes
5. **Output location**: "`latex/` subfolder (Recommended)" / "Same folder as the sources" / other.
6. **Visual style**: "Clean textbook (Recommended): Latin Modern, black and white, light-grey boxes" / "Coloured accents (coloured headings, tcolorbox)" / "Minimal plain article".
7. **Figures** (only if any source has extractable figures): "What should I do with figures in the sources?"
   - "Extract, catalog, and let me pick which to insert (Recommended)": saved to `figures/` with an index; a follow-up MCQ lists them for you to pick
   - "Auto-insert the relevant ones": Claude decides placement, no follow-up question
   - "Extract and catalog only": saved to `figures/figures.md`, insert later on request
   - "No figures"

## Round 2: formula / definition sheet
1. **Density**: "One column, textbook-dense, no page limit" / "One side A4, 2 columns (~8pt)" / "One side A4, 3 columns (~7pt cheat sheet)" / "Both sides of A4".
2. **Content** (multiSelect): key formulas / one-line definitions / units and constants / small sketches.
3. **Extras** (multiSelect): source tag per formula, e.g. `L4 s12` / units column / nomenclature (symbol) table / none.

## Round 3: problem-set solutions
1. **Scope**: "Which questions should be solved?"
   - Unsolved + partially solved (Recommended for slides)
   - Only fully unsolved
   - All problems (Recommended for practice sheets)
2. **Depth**: "Full step-by-step (Recommended): Given → Assumptions → Solution → boxed answer with units" / "Concise working" / "Final answer + short reasoning".
3. **Ordering**: "Grouped by source/lecture, tagged 'Lecture 4 · Slide 12'" / "One continuous numbered list" / "Grouped by topic".
4. **Figures**: "TikZ sketches only where needed" / "No figures" / "Use extracted source figures" (see the Figures question in round 1).

## Round 4: summary notes
1. **Length**: "~1 page per lecture/chapter" / "Detailed (textbook-like prose)" / "Bullet-point only".
2. **Include** (multiSelect): worked examples / key-idea boxes / common mistakes / links to the formula sheet.

## Final question: always ask, last
**Compile**: "Should I compile the .tex files to PDF?"
- "Just .tex (Recommended if you use Overleaf)": no install; compilation is not checked.
- "Compile with tectonic (~20 MB + ~300 MB cache)": installs tectonic if missing, compiles and fixes errors.
- "Use existing MacTeX/pdflatex": only if `pdflatex` is on PATH.
If the user asks about storage or anything else instead of choosing, answer it and ask again.
