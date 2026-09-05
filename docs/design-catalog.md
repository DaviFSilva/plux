# Plux — Design catalog

> The directions Plux could take. Read this to pick what feels right, then
> build a template screen for each candidate you want to compare.
> See [branding.md](./branding.md) for the process.

For each direction: a description, what it would feel like to use, what's
good for Plux, what's wrong with it, and concrete references to look at.

## How to use this doc

Don't try to choose from descriptions alone. Pick 2-4 that appeal, build
template screens for each (the process is in `branding.md`), then decide
from the renders.

Skim the references before building — the look only makes sense once you've
seen it move and respond.

---

## 1. Material 3 default

**Vibe**: Familiar, polished, friendly. The Android default since 2021.

**What it would feel like**: Predictable. Buttons look like buttons.
Cards have rounded corners and elevation. Light and dark modes both work.
Most users have seen this UI on their phone, so the learning curve is zero.

**Good for Plux**: Removes decision fatigue — we can ship a real-looking
app on day one without inventing a visual language. Material's design
tokens map directly to our `docs/DESIGN.md` format.

**Wrong for Plux**: Generic. If the goal is "feels like mine", Material
default feels like Google's. Easy to confuse, feel like Notion or Drive.

**References**:
- [m3.material.io](https://m3.material.io/) — official spec
- Material Theme Builder Figma plugin
- Flutter Material 3 widget catalog
- Any modern Android app (Gmail, Drive, Photos)

**Token starter**: `ColorScheme.fromSeed(seedColor: Colors.indigo)` in
Flutter gives you a working Material 3 theme in one line.

---

## 2. Premium minimal (Linear / Vercel / Stripe school)

**Vibe**: Restrained, considered, professional. Lots of dark gray, a
single bright accent, no decoration.

**What it would feel like**: Quiet. The UI steps back; the content
steps forward. Every element earns its place. Buttons look like text until
you hover. Borders are subtle.

**Good for Plux**: Personal-app feel — Plux is for *you*, not a marketing
page. The "less chrome, more content" approach matches a knowledge tool.
Reads as "I made this for myself, not for users."

**Wrong for Plux**: Easy to overdo into sterility. Also harder to make
distinctive — many products look like this now (Linear, Vercel, Stripe,
Raycast, Things 3, Cron, Height, Notion's darker modes).

**References**:
- linear.app — dark UI, subtle purple accent, monospace accents
- vercel.com — black/white minimal, blueprint grid for layouts
- stripe.com — typography-first, color as exception
- raycast.com — dense but calm

**Token starter**: Dark surface `#0A0A0A`, border `#1F1F1F`, text `#E5E5E5`,
single accent in deep violet or warm gold.

---

## 3. Warm journal (Things / Bear / Day One school)

**Vibe**: Calm, paper-like, slow. Soft contrast, warm grays, generous
whitespace, serif accents.

**What it would feel like**: Like writing in a notebook. Less like an app,
more like a tool you sit down to use. Encourages you to think before
tapping.

**Good for Plux**: Plux has a "life log" component. Journal-flavored UI is
right for that section specifically. Could split the app visually —
flashcard review uses one look, journal uses another.

**Wrong for Plux**: Slow UI feels wrong for review flows (spaced
repetition wants quick tap, quick tap, quick tap). Don't apply uniformly.

**References**:
- bear.app — soft warm grays, tags as colored dots
- dayoneapp.com — journal-first, light theme, generous spacing
- things.com — clear hierarchy, no decorative elements

**Token starter**: Background `#FAF8F5` (warm off-white), text `#2D2A26`,
accent `#B85C38` (terracotta), serif headings.

---

## 4. Brutalist / neobrutalist

**Vibe**: Raw, intentional, anti-slick. Heavy borders, sharp corners,
high contrast, visible structure.

**What it would feel like**: Like a paper form or a terminal. Hard edges.
You know exactly what is button and what isn't. Nothing is hidden behind
gradients or shadows.

**Good for Plux**: Distinctive. If you want Plux to feel like a personal
tool with character rather than another SaaS, this delivers that. Works
well for keyboard-heavy flows.

**Wrong for Plux**: Reading-heavy screens (journal entries, knowledge
notes) feel hostile in brutalist chrome. Reviewing flashcards should be
fast and calm, not loud. Hard to do dark mode well.

**References**:
- brutalistwebsites.com — the canonical gallery
- gumroad.com — soft neobrutalist (rounded corners, but thick borders)
- craigmod.com — text-first brutalist essay layouts
- substack.com — minimal brutalist reading UI

**Token starter**: Background `#FFFFFF`, text `#000000`, accent `#FFEB3B`
or `#FF5722`, border 2-3px solid black, no border-radius.

---

## 5. Editorial / magazine

**Vibe**: Type-driven, content-first, lots of hierarchy. Big headlines,
small body, drop caps, generous margins.

**What it would feel like**: Reading a serious publication. Less like
tapping through cards, more like reading a curated set of ideas.

**Good for Plux**: Plux's "knowledge base" feature wants this flavor.
Notes and journal entries should feel like reading, not like form-filling.

**Wrong for Plux**: Slow for input flows. Adding a card or quick journal
entry in editorial chrome feels wrong. Doesn't scale to small screens.

**References**:
- medium.com — clean reading layout
- pocket.com — article-first UI
- arealme.com — magazine-style hierarchy (use as anti-example: too busy)
- thebrowser.company — text-first newsletter reader

**Token starter**: Two typefaces (serif body, sans labels), large
type scale (h1 at 48-72px), narrow content column (~640px), warm
neutral background.

---

## 6. Data-dense / power-user

**Vibe**: Dense, technical, all visible. Tables, monospace, tiny
spacing, multiple panels.

**What it would feel like**: A terminal or a spreadsheet. Power-user
overwhelms casual user. Optimized for speed once you learn it.

**Good for Plux**: SRS review benefits from density — seeing 10 cards in
a list beats scrolling. Spaced-repetition users often want this.

**Wrong for Plux**: Journal/knowledge sections feel oppressive. Casual
sessions (one card, one note) feel like overkill.

**References**:
- toggl.com — time tracking density
- Things' keyboard shortcuts page (for the layout grammar)
- logseq.com — outliner-density
- obsidian.md — knowledge graph density

**Token starter**: Background `#FFFFFF` or `#1A1A1A`, monospace for
data, sans for chrome, 8px spacing scale, dense tables.

---

## 7. Soft pastel / lo-fi

**Vibe**: Friendly, low-pressure, slightly childish. Pastel pinks, mint
greens, soft lavender, hand-drawn icons.

**What it would feel like**: Like a personal diary or a Notion template
from an influencer. Welcoming but not serious.

**Good for Plux**: Plux is personal — making it feel approachable has
value. Low stakes UI helps when you're journaling.

**Wrong for Plux**: Hard to read long-form text on pastels. Not great
for a tool you use daily for serious work (reviewing flashcards is
study, not play). Trends hard — looks dated in 2 years.

**References**:
- arc.net — soft pastels, gradient accents
- are.na — minimal, slightly playful
- crumblcookies.com (caution: too far in this direction)
- apple's iCloud web UI

**Token starter**: Background `#FFF8F0`, text `#3A3A3A`, accents `#FFB5A7`
and `#A8DADC`, rounded 16-24px corners everywhere.

---

## 8. Terminal / mono-everything

**Vibe**: Hacker aesthetic. Monospace everywhere, ASCII borders,
green-on-black or amber-on-black, no images.

**What it would feel like**: Like `vim` or `htop`. The UI is text and
keys. Nothing pretends to be a real-world object.

**Good for Plux**: Distinctive. If you live in a terminal already,
extending that vibe to your knowledge app is consistent.

**Wrong for Plux**: Hard to render tables and long-form content in
mono. Photos/images don't fit. Most users find it alienating.

**References**:
- terminaltrove.com — gallery of TUIs
- lazygit, btop, htop — terminal UI standards
- vercel.com/docs (some sections are mono-flavored)

**Token starter**: Background `#000000`, text `#00FF00`, monospace
everywhere, ASCII borders.

---

## How I would narrow these for Plux

Three questions to start with:

1. **What's the dominant mode?** Reviewing flashcards (quick, dense) vs.
   writing journal entries (slow, generous). The dominant mode shapes the
   whole app.
2. **Day or night?** Most of your time in Plux will be at a desk during
   work hours? Or late evening journaling? This shapes whether dark mode
   is "primary" or "alternate".
3. **Personal or shareable?** If this is truly just for you, lean toward
   distinctive (#2, #4, #8). If you'll show it to anyone, lean toward
   familiar (#1, #5).

My guess for Plux (one paragraph):

> Plux has two distinct modes — quick review and slow writing. The most
> honest design treats them differently. Premium minimal (#2) for the home
> and review screens (calm, dense, fast). Editorial (#5) for the journal
> and knowledge screens (read-friendly, generous). Both share tokens at
> the reference and system layers, differ at the component layer. That's
> worth prototyping before committing.

But you might have a different instinct. Pick what calls to you and we'll
build template screens.

---

## Change log

| Date | Change | Reason |
|---|---|---|
| 2026-09-05 | Document created | Catalog of directions for branding decisions |