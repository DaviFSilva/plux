# Plux — Branding guide

> How we build Plux's visual identity, what choices we make, and what we
> commit to before writing screens. Read this when picking a direction; update
> it when a decision changes.

## What "branding" means here

For Plux, branding is the set of decisions that make every screen feel like
the same product. Not a logo (we don't have one yet). Not a slogan. It's:

- The colors we reach for when something needs to feel primary, secondary,
  dangerous, or muted.
- The typefaces, sizes, and weights we use for headings, body, and small
  labels.
- The shape of corners, the weight of borders, the spacing between elements.
- Which components we use and which we don't.

These decisions become design tokens — named values that the code reads
instead of hex codes and pixel sizes. Tokens let us swap the whole look
without touching screens.

## The token model

We follow Material Design 3's three-layer token model. Each layer has one
job:

| Layer | What it holds | Example name | Example value |
|---|---|---|---|
| **Reference** | Raw values. The "paints". | `ref.palette.indigo50` | `#E8EAF6` |
| **System** | Semantic meaning. "What's this color for?" | `sys.color.primary` | `{ref.palette.indigo500}` |
| **Component** | Per-component decisions. "What does this button look like?" | `comp.button.primary.bg` | `{sys.color.primary}` |

Why three layers:

- Reference tokens change rarely (you pick a palette once).
- System tokens change when the brand evolves (a new primary, a new mood).
- Component tokens change when a specific component gets redesigned (the
  primary button gets bigger padding).

A screen reads component tokens. It never reads reference tokens directly.
This means a redesign of "make the primary color greener" is a one-line
change at the system layer — no screen code changes.

The Material 3 spec calls these "reference", "system", and "component". We
follow the same naming pattern (`ref.*`, `sys.*`, `comp.*`) so the spec maps
to our code without translation.

## How we author it

We use Google's [DESIGN.md](https://github.com/google-labs-code/design.md)
format. It's a single file with:

- YAML front matter: machine-readable tokens, lintable, exportable to
  Tailwind or W3C DTCG.
- Markdown body: human-readable rationale for why each decision exists.

The file lives at `docs/DESIGN.md` in the repo. It is the source of truth
for tokens. Code reads values via tooling that exports the file into our
Flutter theme.

Tools we'll use:

- `npx -y @google/design.md lint DESIGN.md` — validates structure, checks
  WCAG contrast on component color pairs, flags broken references.
- `npx -y @google/design.md export --format css-tailwind DESIGN.md > theme.css`
  — produces a Tailwind v4 `@theme` block. Useful when comparing alternatives.

## The decisions a branding pass makes

In order of impact:

### 1. Palette and color mood

Pick a primary color first. Everything else flows from it. The primary is
the color users associate with "this is the brand" — buttons, links, active
tabs.

Constraints:

- WCAG AA contrast (4.5:1) for text on backgrounds. Lint catches it but
  design with it in mind.
- Primary should work on both light and dark surfaces. M3's tonal palette
  handles this — pick a tonal palette (e.g., "indigo") and the system
  generates a primary that works in both modes.

### 2. Surface strategy

Decide upfront whether the app is light-first, dark-first, or both equally.

- Light-first: cheaper to design, prints fine, default expectation.
- Dark-first: feels modern, harder to do well, easier on eyes for long sessions.
- Both equally: more design work, more tokens, more testing. Worth it only
  if the app is used heavily at night (writing, coding, journaling).

For Plux, which is a "personal learning + life log" app used at all hours,
I'd default to **both equally**. A `sys.color.surface` token plus light/dark
overrides makes it free.

### 3. Typography

Pick two typefaces maximum. One for UI, one optional accent.

Options to consider:

- **System default** (Roboto on Android, San Francisco on iOS, Segoe UI on
  Windows). Free, fast, native feel, no font loading cost.
- **Inter** — modern, open source, designed for screens, used by Linear and
  Vercel. Good default if you don't want system fonts.
- **A serif accent** (Source Serif, Fraunces) for headings to add a
  "considered, slower" feel. Useful if Plux is more about journaling than
  quick interactions.

For now, **system default** is the right call. Add Inter only if system
fonts feel off.

### 4. Shape and density

Pick:

- **Corner radius scale**: 4 / 8 / 12 / 16 / 24. Small = serious/dense,
  large = friendly/airy.
- **Border weight**: 1px (subtle) or 2px (defined). Material 3 mostly uses
  surface tint instead of borders — worth considering.
- **Spacing scale**: 4 / 8 / 16 / 24 / 32 / 48. Multiples of 4 are standard.

### 5. Component coverage

Decide which Material 3 components we use as-is, which we customize, and
which we build from scratch. Plux's screens will likely use:

- Button (filled, outlined, text variants)
- AppBar / NavigationBar
- Card (for decks and journal entries)
- ListTile (for navigation menus)
- TextField (for card creation, journal entry)
- Dialog / BottomSheet (for confirmations, card review)
- Snackbar (for save confirmations)

We probably won't use: FAB-heavy patterns (overkill for this app),
navigation drawer (cards-on-bottom-nav covers it), date picker (we may want
a custom calendar widget).

## The process — how we pick a direction

We don't pick a branding from a blank page. We pick from candidates:

1. Generate 3-5 design direction candidates (see `design-catalog.md` for the
   list). Each candidate has a one-paragraph description and reference
   examples.
2. For each candidate that appeals, build a **template screen** (see below)
   using that candidate's tokens. Roughly 30 minutes of work per candidate.
3. View the template screens side by side. Pick one or ask for another
   round of candidates.
4. The winning candidate becomes `docs/DESIGN.md`. The losers' tokens get
   archived under `docs/design-archive/` for future reference.

The template screen shows:

- App bar with title and overflow menu
- Primary, secondary, and destructive buttons
- A card and a list tile
- An empty state and a populated state
- Light and dark mode renders

One screen, every important component, both modes. Most branding decisions
become obvious when you see the components together.

## What goes in `docs/DESIGN.md`

After we pick a direction, the file has:

- Front matter with all tokens (colors, typography, shape, spacing,
  components).
- Sections in canonical order: Overview, Colors, Typography, Layout,
  Elevation & Depth, Shapes, Components, Do's and Don'ts.
- Each section's markdown tells future-us *why* a token exists, not just
  what its value is.

## What we don't do yet

- Custom illustrations or iconography. Material Symbols cover Plux's needs
  for now.
- Animation specs beyond Material defaults. Most decisions can wait until
  we have a screen that needs a specific motion.
- A logo. Not needed for a personal app; the wordmark + favicon is enough
  for the prototype.

## Change log

| Date | Change | Reason |
|---|---|---|
| 2026-09-05 | Document created | Lock in branding process before screens are built |