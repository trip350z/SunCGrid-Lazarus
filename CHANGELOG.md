# Changelog

## Unreleased

- Request repaint when Alignment, FixedAlignment, FocusDraw, or MultiLines changes.
- Validate SetCellParams before allocating a record so rejected input preserves existing formatting and column inheritance.
- Return fixed-cell alignment/background defaults consistently with drawing.
- Keep column multiline defaults out of fixed rows while preserving explicit fixed-cell settings.
- Add regression tests for these review findings.

- Rename the component palette category from `Suntec` to `164SYSTEMS`. Rebuild/reinstall the package to update the IDE palette.

- Prepare the standalone public repository with English/Japanese guides, provenance and license-status notices, issue/PR templates, and build scripts.
- Pass Windows x64, Linux GTK2, and macOS Intel Cocoa package/demo builds and regression tests in GitHub Actions on 2026-11-23.
- Add regression coverage for parameter records, range bounds, font ownership/index adjustment, repeated clearing, and column shrink/regrow behavior.

## 2026-11-02 — Initial LCL port

- Replace Windows-specific text drawing with LCL Canvas.TextRect/TTextStyle.
- Preserve TSunColGrid and legacy property/method names.
- Fix double-free/cache problems after clearing parameters and registered-font index maintenance.
- Add a Lazarus package, Japanese demo, macOS app-bundle project, and Linux/macOS build script.

No stable release tag is published. Visual behavior still requires manual checks.
