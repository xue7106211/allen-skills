---
name: design-clone
description: >-
  High-fidelity webpage clone pipeline merging Design DNA extraction (tokens,
  style, visual effects) with evidence-based surface recon (WebGL, Canvas, video,
  DOM composite). Use when the user wants to clone, reproduce, replay, or
  locally rebuild a website or landing page from a URL, screenshot, or reference
  design. Triggers on "clone this site", "design clone", "copy this webpage",
  "local replay", "复刻网站", "克隆页面", "design DNA", "extract design style".
---

# Design Clone

Unified pipeline that merges **Design DNA** (what the page looks and feels like) with **Surface Recon** (how the visuals are actually rendered). Produces evidence-labeled local clones, not guesswork HTML.

## When to Use

- Clone a full webpage or landing page from a URL
- Reproduce a reference design with high visual fidelity
- Extract design tokens + implement hero/visual effects correctly
- Build a self-contained local replay (`index.html` + artifacts)

## Core Principle

```text
Design DNA answers:  "What should it look like?"
Surface Recon answers: "How is it actually built?"
Generation merges both with SOURCE > PARTIAL > GUESS priority.
```

## Output Artifacts

Store in the user's target directory (project root or specified output path):

```text
├── index.html
├── design-dna.json
├── README.md
├── .web-shader-extractor/
│   ├── scout-card.json
│   ├── replay-manifest.json
│   └── known-gaps.md
└── assets/                    # optional, when CDN hotlink fails
```

Use bundled templates as schemas — not free-form notes:

- `templates/design-dna.json`
- `templates/scout-card.json`
- `templates/replay-manifest.json`
- `templates/known-gaps.md`
- `templates/qa-report.md`

---

## Pipeline Overview

```text
INTAKE
  → PARALLEL TRACK A: DESIGN DNA EXTRACTION
  → PARALLEL TRACK B: SURFACE RECON
  → MERGE & RESOLVE
  → GENERATE
  → VERIFY & PACKAGE
```

Run Track A and Track B in parallel when possible. Merge before generation.

---

## Phase 1: Intake

1. Record canonical URL, route, viewport (1440×900, dpr 1), permission boundary.
2. Confirm scope: homepage only, single section, or full site.
3. Create output directory. Do not overwrite an existing verified baseline silently.
4. Snapshot capability profile: navigate, runtime-eval, screenshot, network, source-map, frame-capture.

Ask only for login/CAPTCHA/private pages or scope changes.

---

## Phase 2A: Design DNA Extraction

Read [references/schema.md](references/schema.md) for the full field list.

### Extract across three dimensions

| Dimension | Extract |
|-----------|---------|
| **design_system** | Colors, typography, spacing, layout, shape, elevation, motion |
| **design_style** | Mood, personality, genre, composition, whitespace, brand voice |
| **visual_effects** | Canvas/WebGL, video, grain, scroll, SVG — enable/disable per category |

### Analysis rules

- **Colors**: Primary by area dominance, accent by CTA usage, neutral scale from bg → text.
- **Typography**: Font families from computed styles or `@font-face`. Exact sizes and letter-spacing.
- **Layout**: Grid columns, max-width, asymmetric patterns.
- **Visual effects**: Scan for `<canvas>`, WebGL, `<video>`, sticky scroll, grain overlays.
- Populate every schema field. No empty strings — use `"N/A"` or `enabled: false`.
- When multiple patterns conflict, note dominant + variants.

Write `design-dna.json` using `templates/design-dna.json`.

---

## Phase 2B: Surface Recon

Read before acting:

- [references/operating-contract.md](references/operating-contract.md)
- [references/recon-kernel.md](references/recon-kernel.md)

Load focused references only as needed (see Reference Router below).

### Recon state flow

```text
CAPABILITY_SNAPSHOT → QUICK_SCOUT → SURFACE_ATTRIBUTION
→ TARGET_LOCK_GATE → TRACE_ROUTE_SELECT → SOURCE_TRACE
→ CAPTURE_MINIMUM_TRUTH → REPLAY_READY_GATE → RAW_REPLAY
→ BASELINE_VERIFY → PROJECTIZE
```

For full-page clones, `PROJECTIZE` produces the final `index.html`. Baseline verification gates still apply to the hero/visual surface group.

### Core recon rules

- **Target-bound before framework-bound**: Three.js on page ≠ target uses Three.js.
- **Evidence before implementation**: DOM, network, runtime, source maps > visual fitting.
- **Label facts**: `SOURCE`, `PARTIAL`, `GUESS` — unlabeled = `GUESS`.
- **No compensation tuning**: Do not adjust brightness/time/color to mask missing evidence.
- **Canvas-first, not canvas-only**: Also track video, DOM layers, sticky/clip/grain composites.

### Initial scout protocol

1. Screenshot viewport + full page.
2. Enumerate canvases, videos, iframes, OffscreenCanvas, WebGPU clues.
3. Sample frames; estimate coverage, z-order, temporal activity.
4. Run ablation tests on top candidates (hide, opacity freeze).
5. Probe scroll/pointer/resize coupling.
6. Write `.web-shader-extractor/scout-card.json`.
7. When locked, write `replay-manifest.json` with replay route and fidelity tier.

### Replay routes

| Route | When |
|-------|------|
| `SOURCE_REPLAY` | Public asset URLs, source maps, readable modules |
| `PIPELINE_REPLAY` | Runtime GPU/shader facts sufficient |
| `BEHAVIOR_REBUILD` | Last resort — label approximate |

For DOM/video sites (Framer, Webflow): route is often `public-cdn-video-dom-rebuild`.

---

## Phase 3: Merge & Resolve

Cross-check Track A and Track B before generation:

| DNA says | Scout says | Action |
|----------|-----------|--------|
| `canvas_webgl: true` | canvas excluded | Trust scout; update DNA |
| `video_backgrounds: true` | video URLs in manifest | Use manifest URLs (SOURCE) |
| motion described | scroll timing PARTIAL | Mark PARTIAL in known-gaps |
| platform "Framer" | frameworkHypotheses Framer SOURCE | Align meta.platform |

Unified `truthNotes` across both artifacts. Blocking unknowns must be empty or have explicit fallbacks before generation.

---

## Phase 4: Generate

Read [references/generation-guide.md](references/generation-guide.md).

1. Parse `design-dna.json` → CSS custom properties from `design_system`.
2. Apply `design_style` for subjective decisions (whitespace, hierarchy).
3. Implement `visual_effects` per scout backend:
   - Lightweight → CSS, SVG, vanilla JS
   - Video composite → dual `<video>` + grain + sticky scroll
   - Medium → Canvas 2D, GSAP, Lottie
   - Heavy → Three.js, GLSL — follow replay-policy, preserve baseline
4. **Fetch real assets from source URLs** — never substitute when SOURCE exists.
5. Default output: self-contained `index.html` with inline CSS/JS.
6. Write `README.md` with quick start (`npx serve .`) and known gaps.
7. Write `.web-shader-extractor/known-gaps.md` for every PARTIAL/GUESS.

Comment implementation-critical code: `// SOURCE:`, `// PARTIAL:`, `// GUESS:`.

---

## Phase 5: Verify & Package

1. Run locally: `npx serve .`
2. Visual check: hero, nav, typography, colors, scroll behavior.
3. Console: no errors on load.
4. Fill `templates/qa-report.md` if mismatches found.
5. Record fidelity tier in README.

### Completion states

- **DONE_CLONE**: Page runs locally, SOURCE visuals correct, gaps documented.
- **DONE_BASELINE_VERIFIED**: Visual surface group passes recon QA (for shader-heavy targets).
- **BLOCKED**: External auth or unresolved blocking unknown — report to user.

---

## Reference Router

Load only what the current phase needs:

| Need | Read |
|------|------|
| DNA schema | `references/schema.md` |
| HTML/CSS generation | `references/generation-guide.md` |
| Global contract, fact labels | `references/operating-contract.md` |
| Recon state flow, gates | `references/recon-kernel.md` |
| Surface discovery | `references/surface-discovery.md` |
| Lock criteria | `references/target-lock.md` |
| Evidence labels | `references/evidence-policy.md` |
| Tool selection | `references/tool-capability-matrix.md` |
| WebGL/WebGPU capture | `references/capture-backends.md` |
| Source maps, bundles | `references/source-analysis.md` |
| Replay routes, baseline | `references/replay-policy.md` |
| QA, failure routing | `references/qa-failure-policy.md` |
| Three.js reconstruction | `references/three-shader-reconstruction.md` |
| Unicorn Studio | `references/unicorn-studio.md` |
| shaders.com / TSL | `references/shaders-com.md` |

## Utility Scripts

Optional helpers when Playwright/shell available:

- `scripts/fetch-rendered-dom.mjs` — DOM inventory helper
- `scripts/scan-bundle.sh` — target-bound bundle slice scan

Script output is hypothesis evidence. It never satisfies gate requirements by itself.

---

## Phase Combinations

| User request | Phases |
|-------------|--------|
| "Clone this URL" | Full pipeline (1→5) |
| "Extract design only" | 1 → 2A → output DNA JSON |
| "What's rendering the hero?" | 1 → 2B → scout + manifest |
| "I have DNA JSON, build it" | 2B (minimal scout) → 4 → 5 |
| "Show me the schema" | Read schema.md only |

Detect needed phases from context. Default to full pipeline when user says "clone".

---

## Non-Negotiables

1. Real assets over approximations when SOURCE URLs exist.
2. Never invent WebGL when scout excluded canvas.
3. Never overwrite verified baseline for cleanup.
4. Document PARTIAL/GUESS — honesty over false fidelity.
5. Handle only public or user-authorized content.
6. Do not persist cookies, tokens, or secrets.

---

## Example: Editorial + Video Hero (Framer)

Scout locks `hero-video-group` (intro + loop WebM), excludes canvas.
DNA captures Beausite Classic, `#FE7141`, sticky scroll, film grain.
Generation uses SOURCE video URLs, CSS grain, intro→loop JS handoff.
Scroll timing marked PARTIAL. Result: `baseline-with-documented-gaps`.

See `examples/stateofaidesign/` for a complete reference output (optional).
