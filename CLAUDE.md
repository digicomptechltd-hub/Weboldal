# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**Digital Compliance Technology** — EU AI Act compliance readiness landing page.  
Single-file static site: everything lives in `index.html` (HTML + embedded CSS + embedded JS). No build step, no package manager, no dependencies. Open directly in a browser.

## Architecture

### Language switching

The active language is stored on `<html data-lang="en|de|hu">`. CSS hides the inactive languages:

```css
html[data-lang="en"] .lang-de,
html[data-lang="en"] .lang-hu { display: none !important; }
```

The JS function `switchLang(lang)` updates the attribute, syncs the button active states, and persists to `localStorage` under the key `dct-lang`.

Every translatable element carries one of three classes: `lang-en`, `lang-de`, `lang-hu`. Inline spans are used for short text; block `<div>` / `<p>` elements for longer content. **Never mix languages inside a single element.**

### CSS custom properties (design tokens)

All colours, radii, and the max-width are defined as CSS variables on `:root` at the top of the `<style>` block. Change visual style there, not scattered through selectors.

| Variable | Role |
|---|---|
| `--bg` / `--bg-alt` | Page and alternate-section backgrounds |
| `--card` / `--card-hover` | Card backgrounds |
| `--accent` | Primary blue (buttons, links, left borders) |
| `--teal` | Positive / checkmark accent |
| `--danger` | Negative / cross accent |
| `--text` / `--text-muted` / `--text-dim` | Text hierarchy |

### Page sections (in order)

`header` → `.lang-banners` → `#hero` → `#boardroom` → `#what-is` → `#how-it-works` → `#precheck` → `#eu-context` → `#definitions` → `.img-strip` (Lady Justice) → `#future-proof` → `#trust` → `footer`

- `.lang-banners` — three full-width banner images directly below the header, one per language (`banner-en.jpg`, `banner-de.jpg`, `banner-hu.jpg`). The standard language-visibility CSS handles show/hide automatically via `lang-en` / `lang-de` / `lang-hu` classes on each `<img>`.
- `#hero` — two-column grid (`.hero-layout`): text on the left (`.hero-content`), EU flags photo on the right (`.hero-visual`). The image column is hidden on screens ≤820px.
- `.img-strip` — full-width editorial image divider after `#definitions`. Contains `.img-strip-photo` (darkened/desaturated), `.img-strip-overlay` (gradient fade), and `.img-strip-caption`. Currently uses `img-justice.jpg`.
- `#definitions` contains 6 `<article class="def-card">` blocks — each maps to one FAQPage `mainEntity` entry in the JSON-LD.
- `#precheck` holds three `.btn-precheck` anchors, each with `data-precheck-lang="en|de|hu"` pointing to the language-specific Airtable form URLs. `switchLang()` also toggles the `.active` class on these buttons.

### Image assets

| File | Used in | Notes |
|---|---|---|
| `banner-en.jpg` | `.lang-banners` | 4500×1500px PreCheck banner, EN |
| `banner-de.jpg` | `.lang-banners` | 4500×1500px PreCheck banner, DE |
| `banner-hu.jpg` | `.lang-banners` | 4500×1500px PreCheck banner, HU |
| `img-eu-flags.jpg` | `#hero .hero-visual` | EU flags, Brussels; darkened in CSS |
| `img-justice.jpg` | `.img-strip` after `#definitions` | Lady Justice + globe; darkened in CSS |

All image darkening/desaturation is done with CSS `filter` — do not pre-process the source files.

### Logo placeholder

Both logo locations (`<header>` and `<footer>`) are marked with the comment `<!-- LOGO PLACEHOLDER -->`. Replace the text node with an `<img>` tag when the asset is available.

## Key external URLs (do not change without checking with the owner)

| Purpose | URL |
|---|---|
| Airtable EN | `https://airtable.com/appXjjPrAfvyGqddh/shrbgGYcyiWuQ1r8x?prefill_requested_language=en` |
| Airtable DE | `https://airtable.com/appXjjPrAfvyGqddh/shr2Tf6IvbtZRazTL?prefill_requested_language=de` |
| Airtable HU | `https://airtable.com/appXjjPrAfvyGqddh/shr1rOwad4u4epAcN?prefill_requested_language=hu` |
| Legal PDF EN | `https://drive.google.com/file/d/1zkvw8PBKHjWmSpkWvIjqP7hi2ZB4IRH2/view?usp=drive_link` |
| Legal PDF DE | `https://drive.google.com/file/d/1JW2sMNj9b9WBk51YZoS-C66fjO78WBtg/view?usp=drive_link` |
| Legal PDF HU | `https://drive.google.com/file/d/1OTjkaDV0rnZhioubYdmCcSTJ4LpkJwKa/view?usp=drive_link` |
| EUR-Lex | `https://eur-lex.europa.eu/eli/reg/2024/1689/oj` |

## Content rules (non-negotiable)

- **Tone:** calm, executive, non-alarmist. No fear-based language, no hype.
- **Positioning:** this product is management decision-support — NOT legal advice, NOT certification, NOT an audit, NOT a compliance guarantee.
- Definition blocks (`<article class="def-card">`) must stay neutral and factual — they are designed to be cited by AI search engines and RAG systems.
- The footer withdrawal notice text must not be rewritten; only link to the official PDFs.

## Validation

After changes, verify with:
- [https://validator.w3.org/#validate_by_input](https://validator.w3.org/#validate_by_input) — HTML validity
- [https://validator.schema.org/](https://validator.schema.org/) — JSON-LD `Article` + `FAQPage` schemas
