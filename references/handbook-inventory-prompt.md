# Subagent prompt: inventory one deck (Step 2)

Spawn one Explore/general-purpose agent per deck, or one per group of ~30 pages, in parallel. Read-only, writes only to the scratch dir.

Task text to send (fill the braces):

> Read-only task. Do not modify {FOLDER}. Write only into {SCRATCH}/inv/{DECKKEY}/.
> Deck: {PDF PATH} ({N} pages). Many slides are equation images, so text extraction is incomplete. Render with `pdftoppm -r 60 -png` and VIEW the pages with the Read tool in batches (the rendered slides are the source of truth for equations).
> For EVERY slide, record: slide number; title; topic tag (one of: {TOPIC LIST}); each key result as LaTeX (equation, name, parent equation from earlier in the deck, assumptions, and a one-line "how the previous result led here"); whether it is an Example/Solution; any slide typo or inconsistency.
> Skip worked-example NUMERICS in the output; keep result formulas only.
> Mark anything NOT on the slides with [not in slides].
> Write a structured markdown file {SCRATCH}/inv/{DECKKEY}.md, slide order, one section per topic. Reply with a 3-line summary: pages covered, number of key results, anything ambiguous. Do not paste the full inventory in the reply.

Notes for the orchestrator:
- Give each agent a page range only when a deck is longer than ~40 pages; otherwise one agent per deck.
- Image-only decks (no text layer; check `pdftotext` returns almost nothing) need the visual read. Say so in the prompt.
- Ask for the slide-error list explicitly. Those errors go into the handbook's "corrected silently and listed" note.
