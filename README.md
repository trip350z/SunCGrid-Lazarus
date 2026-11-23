# SunCGrid for Lazarus

[日本語](README.ja.md) · [Build and test status](https://github.com/trip350z/SunCGrid-Lazarus/actions/workflows/build.yml)

An LCL port of **TSunColGrid**, a TStringGrid extension for per-cell formatting, alternating row colors, multiple lines, font registration, and fixed-cell highlighting.

Original source credits: **SUNTEC Konagai (2000, 2009), SUNTEC Toshima (2005)**. Original author comments are retained. Review [LICENSE](LICENSE) before reuse: **the supplied original source did not specify a license, and this project does not assert a repository-wide open-source license.** Public visibility is not a new license grant for the original code.

## Platforms

| OS | Widget set | Demo project |
| --- | --- | --- |
| Windows x64 | `win32` | `demo/SunGridDemo.lpi` |
| Linux | `gtk2`, with Qt5/Qt6 build options | `demo/SunGridDemo.lpi` |
| macOS | `cocoa` | `demo/SunGridDemoMac.lpi` |

Package/demo builds and parameter/lifecycle tests passed on Windows x64, Linux GTK2, and macOS Intel Cocoa in [the 2026-11-23 CI run](https://github.com/trip350z/SunCGrid-Lazarus/actions/runs/45105065514). Check Actions for subsequent run outcomes. Apple Silicon, Qt widget sets, IDE installation, and visual behavior require separate validation.

The local baseline is Free Pascal 3.2.2. Install Lazarus/LCL and the development libraries for your chosen widget set. On Ubuntu/Debian include `fp-units-misc`, which Lazarus clipboard units require. On macOS also install Xcode Command Line Tools/SDK. Unix programs must load `cthreads` before `Interfaces`, as in the supplied programs.

## Install

1. Clone/download the repository and open `sungridlcl.lpk` from **Package → Open package file** in Lazarus.
2. Compile, then **Use → Install**, and rebuild the IDE.
3. Find `TSunColGrid` on the **164SYSTEMS** palette.

For runtime-only use, put `SunCGrid.pas` on the project unit search path and add `SunCGrid` to `uses`. Delphi DCU files are not usable with FPC. The original DCR is not distributed or loaded; Lazarus uses its default component icon.

## Build

From the repository root, with `lazbuild` on PATH:

```sh
# Linux
sh build.sh gtk2
# Or qt5 / qt6, with matching LCL bindings installed.
./demo/SunGridDemo

# macOS
sh build.sh cocoa
open demo/SunGridDemo.app
```

Windows PowerShell:

```powershell
./build.ps1
./tests/SunGridSmoke.exe
```

If necessary, pass `-LazBuild 'E:\path\to\lazbuild.exe'` to `build.ps1`. Both scripts build the package, demo, and smoke test. Each target needs its own native toolchain; the scripts do not install cross-compilers. macOS signing/notarization is not included.

The demo shows Japanese text, literal ampersands, left/center/right alignment, custom fonts, cell backgrounds, wrapping, and hatch brushes. A Japanese-capable system font is needed. Font metrics, hatch patterns, selection/focus rendering, IME, and Retina/high-DPI appearance can vary by platform.

## Use

```pascal
uses SunCGrid;

Grid := TSunColGrid.Create(Self);
Grid.Parent := Self;
Grid.ColCount := 5;
Grid.RowCount := 10;
Grid.Cells[1, 1] := 'Hello';
Grid.CellColors[1, 1] := clYellow;
Grid.CellAlignments[2, -1] := taRightJustify;
Grid.CellMultiLines[2, 2] := True;
Grid.Cells[2, 2] := 'First line' + LineEnding + 'Second line';
```

`Self` is a form in this example. Add `Graphics` and `Classes` when using their colors and alignment constants.

## Compatibility

- The class, main properties, and method names are retained, including the original spellings **`TowColors`** and **`ClearStings`**.
- Cell indices start at zero. Row `-1` stores column defaults for ordinary rows. If a cell has its own parameter record, that whole record takes priority; inheritance is not per field.
- `CellFonts = -1` selects the grid font. `AddFont` copies a font; `DeleteFont` rejects a font still referenced by parameters, and adjusts higher indices after deletion.
- `ClearAllCellParams` releases formatting records and resets the lookup cache; it does not remove registered fonts.
- Shrinking and regrowing columns retains their parameter records. Row/column insertion, deletion, and movement do not automatically remap formatting records.
- `TTextLayout` aliases `Graphics.TTextLayout`. Rendering uses LCL canvas methods instead of Windows DrawText.
- Convert Delphi forms from DFM to LFM separately. The extra per-cell runtime formatting is not serialized as published properties.

The demo is the starting point for appearance checks. Passing the smoke test does not validate screen layout, editing, fixed-cell highlighting after selection changes, or IME behavior.

## Tests and contributions

```sh
./tests/SunGridSmoke
# On a headless Linux host:
xvfb-run -a ./tests/SunGridSmoke
```

The test covers cell parameter round trips, exclusive upper bounds, font ownership/index adjustment, repeated clearing/cache reset, column shrink/regrow behavior, construction/destruction, repaint requests after setting changes, fixed-cell defaults, and rejection of invalid parameters without formatting changes. It reports exceptions on stderr with exit code 1.

See [CONTRIBUTING.md](CONTRIBUTING.md), [CHANGELOG.md](CHANGELOG.md), and [NOTICE.md](NOTICE.md). Please include OS/CPU, Lazarus/FPC versions, widget set, reproduction steps, and screenshots for visual problems.
