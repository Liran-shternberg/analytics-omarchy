# analytics-omarchy

A system-monitor widget for the [Omarchy](https://omarchy.org) shell bar.

Shows CPU usage (percentage) and RAM usage (used GB) side by side, each colored
green → yellow → red as load climbs. The whole widget is one click target —
clicking it opens [btop](https://github.com/aristocratos/btop).

![Preview](analytics-omarchy-demo.gif)

## Configuration

Coloring is on by default. Turn it off (plain bar-text color):

```bash
omarchy bar set analytics-omarchy colored false
```

Or set `"colored": false` in the widget's entry in `~/.config/omarchy/shell.json`.

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
- Both values are tinted through the same `heatColor()` ramp (hue 0.33 → 0.0).
