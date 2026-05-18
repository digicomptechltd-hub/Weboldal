# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**Digital Compliance Technology** — EU AI Act compliance readiness landing page.
Single-file static site: everything lives in `index.html` (HTML + embedded CSS + embedded JS). No build step, no package manager, no dependencies. Open directly in a browser.

**Live URL:** https://digicomptechltd-hub.github.io/Weboldal/

## Git & GitHub

- **Remote:** `https://github.com/digicomptechltd-hub/Weboldal` (branch: `main`, public repo)
- **Auto-commit script:** `auto-commit.ps1` — commits only when there are changes, pushes to `origin main`, logs to `auto-commit.log`
- **Scheduled task:** `Weboldal_AutoCommit` in Windows Task Scheduler — runs `auto-commit.ps1` every hour
- Changes pushed to `main` appear on the live site within ~1 minute via GitHub Pages

### Manual push
```powershell
git add .
git commit -m "Leírás"
git push
```

## Architecture

### Language switching

The active language is stored on `<html data-lang="en|de|hu">`. CSS hides the inactive languages:

```css
html[data-lang="en"] .lang-de,
html[data-lang="en"] .lang-hu { display: none !important; }
```

`switchLang(lang)` updates the attribute, syncs button/precheck active states, and persists to `localStorage` under key `dct-lang`. Default language on first visit: `en`.

Every translatable element carries one of three classes: `lang-en`, `lang-de`, `lang-hu`. Inline `<span>` for short text; block `<div>`/`<p>` for longer content. **Never mix languages inside a single element.**

### Page sections (in order)

`header` → `.lang-banners` → `#hero` → `#boardroom` → `#what-is` → `#how-it-works` → `#evidence` → `#precheck` → `#eu-context` → `#ai-act-news` → `#definitions` → `.img-strip` → `#future-proof` → `#trust` → `#impressum` → `footer`

Key sections:
- `#precheck` — three `.btn-precheck` anchors with `data-precheck-lang="en|de|hu"` pointing to Airtable. `switchLang()` also toggles `.active` on these.
- `#definitions` — 6 `<article class="def-card">` blocks; each must stay in sync with the `FAQPage` JSON-LD in `<head>`.
- `#evidence` — lapozható slide-show (`slides/evidence-01.png` … `evidence-12.png`). `.slider-wrapper` center-ezi a `.slider-viewport`-ot egy `.slider-spacer` segítségével (layout ugrás ellen). Zoom: `transform: scale(2)` a `.zoomed` class-szal, az `overflow:hidden` megmarad a viewport-on. JS: auto-play 4.5s, touch swipe, keyboard (←/→/Escape).
- `.img-strip` — full-width editorial image divider after `#definitions`. Uses `img-justice.jpg`.

### Evidence slider — fontos részletek

- Képek: `slides/evidence-01.png` – `slides/evidence-12.png`
- A `.slider-viewport` `overflow: hidden` marad — a zoom `transform: scale(2)` alapú, nem width-változtatás
- A nyíl-gombok `e.stopPropagation()`-nal megakadályozzák a véletlenszerű zoom triggert
- `slider-spacer` (invisible, `pointer-events:none`) tartja a layout magasságát zoomed állapotban

### CSS custom properties (design tokens)

Minden szín és méret a `<style>` blokk tetején lévő `:root`-ban van. Csak ott változtass.

| Variable | Role |
|---|---|
| `--bg` / `--bg-alt` | Page and alternate-section backgrounds |
| `--card` | Card backgrounds |
| `--accent` / `--accent-2` / `--accent-hover` | Primary blue (#4f8eff), gradient end, hover |
| `--teal` / `--danger` | Positive / negative accents |
| `--text` / `--text-muted` / `--text-dim` | Text hierarchy |
| `--border` / `--border-acc` | Subtle / accent borders |
| `--max-w` | `1160px` content container |

Brand colors (hard-coded in cover badges, do not change):
- `#2e7d32` — Transparency (green)
- `#C04000` — PreCheck (copper)
- `#B00020` — HRAI (red)
- `#003366` — Navy (primary brand)

### Image assets

| File | Used in |
|---|---|
| `banner-en/de/hu.jpg` | `.lang-banners` (4500×1500px, language-specific) |
| `img-eu-flags.jpg` | `#hero .hero-visual` |
| `img-justice.jpg` | `.img-strip` after `#definitions` |
| `slides/evidence-01..12.png` | `#evidence` slider |

All darkening/desaturation via CSS `filter` — do not pre-process source files.

### Schema.org / JSON-LD

Two `<script type="application/ld+json">` blocks in `<head>`:
1. `Article` — page-level metadata
2. `FAQPage` — 6 Q&A entries mirroring the 6 `#definitions` `.def-card` blocks

**Keep in sync:** any change to a `def-card` must be reflected in the `FAQPage` mainEntity.

### Logo placeholder

Both logo locations (`<header>` and `<footer>`) are marked `<!-- LOGO PLACEHOLDER -->`. Replace the text node with an `<img>` when the asset is available.

## Key external URLs (do not change without owner approval)

| Purpose | URL |
|---|---|
| Airtable EN | `https://airtable.com/appXjjPrAfvyGqddh/shrbgGYcyiWuQ1r8x?prefill_requested_language=en` |
| Airtable DE | `https://airtable.com/appXjjPrAfvyGqddh/shr2Tf6IvbtZRazTL?prefill_requested_language=de` |
| Airtable HU | `https://airtable.com/appXjjPrAfvyGqddh/shr1rOwad4u4epAcN?prefill_requested_language=hu` |
| Legal PDF EN (v3.2) | `https://drive.google.com/file/d/1OJ9vmQGSAaqbXBKWzL3dogbD93G-SlY_/view?usp=sharing` |
| Legal PDF DE (v3.2) | `https://drive.google.com/file/d/12r67NrbDl5kw4WzMBCmOtlBehdm4zbUI/view?usp=sharing` |
| Legal PDF HU (v3.2) | `https://drive.google.com/file/d/194_8jMDGL1O7LtsRS4UcH7NRSqEbWBwl/view?usp=sharing` |
| EUR-Lex | `https://eur-lex.europa.eu/eli/reg/2024/1689/oj` |

## Content rules (non-negotiable)

- **Tone:** calm, executive, non-alarmist. No fear-based language, no hype.
- **Positioning:** management decision-support — NOT legal advice, NOT certification, NOT an audit, NOT a compliance guarantee.
- `def-card` blocks must stay neutral and factual — designed to be cited by AI search engines and RAG systems.
- Footer withdrawal notice text must not be rewritten; version must match current legal PDF version (currently **v3.2**).
- When updating legal PDF links, update: the `<a href>` for each language AND the version string in all 3 footer notice `<span>` elements.

## Validation

After changes:
- HTML: https://validator.w3.org/#validate_by_input
- Schema.org JSON-LD: https://validator.schema.org/
