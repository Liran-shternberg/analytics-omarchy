# analytics-omarchy

A system-monitor widget for the [Omarchy](https://omarchy.org) shell bar.

Shows CPU usage (percentage) and RAM usage (used GB) side by side, each colored
green → yellow → red as load climbs. Optionally follows the active Omarchy
theme instead. The whole widget is one click target — clicking it opens
[btop](https://github.com/aristocratos/btop).

![Preview](Analytics-omarchy-demo.GIF)

## Configuration

Coloring is on by default. Turn it off (plain bar-text color):

```bash
omarchy bar set analytics-omarchy colored false
```

Or set `"colored": false` in the widget's entry in `~/.config/omarchy/shell.json`.

### Color mode

Two modes are available via the `colorMode` setting:

- `theme` (default) — follows the active Omarchy theme: bar-text color when
  idle, the theme accent from 60%, and the theme urgent color from 85%.
  Updates live on `omarchy theme set`.
- `heat` — the classic green → yellow → red ramp.

```bash
omarchy bar set analytics-omarchy colorMode theme
omarchy bar set analytics-omarchy colorMode heat
```

The font always follows the bar's theme font.

## Install

```bash
omarchy plugin add https://github.com/liran-shternberg/analytics-omarchy.git --enable
```

Or develop locally:

```bash
ln -s ~/Projects/analytics-omarchy ~/.config/omarchy/plugins/analytics-omarchy
omarchy-shell shell rescanPlugins
omarchy plugin enable analytics-omarchy
omarchy bar move analytics-omarchy --section right
```

## Uninstall

```bash
omarchy plugin remove analytics-omarchy
```

## Requirements

- `btop` (opened on click)

## How it works

- Polls `omarchy-system-stats` (ships with Omarchy) every 3 seconds.
- CPU percentage is used directly; RAM percentage is derived from the reported
  used/total values.
- Both values are tinted through the same `usageColor()` ramp — either the heat
  gradient (hue 0.33 → 0.0) or theme colors, depending on `colorMode`.
