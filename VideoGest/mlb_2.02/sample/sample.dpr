program Sample;

uses
  Forms,
  Sample1 in 'SAMPLE1.PAS' {Form1},
  mlb2 in '..\OBJECT\MLB2.PAS';

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
