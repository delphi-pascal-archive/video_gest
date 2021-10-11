unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids;

type
  TForm2 = class(TForm)
    grille: TStringGrid;
    procedure grilleDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

uses Types;

{$R *.dfm}

procedure TForm2.grilleDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
Var L : TStringlist;
    n : integer;
begin
 if (ARow > 0) and (Acol > 0) then
  begin
   if (Arow mod 2) = 0 then Grille.Canvas.Brush.Color := $FFCCFF
                       else Grille.Canvas.Brush.Color := $FFFFFF;
  end;
 if (Arow > 0) and (Acol in [4,6]) then
  begin
   L := TstringList.Create;
   L.Text := grille.Cells[Acol,Arow];
   if l.Count > 1 then
    begin
     N := (Grille.Font.Height + 2) * L.Count + 4;
     if N > Grille.RowHeights[Arow] then
       Grille.RowHeights[Arow] := N;
    end else Grille.Canvas.FillRect(rect);
   n := 0;
   while N < L.Count do
    begin
     if N = 0 then Grille.Canvas.Brush.Style := bsSolid
              else Grille.Canvas.Brush.Style := bsClear;
     Grille.Canvas.TextRect(Rect,rect.Left + 2,rect.Top + 2 + N * (Grille.Font.Height + 2),L.Strings[N]);
     inc(N);
    end;
   L.Free;
  end;

 if (Arow > 0) and (Acol in [1..3,5]) then
  begin
   Grille.Canvas.Brush.Style := bsSolid;
   Grille.Canvas.TextRect(Rect,rect.Left + 2,rect.Top + 2,grille.Cells[Acol,Arow]);
  end;

 if gdFocused in State then
  begin
   Grille.Canvas.Brush.Style := bsClear;
   Grille.Canvas.Pen.Style := psdot;
   Grille.Canvas.Pen.color := clBlack;
   Grille.Canvas.Pen.width := 1;
   Grille.Canvas.Rectangle(rect);
   Grille.Canvas.Pen.Style := psSolid;
  end;
end;

end.
