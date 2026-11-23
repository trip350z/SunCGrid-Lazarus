# Provenance and scope

The component is based on the user-supplied Delphi `SunCGrid.pas`, whose header credits SUNTEC Konagai (2000-01-31, 2009-06-26) and SUNTEC Toshima (2005-03-04). That header is preserved in the port. This is a third-party port, not a claim of affiliation with or endorsement by those authors.

The original source did not contain an explicit license grant. Consequently the repository does not apply a blanket new license to inherited code. If authoritative original license/redistribution terms become available, preserve and document them here. See [LICENSE](LICENSE).

The LCL changes replace Windows rendering, fix parameter cleanup/cache invalidation and font-index maintenance, and add Lazarus packaging, demos, tests, and build documentation. This repository contains the port; original Delphi DCU/DCR binaries are excluded.

Lazarus/LCL and FPC are build dependencies, not vendored source or binaries. This repository contains no copy of the CommX/SynaSer component.
