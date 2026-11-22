# StageRig Website Color Scheme

A visual identity inspired by the StageRig desktop wallpaper: midnight
navy, electric blue, cyan signal lines, and warm amber stage lighting.

The goal is a professional live-performance software aesthetic---not a
generic music website.

## 1. Brand direction

-   **Overall feel:** dark, polished, technical, and stage-inspired.
-   **Primary foundation:** deep navy and near-black backgrounds.
-   **Functional accent:** electric blue and cyan for interactive
    elements, active states, and signal paths.
-   **Brand accent:** warm amber and gold for the StageRig identity and
    selected highlights.
-   **Typography:** a modern geometric sans-serif such as Inter or
    Manrope.

## 2. Color palette

### Primary backgrounds

  Name             Hex         Intended use
  ---------------- ----------- --------------------------------------------
  Midnight Black   `#000712`   Main page background
  Deep Navy        `#001025`   Secondary background and navigation
  Slate Navy       `#0D1C33`   Cards, panels, and containers
  Stage Blue       `#00224B`   Elevated surfaces and deeper blue sections

### Accent colors

  Name            Hex         Intended use
  --------------- ----------- --------------------------------------------
  Electric Cyan   `#0087FC`   Primary accent, active controls
  Signal Blue     `#0A3770`   Secondary accent and hover states
  Stage Amber     `#D8700B`   Brand highlight and important emphasis
  Warm Gold       `#CEA04A`   Secondary highlight and decorative details

### Typography colors

  -----------------------------------------------------------------------
  Name                    Hex                     Intended use
  ----------------------- ----------------------- -----------------------
  Warm White              `#FAF4EB`               Main text and headings

  Muted Blue Gray         `#9AA9BC`               Body copy, secondary
                                                  text, and metadata
  -----------------------------------------------------------------------

### Borders

  Name           Hex         Intended use
  -------------- ----------- ---------------------------------------
  Panel Border   `#1A3555`   Subtle card, panel, and input borders

## 3. Website element mapping

  Element                 Color
  ----------------------- -----------
  Page background         `#000712`
  Navigation background   `#001025`
  Cards and containers    `#0D1C33`
  Elevated surfaces       `#00224B`
  Card borders            `#1A3555`
  Primary buttons         `#0087FC`
  Button hover            `#0A3770`
  Brand logo accent       `#D8700B`
  Links                   `#00A8FF`
  Headings                `#FAF4EB`
  Body text               `#9AA9BC`

## 4. CSS custom properties

Use these variables as the starting point for the website's design
system.

``` css
:root {
  /* Backgrounds */
  --sr-bg: #000712;
  --sr-bg-secondary: #001025;
  --sr-surface: #0D1C33;
  --sr-surface-raised: #00224B;

  /* Brand accents */
  --sr-cyan: #0087FC;
  --sr-blue: #0A3770;
  --sr-amber: #D8700B;
  --sr-gold: #CEA04A;

  /* Typography */
  --sr-text: #FAF4EB;
  --sr-text-muted: #9AA9BC;

  /* Borders */
  --sr-border: #1A3555;

  /* Effects */
  --sr-glow-cyan: 0 0 18px rgba(0, 135, 252, 0.35);
  --sr-glow-amber: 0 0 18px rgba(216, 112, 11, 0.30);
}
```

## 5. Practical design guidance

1.  **Keep backgrounds dark.** Avoid large pure-white sections. Deep
    navy and near-black establish the StageRig visual identity.
2.  **Use cyan for functionality and amber for identity.** Cyan works
    well for interactive elements, active states, links, and signal
    paths. Reserve amber for the logo, selected highlights, and
    important emphasis.
3.  **Use lighting effects sparingly.** Restrained cyan and amber glows
    can highlight buttons, active controls, and feature illustrations
    without making the interface feel cluttered.
4.  **Maintain readable contrast.** Use Warm White for important text
    and Muted Blue Gray for secondary text. Check contrast for small
    text and controls during implementation.
5.  **Keep the interface cohesive.** Reuse the same palette in
    navigation, buttons, cards, status indicators, and the StageRig
    application itself.

## 6. Example visual hierarchy

A typical landing page could use:

-   A Deep Navy navigation bar with the StageRig wordmark.
-   A Midnight Black page background.
-   A large Warm White headline with a short Muted Blue Gray
    description.
-   An Electric Cyan primary call-to-action button.
-   A dark Slate Navy feature-card row.
-   Cyan icons for routing and controls, with amber accents for
    performance-related highlights.

Example brand wordmark treatment:

-   `Stage` in Warm White (`#FAF4EB`)
-   `Rig` in Stage Amber (`#D8700B`)

## 7. Palette reference

  Token                   Hex
  ----------------------- -----------
  `--sr-bg`               `#000712`
  `--sr-bg-secondary`     `#001025`
  `--sr-surface`          `#0D1C33`
  `--sr-surface-raised`   `#00224B`
  `--sr-cyan`             `#0087FC`
  `--sr-blue`             `#0A3770`
  `--sr-amber`            `#D8700B`
  `--sr-gold`             `#CEA04A`
  `--sr-text`             `#FAF4EB`
  `--sr-text-muted`       `#9AA9BC`
  `--sr-border`           `#1A3555`

*The palette is based on the StageRig wallpaper, with supporting colors
selected to make it practical as a website design system.*
