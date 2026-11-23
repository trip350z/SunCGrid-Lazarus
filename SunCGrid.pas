{
===============================================================================
色・書式指定付きTStringGrid  TSunColGrid
                                      2000/01/31 SUNTEC Konagai
                                      2005/03/04 SUNTEC Toshima
                                      2009/06/26 SUNTEC Konagai
                                      2026/11/23 164 SYSTEMS
                                      Lazarus / LCL 移植・修正
-------------------------------------------------------------------------------
　以下のプロパティ／メソッドを追加。
    MultiLines: Boolean;
    CellMultiLines[Acol, ARow: integer]: Boolean;
    Layout: TTextLayout;
-------------------------------------------------------------------------------
===============================================================================
}
unit SunCGrid;
{$mode objfpc}{$H+}
{$codepage utf8}
interface
uses
  SysUtils, Classes, Types, Graphics, Controls,
  Grids, Math;
type
  TTextLayout = Graphics.TTextLayout;
  // 描画パラメータ レコード
  TCellDrawParams = record
    Col, Row: integer;
    Alignment: TAlignment;
    FontColor: TColor;
    FontWidth: integer;
    BackColor: TColor;
    BrushEnabled: boolean;
    BrushStyle: TBrushStyle;
    BrushColor: TColor;
    FontIndex: integer;
    MultiLine: Boolean;
    Layout: TTextLayout;
  end;
  // 描画パラメータ レコードのポインタ
  PCellDrawParams = ^TCellDrawParams;
  // コンポーネント定義
  TSunColGrid = class(TStringGrid)
  private
    FParamsList: TList;
    FFontList: TStringList;
    FAlignment: TAlignment;
    FFixedAlignment: TAlignment;
    FFocusDraw: boolean;
    FCacheCol, FCacheRow, FCacheIndex: integer; // 前回参照パラメータ位置
    FTowColors: boolean;
    FTowColorEven: TColor;
    FTowColorOdd: TColor;
    FFixedColFocus : boolean;
    FFixedColColor : TColor;
    FFixedColFontColor : TColor;
    FFixedRowFocus : boolean;
    FFixedRowColor : TColor;
    FFixedRowFontColor : TColor;
    FMultiLines: boolean;
    // ↓↓↓↓↓↓↓↓↓↓↓↓ 2009/06/26
    FLayout: TTextLayout;
    // ↑↑↑↑↑↑↑↑↑↑↑↑
    //FFixedRight: smallint;
    //FFixedBottom: smallint;
    FFocusColor: TColor;
    FFocusTextColor: TColor;
    procedure CheckColRowRange(ACol, ARow: integer);
    function GetFontCount: integer;
    function GetParamPointer(ACol, ARow: integer; AAlloc: boolean): PCellDrawParams;
    function GetCellAlignments(ACol, ARow: integer): TAlignment;
    procedure SetCellAlignments(ACol, ARow: integer; AValue: TAlignment);
    function GetCellFontColors(ACol, ARow: integer): TColor;
    procedure SetCellFontColors(ACol, ARow: integer; AValue: TColor);
    function GetCellFontWidths(ACol, ARow: integer): integer;
    procedure SetCellFontWidths(ACol, ARow: integer; AValue: integer);
    function GetCellColors(ACol, ARow: integer): TColor;
    procedure SetCellColors(ACol, ARow: integer; AValue: TColor);
    function GetCellBrushEnabled(ACol, ARow: integer): boolean;
    procedure SetCellBrushEnabled(ACol, ARow: integer; AValue: boolean);
    function GetCellBrushStyles(ACol, ARow: integer): TBrushStyle;
    procedure SetCellBrushStyles(ACol, ARow: integer; AValue: TBrushStyle);
    function GetCellBrushColors(ACol, ARow: integer): TColor;
    procedure SetCellBrushColors(ACol, ARow: integer; AValue: TColor);
    function GetCellFonts(ACol, ARow: integer): integer;
    procedure SetCellFonts(ACol, ARow: integer; AIndex: integer);
    function GetCellMultiLines(ACol, ARow: integer): boolean;
    procedure SetCellMultiLines(ACol, ARow: integer; Value: boolean);
    procedure SetLayout(Value: TTextLayout);
    procedure SetGridAlignment(Value: TAlignment);
    procedure SetGridFixedAlignment(Value: TAlignment);
    procedure SetGridFocusDraw(Value: Boolean);
    procedure SetGridMultiLines(Value: Boolean);
  protected
    procedure DrawCell(ACol, ARow: longint; ARect: TRect;
      AState: TGridDrawState); override;
    procedure FSetTowColors(Value:boolean);
    procedure FSetTowColorEven(Value:TColor);
    procedure FSetTowColorOdd(Value:TColor);
    procedure FSetFixedColFocus(Value:boolean);
    procedure FSetFixedColColor(Value:TColor);
    procedure FSetFixedColFontColor(Value:TColor);
    procedure FSetFixedRowFocus(Value:boolean);
    procedure FSetFixedRowColor(Value:TColor);
    procedure FSetFixedRowFontColor(Value:TColor);
    procedure FSetFocusColor(Value: TColor);
    procedure FSetFocusTextColor(Value: TColor);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // メソッド
    procedure ClearAllCellParams;
    function GetDefaultCellParams(ACol, ARow: integer): TCellDrawParams;
    function GetCellParams(ACol, ARow: integer): TCellDrawParams;
    procedure SetCellParams(AValue: TCellDrawParams);
    procedure ClearStings(ACol1, ARow1, ACol2, ARow2: integer);
    procedure AddFont(AFont: TFont);
    procedure DeleteFont(AIndex: integer);
    // 実行時プロパティ
    property FontCount: integer
      read GetFontCount;
    property CellAlignments[ACol, ARow: integer]: TAlignment
      read GetCellAlignments write SetCellAlignments;
    property CellFontColors[ACol, ARow: integer]: TColor
      read GetCellFontColors write SetCellFontColors;
    property CellFontWidths[ACol, ARow: integer]: integer
      read GetCellFontWidths write SetCellFontWidths;
    property CellColors[ACol, ARow: integer]: TColor
      read GetCellColors write SetCellColors;
    property CellBrushEnabled[ACol, ARow: integer]: boolean
      read GetCellBrushEnabled write SetCellBrushEnabled;
    property CellBrushStyles[ACol, ARow: integer]: TBrushStyle
      read GetCellBrushStyles write SetCellBrushStyles;
    property CellBrushColors[ACol, ARow: integer]: TColor
      read GetCellBrushColors write SetCellBrushColors;
    property CellFonts[ACol, ARow: integer]: integer
      read GetCellFonts write SetCellFonts;
    property CellMultiLines[ACol, ARow: integer]: boolean
      read GetCellMultiLines write SetCellMultiLines;
  published
    // 設計時プロパティ
    property Alignment: TAlignment
      read FAlignment write SetGridAlignment default taLeftJustify;
    property FixedAlignment: TAlignment
      read FFixedAlignment write SetGridFixedAlignment default taLeftJustify;
    property FocusDraw: boolean
      read FFocusDraw write SetGridFocusDraw default True;
    property TowColors: boolean
      read FTowColors write FSetTowColors default False;
    property TowColorOdd: TColor
      read FTowColorOdd write FSetTowColorOdd default clWhite;
    property TowColorEven: TColor
      read FTowColorEven write FSetTowColorEven default clWhite;
    property MultiLines: boolean
      read FMultiLines write SetGridMultiLines default False;
    // ↓↓↓↓↓↓↓↓↓↓↓↓ 2009/06/26
    property Layout: TTextLayout
      read FLayout write SetLayout default tlCenter;
    // ↑↑↑↑↑↑↑↑↑↑↑↑
    property FixedColFocus: boolean
      read FFixedColFocus write FSetFixedColFocus default False;
    property FixedColColor: TColor
      read FFixedColColor write FSetFixedColColor default clBtnFace;
    property FixedColFontColor: TColor
      read FFixedColFontColor write FSetFixedColFontColor default clHighlightText;
    property FixedRowFocus: boolean
      read FFixedRowFocus write FSetFixedRowFocus default False;
    property FixedRowColor: TColor
      read FFixedRowColor write FSetFixedRowColor default clBtnFace;
    property FixedRowFontColor: TColor
      read FFixedRowFontColor write FSetFixedRowFontColor default clHighlightText;
    property FocusColor: TColor
      read FFocusColor write FSetFocusColor default clHighlight;
    property FocusTextColor: TColor
      read FFocusTextColor write FSetFocusTextColor default clHighlightText;
    //property FixedRight: SmallInt
      //read FFixedRight write FFixedRight default 0;
    //property FixedBottom: SmallInt
      //read FFixedBottom write FFixedBottom default 0;
  end;
procedure Register;
implementation
procedure Register;
begin
  RegisterComponents('164SYSTEMS', [TSunColGrid]);
end;
//-----------------------------------------------------------------------------
// コンストラクタ
//-----------------------------------------------------------------------------
constructor TSunColGrid.Create(AOwner: TComponent);
begin
  inherited;
  DefaultDrawing 	:= False;
  FAlignment 		:= taLeftJustify;
  FFixedAlignment       := taLeftJustify;
  FFocusDraw 		:= True;
  FTowColors 		:= False;
  FTowColorEven		:= clWhite;
  FTowColorOdd		:= clWhite;
  FFixedColFocus	:= False;
  FFixedColColor	:= clBtnFace;
  FFixedColFontColor	:= clHighlightText;
  FFixedRowFocus	:= False;
  FFixedRowColor	:= clBtnFace;
  FFixedRowFontColor	:= clHighlightText;
  FMultiLines     := False;
  FLayout         := tlCenter;
  FFocusColor     := clHighlight;
  FFocusTextColor := clHighlightText;
  FParamsList := TList.Create;
  FFontList := TStringList.Create;
  FCacheCol := -1;
  FCacheRow := -1;
  FCacheIndex := -1;
end;
//-----------------------------------------------------------------------------
// デストラクタ
//-----------------------------------------------------------------------------
destructor TSunColGrid.Destroy;
var
  I: Integer;
begin
  if Assigned(FParamsList) then begin
    ClearAllCellParams;
    FreeAndNil(FParamsList);
  end;
  if Assigned(FFontList) then begin
    for I := 0 to FFontList.Count - 1 do
      TFont(FFontList.Objects[I]).Free;
    FreeAndNil(FFontList);
  end;
  inherited Destroy;
end;
//-----------------------------------------------------------------------------
// 全パラメータ削除
//-----------------------------------------------------------------------------
procedure TSunColGrid.ClearAllCellParams;
var
  i, j, c1, c2: integer;
  ColParam: TList;
  pPrm: PCellDrawParams;
begin
  if FParamsList = nil then Exit;
  c1 := FParamsList.Count;
  for i := 1 to c1 do begin
    ColParam := TList(FParamsList.Items[i - 1]);
    c2 := ColParam.Count;
    for j := 1 to c2 do begin
      pPrm := ColParam.Items[j - 1];
      FreeMem(pPrm, sizeof(TCellDrawParams));
    end;
    ColParam.Free;
  end;
  FParamsList.Clear;
  FCacheCol := -1;
  FCacheRow := -1;
  FCacheIndex := -1;
  if not (csDestroying in ComponentState) then Invalidate;
end;
//-----------------------------------------------------------------------------
// デフォルトパラメータ取得
//-----------------------------------------------------------------------------
function TSunColGrid.GetDefaultCellParams(ACol, ARow: integer): TCellDrawParams;
begin
  with Result do begin
    Col := ACol;
    Row := ARow;
    FontColor := Font.Color;
    FontWidth := 1;
    if (ACol < FixedCols) or ((ARow < FixedRows) and (ARow>-1)) then begin
      BackColor := FixedColor;
      Alignment := FixedAlignment;
    end else begin
      BackColor := Self.Color;
      Alignment := FAlignment;
    end;
    BrushEnabled := False;
    BrushStyle := bsClear;
    BrushColor := Self.Color;
    FontIndex := -1;
    MultiLine := FMultiLines;
    Layout    := FLayout;
  end;
end;
//-----------------------------------------------------------------------------
// パラメータ位置取得、確保
//-----------------------------------------------------------------------------
function TSunColGrid.GetParamPointer(ACol, ARow: integer; AAlloc: boolean): PCellDrawParams;
var
  i, n: integer;
  pPrm: PCellDrawParams;
  ColParam: TList;
begin
  // パラメータリスト追加
  if ColCount > FParamsList.Count then begin
    n := FParamsList.Count;
    for i := n to ColCount - 1 do begin
      ColParam := TList.Create;
      FParamsList.Add(pointer(ColParam));
    end;
  end;
  ColParam := TList(FParamsList[ACol]);
  // キャッシュと同じなら一発で呼び出し
  if (FCacheCol = ACol) and (FCacheRow = ARow) then begin
    Result := ColParam.Items[FCacheIndex];
    exit;
  end else begin
  // キャッシュと違ったら検索
    for i := 0 to (ColParam.Count - 1) do begin
      pPrm := ColParam.Items[i];
      if pPrm^.Row = ARow then begin
        Result := pPrm;
        FCacheCol := ACol;
        FCacheRow := ARow;
        FCacheIndex := i;
        exit;
      end;
    end;
  end;
  // 見つからない時
  // メモリ確保
  if AAlloc then begin
    GetMem(pPrm, sizeof(TCellDrawParams));
    pPrm^ := GetDefaultCellParams(ACol, ARow);
    ColParam.Add(pPrm);
    FCacheCol := ACol;
    FCacheRow := ARow;
    FCacheIndex := ColParam.Count - 1;
    if FCacheIndex < 0 then FCacheIndex := 0;
  end else begin
	  // メモリ不用
    pPrm := nil;
  end;
  Result := pPrm;
end;
//-----------------------------------------------------------------------------
// パラメータ一括取得用
//-----------------------------------------------------------------------------
function TSunColGrid.GetCellParams(ACol, ARow: integer): TCellDrawParams;
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ位置取得
  pPrm := GetParamPointer(ACol, ARow, False);
  if pPrm = nil then
    Result := GetDefaultCellParams(ACol, ARow)
  else
    Result := pPrm^;
end;
//-----------------------------------------------------------------------------
// パラメータ一括設定用
//-----------------------------------------------------------------------------
procedure TSunColGrid.SetCellParams(AValue: TCellDrawParams);
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(AValue.Col, AValue.Row);
  // Validate before allocation so rejected input cannot override column defaults.
  if (AValue.FontIndex < -1) or (AValue.FontIndex >= FFontList.Count) then
    raise ERangeError.Create('Font index out of range');
  pPrm := GetParamPointer(AValue.Col, AValue.Row, True);
  pPrm^ := AValue;
  Invalidate;
end;
//-----------------------------------------------------------------------------
// 指定範囲文字削除
//-----------------------------------------------------------------------------
procedure TSunColGrid.ClearStings(ACol1, ARow1, ACol2, ARow2: integer);
var
  i, j: integer;
begin
  for i := ACol1 to ACol2 do begin
    for j := ARow1 to ARow2 do begin
      CheckColRowRange(i,j);
      Cells[i,j] := '';
    end;
  end;
//  FCacheCol := -1;
//  FCacheRow := -1;
end;
//-----------------------------------------------------------------------------
// フォント追加
//-----------------------------------------------------------------------------
procedure TSunColGrid.AddFont(AFont: TFont);
var
  f: TFont;
begin
  f := TFont.Create;
  f.Assign(AFont);
  FFontList.AddObject('0', f);
end;
//-----------------------------------------------------------------------------
// フォント削除
//-----------------------------------------------------------------------------
procedure TSunColGrid.DeleteFont(AIndex: integer);
var
  C, R: Integer;
  L: TList;
  P: PCellDrawParams;
begin
  if (AIndex < 0) or (AIndex >= FFontList.Count) then
    raise ERangeError.Create('Font index out of range');
  for C := 0 to FParamsList.Count - 1 do begin
    L := TList(FParamsList[C]);
    for R := 0 to L.Count - 1 do
      if PCellDrawParams(L[R])^.FontIndex = AIndex then
        raise Exception.Create('Font is still in use');
  end;
  TFont(FFontList.Objects[AIndex]).Free;
  FFontList.Delete(AIndex);
  for C := 0 to FParamsList.Count - 1 do begin
    L := TList(FParamsList[C]);
    for R := 0 to L.Count - 1 do begin
      P := PCellDrawParams(L[R]);
      if P^.FontIndex > AIndex then Dec(P^.FontIndex);
    end;
  end;
  Invalidate;
end;
//-----------------------------------------------------------------------------
// 列行位置判定
//-----------------------------------------------------------------------------
procedure TSunColGrid.CheckColRowRange(ACol, ARow: integer);
begin
  if (ACol < 0) or (ARow < -1) or (ACol >= ColCount) or (ARow >= RowCount) then begin
    raise ERangeError.Create('ｾﾙ位置がｸﾞﾘｯﾄﾞの範囲を超えました。');
  end;
end;
//-----------------------------------------------------------------------------
// プロパティ：フォント数読み出し
//-----------------------------------------------------------------------------
function TSunColGrid.GetFontCount: integer;
begin
  Result := FFontList.Count;
end;
//-----------------------------------------------------------------------------
// プロパティ：文字列表示位置読み出し
//-----------------------------------------------------------------------------
function TSunColGrid.GetCellAlignments(ACol, ARow: integer): TAlignment;
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ位置取得
  pPrm := GetParamPointer(ACol, ARow, False);
  if (pPrm = nil) and (ARow>= FixedRows) then pPrm := GetParamPointer(ACol, -1, False);
  if pPrm = nil then
    Result := GetDefaultCellParams(ACol, ARow).Alignment
  else
    Result := pPrm^.Alignment;
end;
//-----------------------------------------------------------------------------
// プロパティ：文字列表示位置設定
//-----------------------------------------------------------------------------
procedure TSunColGrid.SetCellAlignments(ACol, ARow: integer; AValue: TAlignment);
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ書き込み位置取得
  pPrm := GetParamPointer(ACol, ARow, True);
  pPrm^.Alignment := AValue;
  Invalidate;
end;
//-----------------------------------------------------------------------------
// プロパティ：フォント色読み出し
//-----------------------------------------------------------------------------
function TSunColGrid.GetCellFontColors(ACol, ARow: integer): TColor;
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ位置取得
  pPrm := GetParamPointer(ACol, ARow, False);
  if (pPrm = nil) and (ARow>= FixedRows) then pPrm := GetParamPointer(ACol, -1, False);
  if pPrm = nil then
    Result := Font.Color
  else
    Result := pPrm^.FontColor;
end;
//-----------------------------------------------------------------------------
// プロパティ：フォント色設定
//-----------------------------------------------------------------------------
procedure TSunColGrid.SetCellFontColors(ACol, ARow: integer; AValue: TColor);
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ書き込み位置取得
  pPrm := GetParamPointer(ACol, ARow, True);
  pPrm^.FontColor := AValue;
  Invalidate;
end;
//-----------------------------------------------------------------------------
// プロパティ：フォント幅読み出し
//-----------------------------------------------------------------------------
function TSunColGrid.GetCellFontWidths(ACol, ARow: integer): integer;
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ位置取得
  pPrm := GetParamPointer(ACol, ARow, False);
  if (pPrm = nil) and (ARow>= FixedRows) then pPrm := GetParamPointer(ACol, -1, False);
  if pPrm = nil then
    Result := 1
  else
    Result := pPrm^.FontWidth;
end;
//-----------------------------------------------------------------------------
// プロパティ：フォント幅設定
//-----------------------------------------------------------------------------
procedure TSunColGrid.SetCellFontWidths(ACol, ARow: integer; AValue: integer);
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ書き込み位置取得
  pPrm := GetParamPointer(ACol, ARow, True);
  pPrm^.FontWidth := AValue;
  Invalidate;
end;
//-----------------------------------------------------------------------------
// プロパティ：セル色読み出し
//-----------------------------------------------------------------------------
function TSunColGrid.GetCellColors(ACol, ARow: integer): TColor;
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ位置取得
  pPrm := GetParamPointer(ACol, ARow, False);
  if (pPrm = nil) and (ARow>= FixedRows) then pPrm := GetParamPointer(ACol, -1, False);
  if pPrm = nil then
    Result := GetDefaultCellParams(ACol, ARow).BackColor
  else
    Result := pPrm^.BackColor;
end;
//-----------------------------------------------------------------------------
// プロパティ：セル色設定
//-----------------------------------------------------------------------------
procedure TSunColGrid.SetCellColors(ACol, ARow: integer; AValue: TColor);
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ書き込み位置取得
  pPrm := GetParamPointer(ACol, ARow, True);
  pPrm^.BackColor := AValue;
  Invalidate;
end;
//-----------------------------------------------------------------------------
// プロパティ：セルブラシ使用可／不可読み出し
//-----------------------------------------------------------------------------
function TSunColGrid.GetCellBrushEnabled(ACol, ARow: integer): boolean;
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ位置取得
  pPrm := GetParamPointer(ACol, ARow, False);
  if (pPrm = nil) and (ARow>= FixedRows) then pPrm := GetParamPointer(ACol, -1, False);
  if pPrm = nil then
    Result := False
  else
    Result := pPrm^.BrushEnabled;
end;
//-----------------------------------------------------------------------------
// プロパティ：セルブラシ使用可／不可設定
//-----------------------------------------------------------------------------
procedure TSunColGrid.SetCellBrushEnabled(ACol, ARow: integer; AValue: boolean);
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ書き込み位置取得
  pPrm := GetParamPointer(ACol, ARow, True);
  pPrm^.BrushEnabled := AValue;
  Invalidate;
end;
//-----------------------------------------------------------------------------
// プロパティ：セルブラシスタイル読み出し
//-----------------------------------------------------------------------------
function TSunColGrid.GetCellBrushStyles(ACol, ARow: integer): TBrushStyle;
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ位置取得
  pPrm := GetParamPointer(ACol, ARow, False);
  if (pPrm = nil) and (ARow>= FixedRows) then pPrm := GetParamPointer(ACol, -1, False);
  if pPrm = nil then
    Result := bsClear
  else
    Result := pPrm^.BrushStyle;
end;
//-----------------------------------------------------------------------------
// プロパティ：セルブラシスタイル設定
//-----------------------------------------------------------------------------
procedure TSunColGrid.SetCellBrushStyles(ACol, ARow: integer; AValue: TBrushStyle);
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ書き込み位置取得
  pPrm := GetParamPointer(ACol, ARow, True);
  pPrm^.BrushStyle := AValue;
  Invalidate;
end;
//-----------------------------------------------------------------------------
// プロパティ：セルブラシ色読み出し
//-----------------------------------------------------------------------------
function TSunColGrid.GetCellBrushColors(ACol, ARow: integer): TColor;
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ位置取得
  pPrm := GetParamPointer(ACol, ARow, False);
  if (pPrm = nil) and (ARow>= FixedRows) then pPrm := GetParamPointer(ACol, -1, False);
  if pPrm = nil then
    Result := Color
  else
    Result := pPrm^.BrushColor;
end;
//-----------------------------------------------------------------------------
// プロパティ：セルブラシ色設定
//-----------------------------------------------------------------------------
procedure TSunColGrid.SetCellBrushColors(ACol, ARow: integer; AValue: TColor);
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ書き込み位置取得
  pPrm := GetParamPointer(ACol, ARow, True);
  pPrm^.BrushColor := AValue;
  Invalidate;
end;
//-----------------------------------------------------------------------------
// プロパティ：セルフォント番号読み出し
//-----------------------------------------------------------------------------
function TSunColGrid.GetCellFonts(ACol, ARow: integer): integer;
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ位置取得
  pPrm := GetParamPointer(ACol, ARow, False);
  if (pPrm = nil) and (ARow>= FixedRows) then pPrm := GetParamPointer(ACol, -1, False);
  if pPrm = nil then
    Result := -1
  else
    Result := pPrm^.FontIndex;
end;
//-----------------------------------------------------------------------------
// プロパティ：セルフォント番号設定
//-----------------------------------------------------------------------------
procedure TSunColGrid.SetCellFonts(ACol, ARow: integer; AIndex: integer);
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  if (AIndex < -1) or (AIndex >= FFontList.Count) then
    raise ERangeError.Create('ｲﾝﾃﾞｯｸｽが範囲を超えました。');
  // パラメータ書き込み位置取得
  pPrm := GetParamPointer(ACol, ARow, True);
  pPrm^.FontIndex := AIndex;
  if AIndex = -1 then
    pPrm^.FontColor := Font.Color
  else
    pPrm^.FontColor := TFont(FFontList.Objects[AIndex]).Color;
  Invalidate;
end;
//-----------------------------------------------------------------------------
// セル描画処理
//-----------------------------------------------------------------------------
procedure TSunColGrid.DrawCell(ACol, ARow: longint; ARect: TRect;
  AState: TGridDrawState);
var
  P: PCellDrawParams;
  Params: TCellDrawParams;
  Style: TTextStyle;
  R, TextBounds: TRect;
  I, Padding: Integer;
  SavedPen: TPen;
  SavedBrush: TBrush;
  SavedFont: TFont;
begin
  if DefaultDrawing or (FParamsList = nil) then begin
    inherited DrawCell(ACol, ARow, ARect, AState);
    Exit;
  end;
  P := GetParamPointer(ACol, ARow, False);
  if (P = nil) and (ARow >= FixedRows) then
    P := GetParamPointer(ACol, -1, False);
  if P = nil then Params := GetDefaultCellParams(ACol, ARow)
  else Params := P^;
  SavedPen := TPen.Create;
  SavedBrush := TBrush.Create;
  SavedFont := TFont.Create;
  try
    SavedPen.Assign(Canvas.Pen);
    SavedBrush.Assign(Canvas.Brush);
    SavedFont.Assign(Canvas.Font);
    Canvas.Font.Assign(Font);
    if (Params.FontIndex >= 0) and (Params.FontIndex < FFontList.Count) then
      Canvas.Font.Assign(TFont(FFontList.Objects[Params.FontIndex]));
    Canvas.Font.Color := Params.FontColor;
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := Params.BackColor;
    if gdFixed in AState then begin
      Canvas.Brush.Color := FixedColor;
      if FixedColFocus and (ARow < FixedRows) and
        (((ACol >= Selection.Left) and (ACol <= Selection.Right)) or (ACol = Col)) then begin
        Canvas.Brush.Color := FixedColColor;
        Canvas.Font.Color := FixedColFontColor;
      end;
      if FixedRowFocus and (ACol < FixedCols) and
        (((ARow >= Selection.Top) and (ARow <= Selection.Bottom)) or (ARow = Row)) then begin
        Canvas.Brush.Color := FixedRowColor;
        Canvas.Font.Color := FixedRowFontColor;
      end;
    end else if (gdSelected in AState) and (Focused or FocusDraw) then begin
      Canvas.Brush.Color := FocusColor;
      Canvas.Font.Color := FocusTextColor;
    end else if TowColors and (Params.BackColor = Color) then begin
      if Odd(ARow) then Canvas.Brush.Color := TowColorOdd
      else Canvas.Brush.Color := TowColorEven;
    end;
    Canvas.FillRect(ARect);
    if Params.BrushEnabled and not (gdSelected in AState) then begin
      Canvas.Brush.Style := Params.BrushStyle;
      Canvas.Brush.Color := Params.BrushColor;
      Canvas.FillRect(ARect);
    end;
    Style := Canvas.TextStyle;
    Style.Alignment := Params.Alignment;
    Style.Layout := Params.Layout;
    Style.SingleLine := not Params.MultiLine;
    Style.Wordbreak := Params.MultiLine;
    Style.Clipping := True;
    Style.ShowPrefix := False;
    Style.Opaque := False;
    Style.SystemFont := False;
    R := ARect;
    // Cell geometry follows the widget set; scale only our own padding.
    Padding := Max(1, (2 * Font.PixelsPerInch + 48) div 96);
    InflateRect(R, -Padding, -Padding);
    Canvas.Brush.Style := bsClear;
    if (R.Right > R.Left) and (R.Bottom > R.Top) then
      for I := 0 to Max(1, Params.FontWidth) - 1 do begin
        TextBounds := R;
        // TextRect uses the rectangle for centered/right-aligned text too.
        OffsetRect(TextBounds, I, 0);
        Canvas.TextRect(TextBounds, TextBounds.Left, TextBounds.Top,
          Cells[ACol, ARow], Style);
      end;
    // Let LCL apply grid line options and widget-independent border handling.
    DrawCellGrid(ACol, ARow, ARect, AState);
    if Focused and (gdFocused in AState) then Canvas.DrawFocusRect(ARect);
    if Assigned(OnDrawCell) then
      OnDrawCell(Self, ACol, ARow, ARect, AState);
  finally
    Canvas.Pen.Assign(SavedPen);
    Canvas.Brush.Assign(SavedBrush);
    Canvas.Font.Assign(SavedFont);
    SavedPen.Free;
    SavedBrush.Free;
    SavedFont.Free;
  end;
end;
procedure TSunColGrid.FSetTowColors(Value: boolean);
begin
  if FTowColors <> Value then
  begin
    FTowColors := Value;
    Invalidate;
  end;
end;
procedure TSunColGrid.FSetTowColorEven(Value: TColor);
begin
  if FTowColorEven <> Value then
  begin
    FTowColorEven := Value;
    if FTowColors then begin
      Invalidate;
    end;
  end;
end;
procedure TSunColGrid.FSetTowColorOdd(Value: TColor);
begin
  if FTowColorOdd <> Value then
  begin
    FTowColorOdd := Value;
    if FTowColors then begin
      Invalidate;
    end;
  end;
end;
procedure TSunColGrid.FSetFixedColColor(Value: TColor);
begin
  if FFixedColColor <> Value then
  begin
    FFixedColColor := Value;
    if FixedColFocus then begin
      Invalidate;
    end;
  end;
end;
procedure TSunColGrid.FSetFixedColFontColor(Value: TColor);
begin
  if FFixedColFontColor <> Value then
  begin
    FFixedColFontColor := Value;
    if FixedColFocus then begin
      Invalidate;
    end;
  end;
end;
procedure TSunColGrid.FSetFixedColFocus(Value: boolean);
begin
  if FFixedColFocus <> Value then
  begin
    FFixedColFocus := Value;
    Invalidate;
  end;
end;
procedure TSunColGrid.FSetFixedRowColor(Value: TColor);
begin
  if FFixedRowColor <> Value then
  begin
    FFixedRowColor := Value;
    if FixedRowFocus then begin
      Invalidate;
    end;
  end;
end;
procedure TSunColGrid.FSetFixedRowFontColor(Value: TColor);
begin
  if FFixedRowFontColor <> Value then
  begin
    FFixedRowFontColor := Value;
    if FixedRowFocus then begin
      Invalidate;
    end;
  end;
end;
procedure TSunColGrid.FSetFixedRowFocus(Value: boolean);
begin
  if FFixedRowFocus <> Value then
  begin
    FFixedRowFocus := Value;
    Invalidate;
  end;
end;
function TSunColGrid.GetCellMultiLines(ACol, ARow: integer): boolean;
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ位置取得
  pPrm := GetParamPointer(ACol, ARow, False);
  if (pPrm = nil) and (ARow >= FixedRows) then
    pPrm := GetParamPointer(ACol, -1, False);
  if pPrm = nil then
    Result := FMultiLines
  else
    Result := pPrm^.MultiLine;
end;
procedure TSunColGrid.SetCellMultiLines(ACol, ARow: integer;
  Value: boolean);
var
  pPrm: PCellDrawParams;
begin
  CheckColRowRange(ACol, ARow);
  // パラメータ書き込み位置取得
  pPrm := GetParamPointer(ACol, ARow, True);
  pPrm^.MultiLine := Value;
  Invalidate;
end;
procedure TSunColGrid.FSetFocusColor(Value: TColor);
begin
  if FFocusColor <> Value then
  begin
    FFocusColor := Value;
    Invalidate;
  end;
end;
procedure TSunColGrid.FSetFocusTextColor(Value: TColor);
begin
  if FFocusTextColor <> Value then
  begin
    FFocusTextColor := Value;
    Invalidate;
  end;
end;
procedure TSunColGrid.SetGridAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TSunColGrid.SetGridFixedAlignment(Value: TAlignment);
begin
  if FFixedAlignment <> Value then begin
    FFixedAlignment := Value;
    Invalidate;
  end;
end;

procedure TSunColGrid.SetGridFocusDraw(Value: Boolean);
begin
  if FFocusDraw <> Value then begin
    FFocusDraw := Value;
    Invalidate;
  end;
end;

procedure TSunColGrid.SetGridMultiLines(Value: Boolean);
begin
  if FMultiLines <> Value then begin
    FMultiLines := Value;
    Invalidate;
  end;
end;

procedure TSunColGrid.SetLayout(Value: TTextLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;
end.
