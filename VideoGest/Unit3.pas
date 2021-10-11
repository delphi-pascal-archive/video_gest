unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TForm3 = class(TForm)
    MonthCalendar1: TMonthCalendar;
    procedure MonthCalendar1DblClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.MonthCalendar1DblClick(Sender: TObject);
begin
 modalresult := mrOk;
end;

end.
