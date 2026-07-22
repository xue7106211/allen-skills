# design-clone

High-fidelity webpage clone skill for Cursor / Claude Code agents. Merges **Design DNA** extraction with **evidence-based surface recon** to produce local, runnable clones from URLs.

## What it does

1. **Extract Design DNA** — colors, typography, layout, style, visual effects → `design-dna.json`
2. **Surface Recon** — lock rendering stack (WebGL, Canvas, video, DOM composite) → `scout-card.json` + `replay-manifest.json`
3. **Generate** — self-contained `index.html` using SOURCE assets and documented gaps
4. **Verify** — local serve + QA checklist

## Install

### Cursor (personal skill)

```bash
git clone https://github.com/xue7106211/design-clone.git ~/.cursor/skills/design-clone
```

Or on Windows:

```powershell
git clone https://github.com/xue7106211/design-clone.git $env:USERPROFILE\.cursor\skills\design-clone
```

Restart Cursor or start a new agent session. The skill auto-discovers from `~/.cursor/skills/`.

### Claude Code

```bash
git clone https://github.com/xue7106211/design-clone.git ~/.claude/skills/design-clone
```

### Skills CLI (optional)

```bash
npx skills add xue7106211/design-clone
```

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
