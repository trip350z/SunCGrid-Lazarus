# Contributing

Report the OS/CPU, Lazarus/FPC versions, widget set, a small reproduction, and expected/actual results. Include font and display-scaling details plus a screenshot for drawing issues. Remove personal or confidential cell contents before sharing a screenshot.

Build with `build.sh` or `build.ps1` and run `tests/SunGridSmoke`. GTK tests need a display or `xvfb-run -a`. Describe the checks performed and distinguish parameter tests from manual visual checks.

Keep public names compatible and document intentional behavior changes. Preserve author notices. Fixes to parameter ownership, cache invalidation, or registered-font indices should include a regression test. Do not add a blanket license to inherited code without establishing the original terms; see LICENSE.

Visual checks should cover Japanese text and ampersands, alignment and wrapping, editing and IME, selection/fixed cells, scrolling, high DPI, and very narrow cells. A successful compile does not establish visual equivalence between widget sets.
