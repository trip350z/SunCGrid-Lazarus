program SunGridSmoke;
{$mode objfpc}{$H+}
uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  Interfaces, Forms, Classes, SysUtils, Graphics, SunCGrid;

type
  TObservedGrid = class(TSunColGrid)
  public
    InvalidationCount: Integer;
    procedure Invalidate; override;
  end;

procedure TObservedGrid.Invalidate;
begin
  Inc(InvalidationCount);
  inherited Invalidate;
end;

procedure Check(Value: Boolean; const MessageText: string);
begin
  if not Value then raise Exception.Create(MessageText);
end;

procedure RunTests;
var
  G: TSunColGrid;
  F: TFont;
  P: TCellDrawParams;
  I: Integer;
  Raised: Boolean;
begin
  G := TSunColGrid.Create(nil);
  F := TFont.Create;
  try
    G.ColCount := 5;
    G.RowCount := 8;
    Check(G.CellFonts[1, 1] = -1, 'Default font index');
    G.CellAlignments[2, -1] := taRightJustify;
    Check(G.CellAlignments[2, 3] = taRightJustify, 'Column defaults');
    G.CellColors[2, 3] := clYellow;
    Check(G.CellColors[2, 3] = clYellow, 'Cell color');
    P := G.GetCellParams(1, 2);
    P.MultiLine := True;
    P.Layout := tlBottom;
    P.FontColor := clRed;
    G.SetCellParams(P);
    P := G.GetCellParams(1, 2);
    Check(P.MultiLine and (P.Layout = tlBottom) and (P.FontColor = clRed),
      'Cell parameter round trip');
    Raised := False;
    try P := G.GetCellParams(G.ColCount, 0); except on E: ERangeError do Raised := True; end;
    Check(Raised, 'Column upper bound must be rejected');
    Raised := False;
    try P := G.GetCellParams(0, G.RowCount); except on E: ERangeError do Raised := True; end;
    Check(Raised, 'Row upper bound must be rejected');
    G.AddFont(F);
    F.Style := [fsBold];
    G.AddFont(F);
    G.CellFonts[3, 3] := 1;
    Raised := False;
    try G.DeleteFont(1); except on E: Exception do Raised := True; end;
    Check(Raised, 'A referenced font must not be deleted');
    G.DeleteFont(0);
    Check((G.FontCount = 1) and (G.CellFonts[3, 3] = 0),
      'Font indices must shift after deleting an earlier unused font');
    G.ClearAllCellParams;
    G.DeleteFont(0);
    Check(G.FontCount = 0, 'Clearing parameters releases font references');
    for I := 1 to 30 do begin
      G.CellColors[1, 1] := clRed;
      Check(G.CellColors[1, 1] = clRed, 'Allocate after clear');
      G.ClearAllCellParams;
      G.ClearAllCellParams;
      Check(G.CellColors[1, 1] = G.Color, 'Cache reset after repeated clear');
    end;
    G.CellColors[4, 2] := clBlue;
    G.ColCount := 3;
    G.ColCount := 5;
    Check(G.CellColors[4, 2] = clBlue, 'Documented column shrink/regrow behavior');
    G.Cells[1, 1] := 'text';
    G.ClearStings(1, 1, 1, 1);
    Check(G.Cells[1, 1] = '', 'ClearStings compatibility method');
  finally
    F.Free;
    G.Free;
  end;
end;

procedure RunReviewRegressions;
var
  G: TObservedGrid;
  P, Before: TCellDrawParams;
  Raised: Boolean;
begin
  G := TObservedGrid.Create(nil);
  try
    G.ColCount := 5;
    G.RowCount := 8;
    G.InvalidationCount := 0;
    G.Alignment := taRightJustify;
    Check(G.InvalidationCount > 0, 'Alignment change must request repaint');
    G.InvalidationCount := 0;
    G.Alignment := taRightJustify;
    Check(G.InvalidationCount = 0, 'Unchanged alignment should not request repaint');
    G.InvalidationCount := 0;
    G.FixedAlignment := taCenter;
    Check(G.InvalidationCount > 0, 'FixedAlignment change must request repaint');
    G.InvalidationCount := 0;
    G.MultiLines := True;
    Check(G.InvalidationCount > 0, 'MultiLines change must request repaint');
    G.InvalidationCount := 0;
    G.FocusDraw := False;
    Check(G.InvalidationCount > 0, 'FocusDraw change must request repaint');

    G.Color := clWhite;
    G.FixedColor := clGray;
    Check(G.CellAlignments[1, 0] = taCenter, 'Fixed row alignment default');
    Check(G.CellAlignments[0, 2] = taCenter, 'Fixed column alignment default');
    Check(G.CellColors[1, 0] = clGray, 'Fixed row background default');
    Check(G.CellColors[0, 2] = clGray, 'Fixed column background default');
    Check(G.CellColors[1, 2] = clWhite, 'Ordinary background default');
    Check(G.CellAlignments[1, 2] = taRightJustify, 'Ordinary alignment default');

    G.MultiLines := False;
    G.CellMultiLines[2, -1] := True;
    Check(not G.CellMultiLines[2, 0], 'Column multiline must not leak into fixed row');
    Check(G.CellMultiLines[2, 2], 'Ordinary row must inherit column multiline');
    G.CellMultiLines[2, 0] := True;
    Check(G.CellMultiLines[2, 0], 'Explicit fixed-row multiline must still work');

    G.ClearAllCellParams;
    G.Alignment := taLeftJustify;
    G.CellAlignments[2, -1] := taRightJustify;
    G.CellColors[2, -1] := clBlue;
    P := G.GetDefaultCellParams(2, 3);
    P.FontIndex := 99;
    G.InvalidationCount := 0;
    Raised := False;
    try G.SetCellParams(P); except on E: ERangeError do Raised := True; end;
    Check(Raised, 'Invalid font must be rejected');
    Check(G.InvalidationCount = 0, 'Rejected parameters must not request repaint');
    Check(G.CellAlignments[2, 3] = taRightJustify,
      'Rejected parameters must not create a cell overriding column alignment');
    Check(G.CellColors[2, 3] = clBlue,
      'Rejected parameters must preserve column background inheritance');
    G.CellColors[2, 3] := clYellow;
    Before := G.GetCellParams(2, 3);
    P := Before;
    P.BackColor := clRed;
    P.FontIndex := -2;
    Raised := False;
    try G.SetCellParams(P); except on E: ERangeError do Raised := True; end;
    Check(Raised, 'Font indices below -1 must be rejected');
    P := G.GetCellParams(2, 3);
    Check((P.BackColor = Before.BackColor) and (P.FontIndex = Before.FontIndex),
      'Rejected parameters must preserve an existing record');
  finally
    G.Free;
  end;
end;

begin
  try
    Application.Initialize;
    RunTests;
    RunReviewRegressions;
    WriteLn('PASS: parameters, bounds, fonts, lifecycle, repaint and review regressions');
  except
    on E: Exception do begin
      WriteLn(StdErr, 'FAIL: ', E.ClassName, ': ', E.Message);
      Flush(StdErr);
      Halt(1);
    end;
  end;
end.
