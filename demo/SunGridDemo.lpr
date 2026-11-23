program SunGridDemo;
{$mode objfpc}{$H+}
{$codepage utf8}
uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  Interfaces, Forms, Classes, Graphics, Controls, Grids, SunCGrid;
type
  TDemoForm = class(TForm)
    constructor Create(AOwner: TComponent); override;
  end;
constructor TDemoForm.Create(AOwner: TComponent);
var G: TSunColGrid; F: TFont; C, R: Integer;
begin
  inherited CreateNew(AOwner);
  Caption := 'SunColGrid LCL demo';
  SetBounds(100, 100, 760, 420);
  G := TSunColGrid.Create(Self);
  G.Parent := Self;
  G.Align := alClient;
  G.ColCount := 5;
  G.RowCount := 8;
  G.DefaultColWidth := 140;
  G.DefaultRowHeight := 44;
  G.TowColors := True;
  G.TowColorEven := $00F0F8FF;
  G.FixedColFocus := True;
  G.FixedRowFocus := True;
  G.Options := G.Options + [goEditing, goDrawFocusSelected];
  for C := 1 to 4 do G.Cells[C, 0] := 'Column ' + Chr(Ord('A') + C - 1);
  for R := 1 to 7 do begin
    G.Cells[0, R] := 'Row ' + Chr(Ord('0') + R);
    for C := 1 to 4 do G.Cells[C, R] := '日本語テスト';
  end;
  G.CellAlignments[2, -1] := taCenter;
  G.CellAlignments[3, -1] := taRightJustify;
  G.CellColors[1, 2] := clYellow;
  G.CellMultiLines[2, 2] := True;
  G.Cells[2, 2] := '複数行' + LineEnding + '表示';
  F := TFont.Create;
  try
    F.Assign(G.Font);
    F.Style := [fsBold];
    F.Color := clRed;
    G.AddFont(F);
  finally
    F.Free;
  end;
  G.CellFonts[3, 3] := 0;
  G.Cells[4, 2] := 'A&B / 日本語';
  G.CellMultiLines[4, 3] := True;
  G.Cells[4, 3] := '幅に応じて折り返される長い日本語の文字列です';
  G.CellBrushEnabled[1, 4] := True;
  G.CellBrushStyles[1, 4] := bsDiagCross;
  G.CellBrushColors[1, 4] := clGray;
end;
var MainForm: TDemoForm;
begin
  Application.Initialize;
  Application.CreateForm(TDemoForm, MainForm);
  Application.Run;
end.
