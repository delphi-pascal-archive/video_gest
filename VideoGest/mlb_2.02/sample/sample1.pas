unit Sample1;

interface

uses
  mlb2, Winprocs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    btnNext: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblTitle: TLabel;
    lblAuthor: TLabel;
    lblYear: TLabel;
    lblPrice: TLabel;
    btnLast: TButton;
    btnPrev: TButton;
    btnFirst: TButton;
    Edit1: TEdit;
    Button1: TButton;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure refreshData;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  Little: TMlb2;

implementation

{$R *.DFM}

procedure TForm1.refreshData;
begin
     lblTitle.Caption := Little.GetData('Title');
     lblAuthor.Caption := Little.GetData('Author');
     lblYear.Caption := IntToStr(trunc(Little.GetFloat('Year')));
     lblPrice.Caption := Little.GetData('Price');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Little := TMlb2.Create;
  {
  Little.Init;
  Little.AddField('Name');
  Little.AddField('FirstName');
  Little.AddField('Date of Birth');
  Little.AddRow;
  Little.SetData('Name', 'Durand');
  Little.SetData('FirstName', 'Paul');
  Little.SetData('Date of Birth', '02-02-63');
  Little.AddRow;
  Little.SetData('Name', 'Dupont');
  Little.SetData('FirstName', 'Yves');
  Little.SetData('Date of Birth', '10-09-61');
  Little.SaveToFile('date.txt');
  }
  Caption := Caption + ' - ' + Little.GetVersion;
  Little.LoadFromFile('sample.csv');
  Little.GoFirst;
  refreshData;
end;

procedure TForm1.btnNextClick(Sender: TObject);
begin
     Little.GoNext;
     refreshData;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     Little.Free;
end;

procedure TForm1.btnPrevClick(Sender: TObject);
begin
     Little.GoPrevious;
     refreshData;
end;

procedure TForm1.btnFirstClick(Sender: TObject);
begin
     Little.GoFirst;
     refreshData;
end;

procedure TForm1.btnLastClick(Sender: TObject);
begin
     Little.GoLast;
     refreshData;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     Little.GoNext;
     Little.SeekFloat('Price', '<', Little.RobustStrToFloat(Edit1.Text));
     refreshData;
end;

end.

