# Generation Guide

Apply `design-dna.json` + `.web-shader-extractor/replay-manifest.json` to produce a local clone.

## Output Structure

```text
output-dir/
├── index.html              # Self-contained clone (default)
├── design-dna.json
├── README.md               # Quick start + known gaps
├── .web-shader-extractor/
│   ├── scout-card.json
│   ├── replay-manifest.json
│   └── known-gaps.md
└── assets/                 # Only when CDN hotlink is unreliable
```

## CSS Token Mapping

Map `design_system` to CSS custom properties:

```css
:root {
  --orange: #fe7141;           /* accent */
  --black: #000;               /* primary */
  --white: #fff;               /* secondary */
  --font-display: "Beausite Classic Medium", sans-serif;
  --font-mono: "Fragment Mono", monospace;
  --nav-h: 56px;
  --content: 1200px;
}
```

Use exact values from DNA. Do not round or substitute.

## Asset Policy

Priority order:

1. **SOURCE URLs** from `replay-manifest.json` and `visual_effects.*.assets`
2. **SOURCE URLs** from runtime DOM (fonts, images, videos)
3. **PARTIAL approximations** — document in `known-gaps.md`
4. Never substitute with placeholders when real URLs exist

Fetch `@font-face` from original CDN. Preserve exact `src` URLs.

## Visual Effects Implementation

| Backend (from scout) | Implementation |
|---------------------|----------------|
| `dom-video-composite` | `<video>` layers + CSS grain + sticky scroll JS |
| `canvas-webgl` / `webgpu` | Follow `references/replay-policy.md`; prefer SOURCE_REPLAY |
| `canvas2d` | Canvas 2D with captured draw calls or behavior rebuild |
| CSS-only | CSS animations, `scroll-timeline`, transitions |

Label every implementation choice in code comments: `(SOURCE)`, `(PARTIAL)`, `(GUESS)`.

## HTML Structure

1. Semantic sections matching source page flow
2. Fixed nav grid if present in DNA layout
3. Hero as sticky scroll container when `scroll_effects.enabled`
4. Editorial grid for content sections
5. Footer with stats if `motion.stats` present

## JavaScript Patterns

### Dual-video hero (SOURCE pattern)

```javascript
introVid.addEventListener('ended', () => {
  heroVideos.classList.add('looping');
  loopVid.play();
});
```

### Scroll-driven motion (PARTIAL when Framer motion)

Use scroll progress mapping with `{ passive: true }`. Document timing gaps.

### Stat count-up

IntersectionObserver + requestAnimationFrame. Threshold 0.3.

## Quality Checklist

Before declaring done:

- [ ] Colors match DNA hex values
- [ ] Typography: correct families, sizes, letter-spacing
- [ ] Hero visual stack matches scout `targetSet`
- [ ] SOURCE assets used where manifest specifies
- [ ] PARTIAL/GUESS items listed in README and `known-gaps.md`
- [ ] Page runs via `npx serve .` without console errors
- [ ] Responsive breakpoints preserve layout intent
- [ ] No invented WebGL when scout excluded canvas

## Fidelity Tiers

| Tier | Meaning |
|------|---------|
| `high-fidelity` | All critical paths SOURCE |
| `baseline-with-documented-gaps` | SOURCE visuals, PARTIAL motion/timing |
| `approximate` | BEHAVIOR_REBUILD with documented GUESS values |

Record tier in `replay-manifest.json` and README.
