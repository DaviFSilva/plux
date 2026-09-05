# Plux — Widget inventory

> The widgets we have in code today, organized by layer. Read this
> before adding a new widget — it might already exist, or there might
> be a private one worth extracting.

## Public reusable widgets

These live in `lib/widgets/` and are imported by screens. They are
direction-aware: they read colors from `Theme.of(context).colorScheme`
and never hardcode a palette.

### `LiquidCard` (`lib/widgets/liquid.dart`)

A surface card that morphs its `BorderRadius` on hover. Used as the
base container for almost every block in the stress-test screen.

```dart
LiquidCard(
  child: Column(...),
  onTap: () => doSomething(),
  padding: EdgeInsets.all(20), // default
)
```

**Behavior**:
- Default: symmetric `BorderRadius.circular(20)`
- Hover: asymmetric (large top corners, small bottom-left) via
  `BorderRadius.lerp` over 280ms `Curves.easeOutCubic`
- Hover also raises the border opacity from `outlineVariant` to
  `outline @ 60%`
- `onTap` wires a Material `InkWell` inside the morphed shape
- Does not animate on press (cards are "calm" — only hover morphs)

**When to use**: any grouped content — stat blocks, list rows, form
sections, modal contents.

**When NOT to use**: rows in a `ListView` (too much overhead, list
tiles already provide their own hover states); buttons (use
`LiquidButton`).

### `LiquidButton` (`lib/widgets/liquid.dart`)

A button with the morphing radius on hover and press. Used as the
default button everywhere; Material `FilledButton`/`OutlinedButton`
are still available for cases that need platform defaults.

```dart
LiquidButton(
  label: 'Save',
  primary: true,
  icon: Icons.save_outlined,
  onPressed: () => save(),
)
```

**Behavior**:
- Default: symmetric `BorderRadius.circular(20)`,
  `surfaceContainerHighest` fill (or `primary` if `primary: true`)
- Hover: asymmetric radius lerp to 40%
- Press: asymmetric radius lerp to 100%, plus a violet glow halo in
  dark mode (`scheme.primary @ 40% blur 20`)
- 320ms `Curves.easeOutCubic` (slightly slower than the card because
  buttons need to feel "responsive")

**Variants**:
- `primary: false` (default) — tonal, used for secondary actions
- `primary: true` — filled with primary color, used for the main
  action in a screen

**When to use**: anywhere you'd reach for `FilledButton` or
`OutlinedButton`. Prefer it.

**When NOT to use**: when the button needs to match a specific Material
spec for accessibility tooling — keep `FilledButton` for that.

## Screen-level widgets (private to their screen)

These have an underscore prefix and aren't meant for reuse yet. They
exist as concrete extractions during stress-test screen construction;
extract them to `lib/widgets/` if a second screen needs them.

### `_DeckCard` (`lib/screens/template_screen.dart`)

A list row showing a deck: avatar + title + subtitle + card count.
Built inline in the template screen. Would become `DeckTile` if
extracted.

### `_ActivityRow` (`lib/screens/template_screen.dart`)

A list row for an activity entry: leading icon + title + timestamp.
Built inline. Would become `ActivityRow` if extracted.

### `_FilterChip` (`lib/screens/stress_test/stress_test_screen.dart`)

The metaball-style filter chip used in the stress-test "METABALL NAV"
section. State-free (caller tracks which is active via
`StressTestScreen._activeFilter`). Visually distinct: hover enlarges,
click flips the active state with a 320ms radius morph.

**Note**: this is the closest we get to a real metaball effect in
Flutter web — the SVG goo filter is embedded in `web/index.html`
but currently only used for the document fallback styling. To wire
it to native widgets we'd need `HtmlElementView` plumbing or a
native metaball shader; both are deferred.

## Top-level widgets

These are the screens themselves plus the app root. Not reusable but
worth knowing the boundary.

### `PluxApp` (`lib/main.dart`)

The root `StatefulWidget`. Owns `ThemeMode`, builds the
`MaterialApp`, routes `?theme=<name>` to the right theme + screen via
`PluxApp.resolveThemes()` and `_buildHome()`.

### `TemplateScreen` (`lib/screens/template_screen.dart`)

The simpler comparison screen. Used for every theme except the
committed Plux direction. Has greeting, decks list, quick-add row,
activity feed, review CTA, empty state. ~10 sections, single scroll.

### `StressTestScreen` (`lib/screens/stress_test/stress_test_screen.dart`)

The comprehensive screen. Used only for `?theme=plux` (and the URL
switches you to it automatically). 10 sections, exercises every
component the design must answer for, owns the metaball chip row,
stat cards grid, charts, table, list, grid, modals, feedback.

## Theme layer (`lib/themes/`)

Not widgets, but they drive every widget's appearance. The token
model is the same across all themes — only the values change.

| File | Direction |
|---|---|
| `_builder.dart` | Shared `Tokens` data class + `buildTheme()` factory. Single source of truth for theme construction. |
| `material3.dart` | Indigo M3 baseline |
| `plux.dart` | **Committed direction**. Violet, Ubuntu, larger radii, softer weights |
| `premium_minimal.dart` | Linear/Vercel dark minimal |
| `warm_journal.dart` | Things/Bear warm off-white |
| `brutalist.dart` | Sharp black-on-white, thick borders |
| `editorial.dart` | Magazine-style, large display type |
| `data_dense.dart` | Tight spacing, dense tables |
| `soft_pastel.dart` | Pastel pinks, large radii |
| `terminal.dart` | Monospace, ASCII borders |

## What's missing

A short list of widgets we use in the stress-test screen that are
currently inlined rather than extracted. Worth extracting the moment a
second screen needs them — not before.

- **`StatCard`** — used 4× in the hero. Number + delta + label. Likely
  needed on every analytics screen.
- **`MetricGrid`** — wraps `GridView.count` with the right tile size.
- **`SectionHeader`** — the small uppercase label above each section.
  Currently a 4-line `Text` with letter-spacing inline.
- **`Snackbar`** — `ScaffoldMessenger` is already in the framework; the
  wrap in `StressTestScreen._showSnackbar` could move to a helper.
- **`MetaballChip`** — supersede `_FilterChip` once we figure out the
  SVG filter wiring (or the native metaball path).
- **`FormRow`** — the TextField + Dropdown + Slider + Segmented stack.
  Not really a widget yet, but a useful grouping primitive.

## Convention: when to extract

- Two or more screens need it → extract to `lib/widgets/`.
- One screen uses it 3+ times → extract within the same screen but
  move to `lib/widgets/` when a second screen needs it.
- One screen, one or two uses → keep inline.

## Change log

| Date | Change | Reason |
|---|---|---|
| 2026-09-05 | Document created | Inventory the widget layer before adding more |