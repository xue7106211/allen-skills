# Design DNA Schema

Complete JSON schema for `design-dna.json`. Every field must be populated during extraction — use `"N/A"` or `enabled: false` when not applicable.

## Root Structure

```json
{
  "meta": {},
  "design_system": {},
  "design_style": {},
  "visual_effects": {}
}
```

## meta

| Field | Type | Description |
|-------|------|-------------|
| `source_url` | string | Canonical URL analyzed |
| `title` | string | Page or site title |
| `platform` | string | Framer, Webflow, Next.js, custom, etc. |
| `extracted_at` | string | ISO date |

## design_system

### color

| Field | Description |
|-------|-------------|
| `primary` | Dominant brand/background color (hex) |
| `secondary` | Supporting color (hex) |
| `accent` | CTA/highlight color (hex) |
| `accent_alt` | Secondary accent (hex) |
| `neutral_100`–`neutral_900` | Neutral scale light → dark |
| `highlight` | Special highlight (hex) |
| `link` | Link color (hex) |

### typography

| Field | Description |
|-------|-------------|
| `display.family` | Heading font stack |
| `display.weight` | Heading weight |
| `display.size_h1`, `line_height_h1`, `letter_spacing_h1` | H1 metrics |
| `display.size_h2`, `line_height_h2`, `letter_spacing_h2` | H2 metrics |
| `body.family`, `weight`, `size`, `line_height`, `letter_spacing` | Body text |
| `mono.family`, `weight`, `size_label`, `text_transform` | Labels/code |

### spacing

| Field | Description |
|-------|-------------|
| `density` | tight / moderate / generous |
| `section_gap` | Vertical rhythm between sections |
| `grid_gap` | Grid gutter |
| `page_padding` | Page edge padding |
| `nav_height` | Fixed nav height |

### layout

| Field | Description |
|-------|-------------|
| `max_width` | Viewport max |
| `content_width` | Content column max |
| `columns` | Grid column count |
| `grid_style` | Qualitative grid description |

### shape

| Field | Description |
|-------|-------------|
| `border_radius` | Global radius pattern |
| `border_style` | Divider/border treatment |
| `card_style` | Card shape language |

### elevation

| Field | Description |
|-------|-------------|
| `approach` | flat / subtle / layered |
| `shadows` | Shadow description or "none" |
| `layering` | z-index strategy |

### motion

| Field | Description |
|-------|-------------|
| `hero` | Hero animation description |
| `nav` | Navigation motion |
| `stats` | Counter/reveal animations |
| `easing` | Overall easing feel |

## design_style

| Field | Description |
|-------|-------------|
| `mood` | Emotional tone |
| `personality` | Brand personality |
| `genre` | SaaS, editorial, brutalist, etc. |
| `composition` | Layout strategy |
| `whitespace` | Whitespace philosophy |
| `ornamentation` | Decorative elements |
| `brand_voice` | Copy/tone feel |

## visual_effects

| Field | Description |
|-------|-------------|
| `overview.effect_intensity` | low / medium / medium-high / high |
| `overview.performance_tier` | low / medium / high |
| `canvas_webgl.enabled` | true if WebGL/canvas detected |
| `video_backgrounds.enabled` | true if video layers present |
| `video_backgrounds.assets` | Array of video URLs |
| `film_grain.enabled` | Noise/grain overlay |
| `scroll_effects.enabled` | Scroll-driven animations |
| `svg_animations.enabled` | Inline SVG motion |
| `composite_notes` | Summary of full visual stack |

Set `enabled: false` for categories not present. Cross-check with `.web-shader-extractor/scout-card.json` before finalizing.
