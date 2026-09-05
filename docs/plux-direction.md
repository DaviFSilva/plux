# Plux — Liquid design + stress-test screen

> The visual direction we're committing to, why it works in Flutter web,
> and what the expanded template screen must contain to validate it.
> See [branding.md](./branding.md) for the broader branding process;
> [design-catalog.md](./design-catalog.md) for the alternatives we
> considered.

## What we picked

**Core idea**: Plux is fluid and clean. Quiet when idle, alive on
interaction. Like still water that ripples when you touch it.

**Concrete tokens**:
- **Primary**: deep violet — something in the `#6D28D9` to `#7C3AED`
  range. Tonal palette generated from a violet seed so we get a full
  system of primary / secondary / surface variants without hand-picking.
- **Typeface**: **Ubuntu**, weights 400 / 500 / 700. Loaded from Google
  Fonts at app start (one extra `<link>` in `web/index.html`). Free,
  humanist sans, good readability at small sizes, fits the "considered
  but approachable" feel.
- **Motion language**: spring-based, damped by default. Heavy elements
  settle with overshoot (think a drop landing). Interactive elements
  use a softer spring — feels responsive, not bouncy. Page transitions
  use ease-out.
- **Surface treatment**: subtle gradients (`onSurface` slightly tinted
  toward violet), no hard elevation shadows. Cards sit *on* the surface,
  not *above* it.

## What "liquid" means in implementation

Three layered techniques. They don't all need to be on screen at once —
the right amount per surface depends on the component.

### 1. The metaball filter (the strongest effect)

The signature. Use it sparingly: on the nav indicator, on the active
filter chip, on hover backgrounds, on the primary CTA when pressed.

SVG filter:

```html
<svg width="0" height="0" style="position:absolute">
  <filter id="goo">
    <feGaussianBlur in="SourceGraphic" stdDeviation="8" />
    <feColorMatrix
      in="blur"
      mode="matrix"
      values="1 0 0 0 0
              0 1 0 0 0
              0 0 1 0 0
              0 0 0 22 -10" />
    <feBlend in="SourceGraphic" in2="goo" />
  </filter>
</svg>
```

Apply with `filter: url(#goo)` on a parent that contains the elements
that should merge. In Flutter web we can inject this `<svg>` once in
`web/index.html` and reference it via CSS in `index.html` plus Flutter's
`HtmlElementView` for the meta elements that need to be inside it.

**Cost**: works in every modern browser, GPU-cheap, no JS. Works at
60fps for a small number of elements.

**Gotcha**: the filter must wrap a `position: absolute` parent, and the
elements being merged must overlap or be close enough that the blurred
alpha fields touch. If they don't overlap, nothing merges — they're
independent shapes.

### 2. Animated border-radius (the everyday feel)

This is the "header item bends itself" effect. CSS:

```css
.nav-item {
  border-radius: 12px;
  transition: border-radius 240ms cubic-bezier(0.2, 0.8, 0.2, 1);
}
.nav-item:hover {
  border-radius: 24px 24px 8px 24px;
}
```

In Flutter: `AnimatedContainer` with `BorderRadius` morphing, or a
custom `Tween<BorderRadius>` driven by an `AnimationController`. Default
curve is `Curves.easeOutCubic`, duration ~280ms. The non-uniform radius
on hover (different values per corner) reads as "this corner is being
pulled toward the cursor" — the liquid feel.

**Use this everywhere by default**: cards, buttons, list tiles, chips,
nav items. The transition is what makes the UI feel alive without
being noisy.

### 3. Spring physics (motion)

Flutter's `SpringSimulation` + `Curves.elasticOut` / `Curves.easeOutCubic`
give the right physics. For most UI motion:

- **Default** (page mount, value updates): `Curves.easeOutCubic`,
  duration 240ms.
- **Settle** (drop arriving, modal snapping into place): spring with
  mass 1, stiffness 180, damping 18. Slight overshoot, ~300ms.
- **Drag tracking** (slider, sheet handle): `Curves.linear` while
  dragging, spring on release.

Avoid `Curves.elasticOut` for general UI motion — it bounces too much
and gets old. Reserve for playful moments (success confirmation, small
celebratory animations).

### Where each technique applies

| Surface | Primary technique | Secondary |
|---|---|---|
| Navigation bar / tabs | Metaball filter on indicator | Animated border-radius |
| Buttons | Animated border-radius on press | Subtle gradient |
| Cards | Animated border-radius on hover | Spring on mount |
| Modals / sheets | Spring on show/hide | Animated border-radius |
| Loading states | Animated border-radius that "breathes" | — |
| Lists | No animation, instant render | — |
| Charts | Spring on data update | — |

## Expanded template-screen spec

The current template screen tests ~5% of what a design system needs.
The stress-test version needs to exercise:

### Required component coverage

**Surfaces & containers**
- Card variants (filled, outlined, tonal)
- Bottom sheet (with drag handle)
- Dialog (alert + custom)
- Expansion panel / collapse
- Tabs (top tabs, segmented control)
- Navigation rail (for tablet/desktop wide layouts)
- App bar (with multiple action buttons + overflow)
- NavigationBar with multiple destinations

**Inputs**
- TextField (filled + outlined, with helper/error states)
- Dropdown / select
- Slider (continuous + discrete)
- Switch + checkbox + radio
- Segmented control / chip group
- Date / time picker (simplified)

**Data display**
- List (single-line, two-line, three-line)
- List with section headers + dividers
- Grid (image grid + dashboard tiles)
- Stat card (number + delta + sparkline)
- Data table (sortable header)
- Bar chart, line chart, pie chart (via `fl_chart`)
- Progress (linear + circular)
- Avatar (initial, image, presence dot)
- Badge + chip
- Tooltip on hover

**Feedback**
- Snackbar (success + error variants)
- Loading states (skeleton placeholder + spinner + progress)
- Empty state (icon + message + CTA)
- Error state (with retry)

**Interactive states to show**
- Default
- Hover (for web/desktop)
- Pressed
- Disabled
- Focused (keyboard nav)
- Selected / active

### Layout it forces

A real stress-test screen has:

1. **A top app bar** with title, leading, 3 action icons, overflow menu
2. **A primary navigation rail** on the left (desktop) or collapsed to
   bottom nav (mobile)
3. **A hero section** with stat cards (3-4 metrics with sparklines)
4. **A "primary feature" section** showing the metaball nav indicator
   in action — the strongest visual moment
5. **A form section** with text fields, dropdowns, slider, segmented
   control
6. **A data section** with a chart (line + bar) and a data table
7. **A list section** with mixed content types (avatar rows, badge
   rows, progress rows)
8. **A grid section** with image tiles (placeholder colors, no real
   images)
9. **A modal section** that opens a bottom sheet on tap, a dialog on tap
10. **A feedback section** showing snackbar variants, loading skeletons,
    empty states

Scroll position: long. Forces the user to scroll-test the design.

### What "looks good" looks like

The Plux design passes when, viewing the rendered stress-test screen:

- You can hover over the nav indicator and watch it morph smoothly into
  a circle that merges with adjacent active items.
- The page loads with cards settling in with a soft overshoot — feels
  alive, not jarring.
- Pressing the primary button makes its border-radius briefly morph to
  a non-uniform shape (subtle "pulled toward the click").
- The charts and tables look at home — not crammed, not lost in space.
- Light and dark modes both work; the violet primary reads well in both.
- Ubuntu is loaded and visible in every text element.

If any of these fail, the direction needs tuning. If they all pass,
it's the right direction for Plux.

## What this doc doesn't do

- **Doesn't** specify every padding value, every transition timing.
  Those get filled in when the design is committed (see `docs/DESIGN.md`
  template when we get there).
- **Doesn't** pick a chart library commit — `fl_chart` is the right pick
  today but should be reviewed when we add real data viz.
- **Doesn't** lock in motion easings — those iterate with implementation.

## Open questions

- **Where do we use the metaball filter?** On the nav indicator only, or
  also on filter chips and the active state of cards? More uses = more
  visual identity, but also more risk of feeling gimmicky.
- **Loading animations**: skeleton placeholders or the breathing
  border-radius? Both? Pick before we ship the stress-test screen.
- **Dark mode**: equal weight, or dark-first? Plux is a personal app used
  at all hours — argument for dark-first.

## References

- CSS-Tricks, "The Gooey Effect" — the canonical metaball writeup
- Codrops, "Creative Gooey Effects" — visual demos and SVGs
- animationpatterns.art, "Gooey Blob Metaball Filter" — modern
  implementation with `prefers-reduced-motion` support
- Kevin Van, "Creating Morphable Shapes in Flutter" — morphing
  border-radius and shapes in Flutter specifically
- Flutter `SpringSimulation` docs — built-in physics
- `fl_chart` pub.dev — chart library for the stress-test screen

## Change log

| Date | Change | Reason |
|---|---|---|
| 2026-09-05 | Document created | Lock the visual direction + stress-test screen spec before code |