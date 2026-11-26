---
name: Pastel Glow Beauty
colors:
  surface: '#fef9e7'
  surface-dim: '#dfdac9'
  surface-bright: '#fef9e7'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f9f4e2'
  surface-container: '#f3eedc'
  surface-container-high: '#ede8d7'
  surface-container-highest: '#e7e3d1'
  on-surface: '#1d1c11'
  on-surface-variant: '#47464b'
  inverse-surface: '#323125'
  inverse-on-surface: '#f6f1df'
  outline: '#77767b'
  outline-variant: '#c8c5cb'
  surface-tint: '#5f5e61'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#1b1b1e'
  on-primary-container: '#858387'
  inverse-primary: '#c8c5ca'
  secondary: '#685b5f'
  on-secondary: '#ffffff'
  secondary-container: '#f0dee2'
  on-secondary-container: '#6e6165'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#131e17'
  on-tertiary-container: '#7a877d'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e4e1e6'
  primary-fixed-dim: '#c8c5ca'
  on-primary-fixed: '#1b1b1e'
  on-primary-fixed-variant: '#47464a'
  secondary-fixed: '#f0dee2'
  secondary-fixed-dim: '#d3c2c6'
  on-secondary-fixed: '#22191c'
  on-secondary-fixed-variant: '#4f4447'
  tertiary-fixed: '#d9e6da'
  tertiary-fixed-dim: '#bdcabe'
  on-tertiary-fixed: '#131e17'
  on-tertiary-fixed-variant: '#3e4a41'
  background: '#fef9e7'
  on-background: '#1d1c11'
  surface-variant: '#e7e3d1'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 30px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 10px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.04em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system embodies a modern Korean & Scandinavian skincare aesthetic—merging serene minimalism with playful, tactile softness. Targeted at skincare enthusiasts, beauty minimalists, and Gen-Z/millennial digital shoppers, the interface evokes calm, indulgence, purity, and tactile delight.

The visual style relies on:
- **Soft Pastel Color Blocking:** Alternating soft blush pink, pale mint green, and creamy butter yellow surfaces to categorize, separate, and highlight skincare items.
- **Pill & Ultra-Curved Geometries:** Expansive 24px–32px corner radii that mimic organic cosmetic packaging, smooth ceramic jars, and rounded beauty containers.
- **High-Contrast Anchors:** Deep obsidian-charcoal (#18181B) interactive elements and typography that ground the soft pastel canvases, maintaining strict legibility and decisive call-to-action intent.
- **Floating Island Navigation:** Detached capsule bottom navigation docks and floating circular utility actions with whisper-light ambient depth.

## Colors

The palette balances airy pastel hues with crisp, high-contrast dark accents to achieve an editorial, clean beauty storefront:

- **Primary (`#18181B`):** Deep charcoal/ink black used for primary CTA buttons ("Add to cart", "Proceed to checkout"), high-emphasis typography, selected state indicators, and floating dock action hubs.
- **Secondary (`#FDEBEF`):** Gentle blush pink serving as the signature tone for product display containers, featured collection backdrops, and active category badges.
- **Tertiary (`#E8F5E9`):** Soft sage/mint green utilized for soothing product card variants, organic/clean beauty item containers, and subtle status tags.
- **Neutral Accent (`#FEF9E7`):** Warm pastel butter yellow used for alternating product cards, hydrating collection highlights, and cart listing item backgrounds.
- **Surface & Backgrounds:** The base screen canvas sits on pure white (`#FFFFFF`) or ultra-subtle off-white (`#FCFAF9`), giving pastel modules maximum freshness and breathing space.
- **Muted & Supportive Neutrals:** Mid-tone gray (`#71717A`) for secondary subtitles, unit counts, and inactive navigation glyphs; border outline tone (`#F4F4F5`) for delicate divider rules.

## Typography

The type scale uses **Plus Jakarta Sans** throughout all tiers. Its clean geometric curves and open counters match the rounded organic shapes of the cosmetic product packaging and interface containers.

- **Headlines:** Set with tight tracking (`-0.02em`) and strong line-height ratios. Editorial headers such as `"Beauty as always for here"` rely on medium-to-bold weights to anchor visual hierarchy without shouting.
- **Product Titles & Pricing:** Clean, confident semi-bold styling (`title-md` and `headline-sm`) ensuring quick skimming of beauty formulations, brand names, and cost figures.
- **Supporting Labels & Metadata:** Light, neutral weights for product counts, reviews, volume information, and shipping disclosures to keep UI cards breathable.

## Layout & Spacing

The layout is built for fluid mobile experiences centered on clean product showcases:

- **Mobile Grid & Margins:** Fluid 4-column layout on mobile devices with an outer canvas gutter/margin of `1.25rem` (20px). Grid cards align on a 2-column staggered format with `1rem` (16px) gutters between product tiles.
- **Vertical Rhythm:** Generous vertical breathing room (`1.5rem` to `2rem`) between section titles, carousel previews, and cart summaries.
- **Floating Island Clearance:** The bottom of scrollable views must maintain a minimum `5.5rem` (88px) padding offset to accommodate the floating capsule navigation bar and full-width checkout action bars without overlapping interactive elements.
- **Internal Component Spacing:** Product card internal padding scales tightly between `0.75rem` (12px) and `1rem` (16px), centering hero imagery while letting the pastel container frame the product packaging.

## Elevation & Depth

Visual hierarchy rejects harsh, sharp dropshadows in favor of flat pastel color blocking combined with ultra-soft ambient light:

- **Level 0 (Flat Color Surfaces):** Product background tiles (`#FDEBEF`, `#E8F5E9`, `#FEF9E7`) and detail sheet wrappers use zero shadow, relying purely on color contrast and border radii against white canvases.
- **Level 1 (Floating Utility Buttons):** Circular action buttons (e.g., Back chevron, Heart wishlist toggle) feature a soft ambient bloom: `box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.04)`.
- **Level 2 (Floating Dock & Bottom Sheets):** The floating capsule navigation bar utilizes a multi-layered atmospheric shadow: `box-shadow: 0px 8px 30px rgba(0, 0, 0, 0.08), 0px 1px 3px rgba(0, 0, 0, 0.02)`.
- **Level 3 (Sticky Bottom CTA Container):** Bottom checkout and add-to-cart sheets sit atop screens with a gentle upward linear gradient feather or ultra-subtle top separation border.

## Shapes

The interface embraces an exaggerated pill-and-capsule design language:

- **Standard Elements (Pill / Level 3):** Buttons, interactive chips, quantity counter bars, and floating docks utilize full `9999px` circular pill radii.
- **Product Tiles & Cards:** Outer card perimeters employ ultra-rounded continuous curves ranging between `24px` (`rounded-lg`) and `32px` (`rounded-xl`), creating the distinctive organic aesthetic seen in contemporary Korean beauty branding.
- **Floating Action Dots:** Back buttons, favorite buttons, and central dock launcher hubs are pure circles (`width == height`, `border-radius: 50%`).
- **Image Frames:** Product cutouts and cosmetic bottles rest inside rounded rectangular pastel capsules with matching `24px` internal bounding curves.

## Components

### Action Buttons
- **Primary Buttons:** High-contrast solid `#18181B` with pure `#FFFFFF` bold typography. Height is 54px–58px with a full pill radius (`border-radius: 9999px`).
- **Circular Utility Buttons:** Floating circular triggers (44px × 44px) in pure white `#FFFFFF` or translucent white, housing minimalist 18px stroke icons (back arrow, bookmark, heart).
- **Stepper Buttons:** Compact pill-shaped quantity controls (`+` / `-`) embedded on item rows with flat off-white or tonal pastel backgrounds.

### Product Showcase Cards
- **Curated Tinted Cards:** Self-contained rounded cards (`border-radius: 28px`) rendered in rotating soft tints:
  - Variant A: Soft Blush (`#FDEBEF`)
  - Variant B: Soft Sage (`#E8F5E9`)
  - Variant C: Soft Butter (`#FEF9E7`)
- **Wishlist Overlay:** A compact 36px white circular button positioned in the top-right corner of each card holding a hairline heart icon.
- **Card Imagery:** Transparent PNG cosmetic jars/bottles centered with realistic product cast shadows, occupying 60–70% of the upper card vertical space.
- **Card Typography:** Left-aligned brand name (`title-md`), sub-description/variant line (`body-sm`, neutral gray), and bottom price tag in crisp semi-bold type.

### Cart Item Rows
- **Horizontal Pastel Capsules:** Rounded horizontal pods (`border-radius: 24px`) draped in soft pink, sage, or yellow.
- **Layout:** Square thumbnail preview on the left, centered product name, formulation volume, and price, with vertical stepper buttons (`+` and `-`) docked on the right perimeter.

### Floating Island Navigation Dock
- **Container:** A floating white pill capsule centered horizontally at the bottom of the viewport with a fixed height of 64px, flanked by 20px screen margins.
- **Dock Items:** Minimalist hairline icons (Home, Search, Bag) evenly spaced with the center occupied by a prominent circular solid black (`#18181B`) hub icon button (48px × 48px).

### Detail Page Hero & Specs Sheet
- **Top Canvas:** Expansive pale blush pink or soft white gallery with horizontal pagination capsule dashes (`active: #18181B` wide pill, `inactive: #E4E4E7` dot).
- **Bottom Slide Surface:** Overlapping pure white card surface with `32px` top border-radii containing product title, star rating cluster, price summary, and full-width "Add to cart" primary button.