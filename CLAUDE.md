# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**Digital Compliance Technology** — EU AI Act compliance readiness landing page.
Single-file static site: everything lives in `index.html` (HTML + embedded CSS + embedded JS). No build step, no package manager, no dependencies. Open directly in a browser.

## Git & GitHub

- **Remote:** `https://github.com/digicomptechltd-hub/Weboldal` (branch: `main`)
- **Commit convention:** free-form; the auto-commit script uses `"Auto-mentés: YYYY-MM-DD HH:mm:ss"`
- **Auto-commit script:** `auto-commit.ps1` — commits only when there are changes, pushes to `origin main`, logs to `auto-commit.log`
- **Scheduled task:** `Weboldal_AutoCommit` in Windows Task Scheduler — runs `auto-commit.ps1` every hour

### Manual push
```powershell
# Run from project root
git add .
git commit -m "Leírás"
git push
```

### Check auto-commit log
```powershell
Get-Content auto-commit.log -Tail 20
```

## Architecture

### Language switching

The active language is stored on `<html data-lang="en|de|hu">`. CSS hides the inactive languages:

```css
html[data-lang="en"] .lang-de,
html[data-lang="en"] .lang-hu { display: none !important; }
```

The JS function `switchLang(lang)` updates the attribute, syncs button/precheck active states, and persists to `localStorage` under the key `dct-lang`.

Every translatable element carries one of three classes: `lang-en`, `lang-de`, `lang-hu`. Inline spans for short text; block `<div>` / `<p>` for longer content. **Never mix languages inside a single element.**

### CSS custom properties (design tokens)

All colours, radii, and max-width are defined as CSS variables on `:root` at the top of `<style>`. Change visual style there only.

| Variable | Role |
|---|---|
| `--bg` / `--bg-alt` | Page and alternate-section backgrounds |
| `--card` / `--card-hover` | Card backgrounds |
| `--accent` | Primary blue (buttons, links, left borders) |
| `--teal` | Positive / checkmark accent |
| `--danger` | Negative / cross accent |
| `--text` / `--text-muted` / `--text-dim` | Text hierarchy |

### Page sections (in order)

`header` → `.lang-banners` → `#hero` → `#boardroom` → `#what-is` → `#how-it-works` → `#precheck` → `#eu-context` → `#ai-act-news` → `#definitions` → `.img-strip` (Lady Justice) → `#future-proof` → `#trust` → `footer`

- `.lang-banners` — three full-width banner images below the header, one per language (`banner-en.jpg`, `banner-de.jpg`, `banner-hu.jpg`). Standard language-visibility CSS handles show/hide.
- `#hero` — two-column grid (`.hero-layout`): text left (`.hero-content`), EU flags photo right (`.hero-visual`). Image column hidden on screens ≤820px.
- `#ai-act-news` — static news card (`.news-card`) linking to `artificialintelligenceact.eu`. Entire card is a single `<a>` tag. Cover image loaded from the external site; `onerror` fallback applies a dark gradient if the image fails. Content is static — not dynamically fetched.
- `.img-strip` — full-width editorial image divider after `#definitions`. Contains `.img-strip-photo` (darkened/desaturated via CSS `filter`), `.img-strip-overlay` (gradient fade), `.img-strip-caption`. Currently uses `img-justice.jpg`.
- `#definitions` — 6 `<article class="def-card">` blocks, each maps to one `FAQPage` `mainEntity` entry in the JSON-LD.
- `#precheck` — three `.btn-precheck` anchors with `data-precheck-lang="en|de|hu"` pointing to language-specific Airtable URLs. `switchLang()` also toggles `.active` on these.

### Image assets

| File | Used in | Notes |
|---|---|---|
| `banner-en.jpg` | `.lang-banners` | 4500×1500px PreCheck banner, EN |
| `banner-de.jpg` | `.lang-banners` | 4500×1500px PreCheck banner, DE |
| `banner-hu.jpg` | `.lang-banners` | 4500×1500px PreCheck banner, HU |
| `img-eu-flags.jpg` | `#hero .hero-visual` | EU flags, Brussels; darkened via CSS |
| `img-justice.jpg` | `.img-strip` after `#definitions` | Lady Justice + globe; darkened via CSS |

All darkening/desaturation is done with CSS `filter` — do not pre-process the source files.

### Logo placeholder

Both logo locations (`<header>` and `<footer>`) are marked `<!-- LOGO PLACEHOLDER -->`. Replace the text node with an `<img>` tag when the asset is available.

## Key external URLs (do not change without owner approval)

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
- **Positioning:** management decision-support — NOT legal advice, NOT certification, NOT an audit, NOT a compliance guarantee.
- Definition blocks (`<article class="def-card">`) must stay neutral and factual — designed to be cited by AI search engines and RAG systems.
- Footer withdrawal notice text must not be rewritten; only link to the official PDFs.

## Schema.org / JSON-LD

Two `<script type="application/ld+json">` blocks in `<head>`:
1. `Article` — page-level metadata (headline, about topics)
2. `FAQPage` — 6 Q&A entries that mirror the 6 `<article class="def-card">` blocks in `#definitions`

Keep these two in sync: any change to a `def-card` question/answer must also be reflected in the `FAQPage` mainEntity.

## Typography

The page uses **Inter** (Google Fonts, weights 300–800). Font is loaded via `<link>` in `<head>` with `preconnect` hints. Fallback chain: `system-ui, -apple-system, sans-serif`.

## Additional design tokens (not in the table above)

| Variable | Value | Role |
|---|---|---|
| `--accent-2` | `#818cf8` | Gradient endpoint on primary buttons |
| `--accent-hover` | `#3a74f0` | Hover state of accent |
| `--teal-dim` | `rgba(16,185,129,.12)` | Teal background tints |
| `--danger-dim` | `rgba(248,113,113,.10)` | Danger background tints |
| `--border` | `rgba(255,255,255,.09)` | Subtle borders |
| `--border-acc` | `rgba(79,142,255,.32)` | Accent-coloured borders |
| `--font` | `'Inter', system-ui, …` | Font stack |
| `--max-w` | `1160px` | Content container max-width |

## Validation

After changes:
- HTML: https://validator.w3.org/#validate_by_input
- Schema.org JSON-LD: https://validator.schema.org/
