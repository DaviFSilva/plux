# Plux — Template screen spec

> What the template screen must contain to give a fair comparison between
> design directions. Built once per direction; compared side by side.
> See [branding.md](./branding.md) and [design-catalog.md](./design-catalog.md).

## Purpose

The template screen is a single Flutter screen that exercises every
component and pattern the design must answer for. When you look at it,
you should be able to answer: "would I want to use this app for two hours
straight?"

If the template screen looks good in a direction, that direction probably
works for Plux. If it looks bad, no amount of fine-tuning will rescue it
— pick a different direction.

## Layout

The screen is a `Scaffold` with an `AppBar` and a scrollable body. Light
and dark mode both render. No real data — placeholder text that reads
naturally enough to feel like real content.

```
┌──────────────────────────────────────┐
│  ← Plux template             ⋮       │  ← AppBar with back, title, overflow
├──────────────────────────────────────┤
│                                      │
│  Greeting heading                    │  ← Display text (h1)
│  Subtitle line explaining purpose    │  ← Body text (body-lg)
│                                      │
│  [Deck card]                         │  ← Filled card with title, count, action
│  [Deck card]                         │
│  [Deck card]                         │
│                                      │
│  Quick add                           │  ← Section header (label-lg)
│  [New deck]  [New card]  [New note]  │  ← Filled tonal buttons in a row
│                                      │
│  Recent activity                     │  ← Section header
│  ┌────────────────────────────────┐  │
│  │ Activity row (ListTile)        │  │  ← List with leading icon, title, subtitle
│  ├────────────────────────────────┤  │
│  │ Activity row                   │  │
│  ├────────────────────────────────┤  │
│  │ Activity row                   │  │
│  └────────────────────────────────┘  │
│                                      │
│  Review now                          │  ← Primary call-to-action section
│  ┌────────────────────────────────┐  │
│  │     [ Start review ]           │  │  ← Large filled button
│  └────────────────────────────────┘  │
│                                      │
│  Empty state example                 │  ← Below the fold; shows the empty pattern
│  ┌────────────────────────────────┐  │
│  │         📚 icon                 │  │
│  │   No decks yet                  │  │
│  │   Create your first deck...     │  │  ← Centered empty state
│  │   [ Create deck ]               │  │  ← Outlined button
│  └────────────────────────────────┘  │
│                                      │
└──────────────────────────────────────┘
        ⚏ ⚏ ⚏ ⚏ ⚏ ⚏ ⚏                ← NavigationBar at bottom (5 slots)
        Home  Decks  Add  Notes  Settings
```

The screen scrolls vertically. Bottom navigation is fixed.

## What the screen exercises

For each item below, the design must give a clear answer:

### Type hierarchy

- Display text (the greeting heading) — establishes the design's largest
  text. ~32-48px depending on direction.
- Title text (deck card titles) — ~18-22px. Most-read text on screen.
- Body text (subtitle, descriptions) — ~14-16px.
- Label text (section headers, button text) — ~12-14px, often all-caps or
  with letter-spacing.
- Mono text (only if the direction uses mono) — same size as body, but
  different font.

The template screen shows all four. If two of them feel indistinguishable,
the direction's type scale is too flat.

### Color roles

The screen uses:

- **Primary** — the "Start review" button background, the section icons,
  active nav item.
- **Secondary** — "New deck" / "New card" / "New note" tonal buttons.
- **Surface** — the screen background.
- **Surface variant** — card backgrounds, list tile backgrounds.
- **On-surface** — primary text.
- **On-surface variant** — subtitles, secondary text.
- **Outline** — borders on cards, dividers, button outlines.
- **Error** — the destructive action in the overflow menu ("Delete all
  decks").

If any of these look the same as another, the direction's palette isn't
doing enough work.

### Components in use

- AppBar with back arrow, title, overflow menu (3 items, one of which is
  destructive and uses error color)
- NavigationBar (bottom, 5 slots, one active)
- Card (filled variant for decks)
- ListTile (for activity rows)
- Button variants:
  - Filled (Start review)
  - Filled tonal (New deck/card/note)
  - Outlined (Create deck in empty state)
  - Text (optional, in overflow menu items)
- IconButton (overflow menu trigger)
- SectionHeader pattern (Quick add, Recent activity, Review now, Empty
  state)
- Empty state (icon + heading + body + action)
- Spacing tokens (margins between cards, padding inside cards, gaps
  between buttons)

### States to show

The template screen shows three states:

1. **Populated** — the main view, with decks and activity.
2. **Empty** — scrolled to bottom, showing the "no decks yet" pattern.
3. **Dark mode** — toggle the theme, take a screenshot.

For directions that have additional modes (e.g., terminal has "focus"
modes; editorial has "reading" modes), add a fourth state that exercises
the unique mode.

### Density

The screen is deliberately busy — three decks, three activity rows, three
quick-add buttons, one CTA. This lets you see how the direction handles
density. Directions that feel cramped at this density (#6 data-dense) or
overwhelmed at this density (#7 soft pastel) tell you something.

## How to render

For each direction we're comparing:

1. Pick the relevant tokens (palette, typography, shape) from the catalog.
2. Build the screen with those tokens applied at the system layer.
3. Render light mode. Save screenshot.
4. Render dark mode. Save screenshot.
5. Note observations in `docs/design-catalog.md` under that direction.

The Flutter theme uses `ThemeData` with custom `ColorScheme`, `TextTheme`,
and component themes. One theme per direction. Render takes ~30 seconds
per direction once the theme is set up.

## What "looks good" looks like

The direction passes if, when you look at the rendered template:

- You can tell at a glance what is tappable and what isn't.
- The hierarchy reads: heading > cards > body > labels.
- Nothing looks accidental or "almost right".
- You'd be happy opening this app at 11pm to review a few cards.
- You'd be happy opening this app at 11pm to write a journal entry.
- Both light and dark modes work — neither feels like an afterthought.

If a direction fails on any of these, it fails overall. Don't rationalize.

## File location

The template screen lives at `web/lib/screens/template_screen.dart` (we'll
create the `lib/` structure when we add the template screen). Each
direction gets a sibling theme file: `web/lib/themes/<direction>.dart`.
Switching directions = swapping the theme import.

## Change log

| Date | Change | Reason |
|---|---|---|
| 2026-09-05 | Document created | Lock in what the template screen must show before building it |