# Changelog

## Unreleased

### Added
- `pause_music` and `resume_music`. `resume_music` only resumes a track that was still playing
  when it was paused, so a track that had already finished isn't restarted from the beginning.
- luacheck config and a pre-commit hook that runs it (enable with
  `git config core.hooksPath .githooks`).

### Fixed
- `sound_buffer` went through its copies in a scrambled order, and with a size of 2 it only ever
  played the first one. It now plays them in turn.

## 0.5.0 - 2026-10-16

### Added
- `game_time()`: seconds since the game started.
- `load_font(file_name, size)`: loads a font from `assets/fonts`.
- `tween` module for drawing between fixed update steps, so motion stays smooth at any refresh
  rate.
- `array.remove_if(list, f)`: removes matching items in place, keeping the order of the rest.

### Changed
- The viewport is centred in the window, and anything drawn outside it is clipped.
- Window resizes that don't trigger `love.resize` are picked up when drawing.
- Switching back to windowed mode uses `love.window.updateMode`.

### Fixed
- Viewport scaling defaults to `fit`. Before, drawing crashed unless `setup_viewport` had been
  called.

## 0.4.0 - 2023-03-22

### Added
- Viewport scaling: `setup_viewport` takes a scaling function as an optional third argument
  (`fit` by default). The `scaling` module provides `fit` and `stretch`.
- `array` module with `array.tabulate`.
- `sound_buffer` module: a pool of clones of a sound, so the same sound can overlap itself.

## 0.3.0 - 2021-03-13

### Added
- Screens: `add_screen`, `load_screen`, `switch_to`, `screens` and `current_screen`.
  `switch_to` calls the old screen's `hide` and the new one's `show`, if they have them.
- `data()`: gets or sets a table of data shared by all screens.

### Fixed
- `play_sound` leaked a global variable.

## 0.2.1 - 2020-11-30

### Added
- `play_music`, `stop_music` and `play_sound`.

## 0.2.0 - 2020-06-12

### Added
- Preferences: `music_vol` and `sound_vol` are read from a `prefs` file and applied to the
  preloaded music and sounds.
- `toggle_fullscreen()`: switching back to windowed mode restores the initial window size.
- Window resizing support.

### Changed
- The viewport defaults to the window size.
- `update` always runs before the first `draw`.
- Window size is measured in DPI-scaled units (`getDimensions`), not pixels.

### Fixed
- The vertical viewport scale was computed from the viewport width.

## 0.1.0 - 2019-03-10

Initial release.

- Takes over the LÖVE callbacks and calls the game's `lf.init`, `lf.update` and `lf.draw`.
- Preloads music, sounds and textures from `assets/preload/{music,sounds,gfx}`. Get them with
  `get_music`, `get_sound` and `get_texture`.
- `setup_viewport(width, height)`: the game draws at that size, scaled to the window.
- `update` runs at a fixed 50 steps per second.
