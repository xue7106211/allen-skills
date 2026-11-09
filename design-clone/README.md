# design-clone

High-fidelity webpage clone skill for Cursor / Claude Code agents. Merges **Design DNA** extraction with **evidence-based surface recon** to produce local, runnable clones from URLs.

## What it does

1. **Extract Design DNA** — colors, typography, layout, style, visual effects → `design-dna.json`
2. **Surface Recon** — lock rendering stack (WebGL, Canvas, video, DOM composite) → `scout-card.json` + `replay-manifest.json`
3. **Generate** — self-contained `index.html` using SOURCE assets and documented gaps
4. **Verify** — local serve + QA checklist

## Install

This skill lives in the [allen-skills](https://github.com/xue7106211/allen-skills) monorepo. The standalone `xue7106211/design-clone` repo is archived; do not install from it.

```bash
npx skills add xue7106211/allen-skills --skill design-clone
```

Add `-g` to install globally. Restart the agent or start a new session to pick it up.

## Usage

Tell the agent:

- "Clone https://example.com using design-clone"
- "复刻这个网站"
- "Extract design DNA and build a local replay"

The agent reads `SKILL.md` and follows the unified pipeline.

## Output structure

```text
your-project/
├── index.html
├── design-dna.json
├── README.md
└── .web-shader-extractor/
    ├── scout-card.json
    ├── replay-manifest.json
    └── known-gaps.md
```

## Reference example

See [stateofaidesign-clone](https://github.com/xue7106211/stateofaidesign-clone) for a complete output from cloning [stateofaidesign.com](https://stateofaidesign.com/).

## Origin

Merged from:

- **design-dna** — 3-dimension design extraction (system, style, visual effects)
- **web-shader-extractor** — evidence-based surface recon and replay

## License

MIT
