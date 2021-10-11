unit mlbc;

interface

uses Forms, Classes, Dialogs, mlb2;

type
  TMlbc = class(TComponent)
  private
    _mlb: TMlb2;
    _filename: TFileName;
    FOnNotifyEvent: TNotifyEvent;
    function ReadMlb: TMlb2;
    function ReadCSVSeparator: string;
    procedure WriteCSVSeparator(c: string);
    function ReadQuoteSeparator: string;
    procedure WriteQuoteSeparator(c: string);
    function ReadDistinct: boolean;
    procedure WriteDistinct(b: boolean);
    function ReadBeginningOfFile: boolean;
    procedure WriteBeginningOfFile(b: boolean);
    function ReadEndOfFile: boolean;
    procedure WriteEndOfFile(b: boolean);

    function ReadFileName: TFileName;
    procedure WriteFileName(filename1: TFileName);

    function getName: string;
    procedure setName(name1: string);
    function FieldNameRead(index1: LongInt): string;
    procedure FieldNameWrite(index1: LongInt; v: string);
    function DataTypeRead(index1: LongInt): string;
    procedure DataTypeWrite(index1: LongInt; v: string);
    function AccessDataRead(field1, index1: LongInt): string;
  protected
  public
    property Mlb: TMlb2 read ReadMlb;
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    procedure Init;
    procedure Clear;
    procedure Assign(var mlb1: TMlb2);
    function GetVersion: String;
    function GetVersionNumber: Integer;
    property Name: string read getName write setName;

    function AddField(fieldname1: string): Boolean;
    function RemoveField(fieldname1: string): Boolean;
    property FieldName[index1: LongInt]: string read FieldNameRead write FieldNameWrite;
    property DataType[index1: LongInt]: string read DataTypeRead write DataTypeWrite;
    function FieldCount: LongInt;

    procedure AddRow;
    function InsertRow(where1: boolean): boolean;
    function RemoveRow: Boolean;
    function RemoveRowByIndex(k: LongInt): Boolean;
    function CopyRow: boolean;
    function PasteRow: boolean;
    function CopyRowBySlot(slot: integer): boolean;
    function PasteRowBySlot(slot: integer): boolean;

    function InitFieldWithData(fieldname1: string; data1: string): boolean;
    function InitFieldWithValue(fieldname1: string; value1: Extended): boolean;
    procedure ForceRows(nrows: LongInt);
    function RowCount: LongInt;

    function GetCurrentRow: LongInt;
    function IsEmpty: Boolean;

    function Go(row1: LongInt): Boolean;
    function GoFirst: Boolean;
    function GoLast: Boolean;
    function GoNext: Boolean;
    function GoPrevious: Boolean;
    function BeginSeek(direction1: boolean): Boolean;
    function EndSeek: Boolean;
    function SeekData(fieldname1, comp1, value1: string): boolean;
    function SeekFloat(fieldname1, comp1: string; value1: Extended): boolean;
    function MatchData(fieldname1, comp1, value1: string): boolean;
    function MatchFloat(fieldname1, comp1: string; value1: Extended): boolean;
    function SavePosition: boolean;
    function RestorePosition: boolean;
    function GetPosition: LongInt;

    function GetData(fieldname1: string): string;
    function SetData(fieldname1: string; data1: string): Boolean;
    function GetDataByIndex(index1: LongInt): string;
    function SetDataByIndex(index1: LongInt; data1: string): Boolean;
    function GetFloat(fieldname1: string): Extended;
    function SetFloat(fieldname1: string; float1: Extended): Boolean;
    function GetFloatByIndex(index1: LongInt): Extended;
    function SetFloatByIndex(index1: LongInt; float1: Extended): Boolean;
    function GetFieldName(index1: LongInt): string;
    function GetFieldIndex(fieldname1: string): LongInt;
    property AccessData[field1, index1: LongInt]: string read AccessDataRead;

    function LoadFromFile(filename1: string): Boolean;
    function LoadFromCSVFile(filename1: string): Boolean;
    function LoadFromISAMFile(filename1: string): Boolean;
    function LoadFromMLBFile(filename1: string): Boolean;

    function SaveCurrentFile: boolean;
    function SaveToFile(FileName1: string): boolean;
    function SaveToCSVFile(filename1: string): Boolean;
    function AppendToCSVFile(filename1: string): Boolean;
    function SaveToISAMFile(filename1: string): Boolean;
    function SaveToMLBFile(filename1: string): Boolean;
    function SaveToExcelFile(FileName1: string): boolean;

    function RobustStrToFloat(s1: string): Extended;
    function RobustFloatToStr(v1: Extended): string;
    function RangeSortByData(fieldname1: string; lowest2greatest1: boolean; from1, to1: LongInt): boolean;
    function RangeSortByFloat(fieldname1: string; lowest2greatest1: boolean; from1, to1: LongInt): boolean;
    function SortByData(fieldname1: string; lowest2greatest1: boolean): boolean;
    function SortByFloat(fieldname1: string; lowest2greatest1: boolean): boolean;
    procedure RandomSort;
    procedure MakeDistinct;
    function AreSameRows(k, l: LongInt): boolean;
    function Fusion(var dest_mlb, source_mlb: TMlb2; a1: TMlbFusionArray): boolean;
  published
    property CSVSeparator: string read ReadCSVSeparator write WriteCSVSeparator;
    property Distinct: boolean read ReadDistinct write WriteDistinct;
    property QuoteSeparator: string read ReadQuoteSeparator write WriteQuoteSeparator;
    property BeginningOfFile: boolean read ReadBeginningOfFile write WriteBeginningOfFile;
    property EndOfFile: boolean read ReadEndOfFile write WriteEndOfFile;

    property FileName: TFileName read ReadFileName write WriteFileName;
  end;

procedure Register;

implementation


Constructor TMlbc.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     _mlb := TMlb2.Create;
end;

Destructor TMlbc.Destroy;
begin
     _mlb.Free;
     inherited Destroy;
end;

function TMlbc.ReadMlb: TMlb2;
begin
     Result := _mlb;
end;

function TMlbc.ReadFileName: TFileName;
begin
     Result := _filename;
end;

procedure TMlbc.WriteFileName(filename1: TFileName);
begin
     if filename1<>'' then begin
        Mlb.LoadFromFile(filename1);
     end;
     _filename := filename1;
end;

function TMlbc.ReadCSVSeparator: string;
begin
     Result := Mlb.CSVSeparator;
end;

procedure TMlbc.WriteCSVSeparator(c: string);
begin
     Mlb.CSVSeparator := c;
end;

function TMlbc.ReadQuoteSeparator: string;
begin
     Result := Mlb.QuoteSeparator;
end;

procedure TMlbc.WriteQuoteSeparator(c: string);
begin
     Mlb.QuoteSeparator := c;
end;

function TMlbc.ReadDistinct: boolean;
begin
     Result := Mlb.Distinct;
end;

procedure TMlbc.WriteDistinct(b: boolean);
begin
     Mlb.Distinct := b;
end;

function TMlbc.ReadBeginningOfFile: boolean;
begin
     Result := Mlb.BeginningOfFile;
end;

procedure TMlbc.WriteBeginningOfFile(b: boolean);
begin
     Mlb.BeginningOfFile := b;
end;

function TMlbc.ReadEndOfFile: boolean;
begin
     Result := Mlb.EndOfFile;
end;

procedure TMlbc.WriteEndOfFile(b: boolean);
begin
     Mlb.EndOfFile := b;
end;

procedure TMlbc.Init;
begin
     Mlb.Init;
end;

procedure TMlbc.Clear;
begin
     Mlb.Clear;
end;

procedure TMlbc.Assign(var mlb1: TMlb2);
begin
     Mlb.Assign(mlb1);
end;

function TMlbc.GetVersion: String;
begin
     Result := Mlb.GetVersion;
end;

function TMlbc.GetVersionNumber: Integer;
begin
     Result := Mlb.GetVersionNumber;
end;

function TMlbc.getName: string;
begin
     Result := Mlb.Name;
end;

procedure TMlbc.setName(name1: string);
begin
     Mlb.Name := name1;
end;


function TMlbc.AddField(fieldname1: string): Boolean;
begin
     Result := Mlb.AddField(fieldname1);
end;

function TMlbc.RemoveField(fieldname1: string): Boolean;
begin
     Result := Mlb.RemoveField(fieldname1);
end;

function TMlbc.FieldNameRead(index1: LongInt): string;
begin
     Result := Mlb.FieldName[index1];
end;

procedure TMlbc.FieldNameWrite(index1: LongInt; v: string);
begin
     Mlb.FieldName[index1] := v;
end;

function TMlbc.DataTypeRead(index1: LongInt): string;
begin
     Result := Mlb.DataType[index1];
end;

procedure TMlbc.DataTypeWrite(index1: LongInt; v: string);
begin
     Mlb.DataType[index1] := v;
end;

function TMlbc.AccessDataRead(field1, index1: LongInt): string;
begin
     Result := Mlb.AccessData[field1, index1];
end;

function TMlbc.FieldCount: LongInt;
begin
     Result := Mlb.FieldCount;
end;

procedure TMlbc.AddRow;
begin
     Mlb.AddRow;
end;

function TMlbc.InsertRow(where1: boolean): boolean;
begin
     Result := Mlb.InsertRow(where1);
end;

function TMlbc.RemoveRow: Boolean;
begin
     Result := Mlb.RemoveRow;
end;

function TMlbc.RemoveRowByIndex(k: LongInt): Boolean;
begin
     Result := Mlb.RemoveRowByIndex(k);
end;

function TMlbc.CopyRow: boolean;
begin
     Result := Mlb.CopyRow;
end;

function TMlbc.PasteRow: boolean;
begin
     Result := Mlb.PasteRow;
end;

function TMlbc.CopyRowBySlot(slot: integer): boolean;
begin
     Result := Mlb.CopyRowBySlot(slot);
end;

function TMlbc.PasteRowBySlot(slot: integer): boolean;
begin
     Result := Mlb.PasteRowBySlot(slot);
end;

function TMlbc.InitFieldWithData(fieldname1: string; data1: string): boolean;
begin
     Result := Mlb.InitFieldWithData(fieldname1, data1);
end;

function TMlbc.InitFieldWithValue(fieldname1: string; value1: Extended): boolean;
begin
     Result := Mlb.InitFieldWithValue(fieldname1, value1);
end;

procedure TMlbc.ForceRows(nrows: LongInt);
begin
     Mlb.ForceRows(nrows);
end;

function TMlbc.RowCount: LongInt;
begin
     Result := Mlb.RowCount;
end;


function TMlbc.GetCurrentRow: LongInt;
begin
     Result := Mlb.GetCurrentRow;
end;

function TMlbc.IsEmpty: Boolean;
begin
     Result := Mlb.IsEmpty;
end;


function TMlbc.Go(row1: LongInt): Boolean;
begin
     Result := Mlb.Go(row1);
end;

function TMlbc.GoFirst: Boolean;
begin
     Result := Mlb.GoFirst;
end;

function TMlbc.GoLast: Boolean;
begin
     Result := Mlb.GoLast;
end;

function TMlbc.GoNext: Boolean;
begin
     Result := Mlb.GoNext;
end;

function TMlbc.GoPrevious: Boolean;
begin
     Result := Mlb.GoPrevious;
end;

function TMlbc.BeginSeek(direction1: boolean): Boolean;
begin
     Result := Mlb.BeginSeek(direction1);
end;

function TMlbc.EndSeek: Boolean;
begin
     Result := Mlb.EndSeek;
end;

function TMlbc.SeekData(fieldname1, comp1, value1: string): boolean;
begin
     Result := Mlb.SeekData(fieldname1, comp1, value1);
end;

function TMlbc.SeekFloat(fieldname1, comp1: string; value1: Extended): boolean;
begin
     Result := Mlb.SeekFloat(fieldname1, comp1, value1);
end;

function TMlbc.MatchData(fieldname1, comp1, value1: string): boolean;
begin
     Result := Mlb.MatchData(fieldname1, comp1, value1);
end;

function TMlbc.MatchFloat(fieldname1, comp1: string; value1: Extended): boolean;
begin
     Result := Mlb.MatchFloat(fieldname1, comp1, value1);
end;

function TMlbc.SavePosition: boolean;
begin
     Result := Mlb.SavePosition;
end;

function TMlbc.RestorePosition: boolean;
begin
     Result := Mlb.RestorePosition;
end;

function TMlbc.GetPosition: LongInt;
begin
     Result := Mlb.GetPosition;
end;

function TMlbc.GetData(fieldname1: string): string;
begin
     Result := Mlb.GetData(fieldname1);
end;

function TMlbc.SetData(fieldname1: string; data1: string): Boolean;
begin
     Result := Mlb.SetData(fieldname1, data1);
end;

function TMlbc.GetDataByIndex(index1: LongInt): string;
begin
     Result := Mlb.GetDataByIndex(index1);
end;

function TMlbc.SetDataByIndex(index1: LongInt; data1: string): Boolean;
begin
     Result := Mlb.SetDataByIndex(index1, data1);
end;

function TMlbc.GetFloat(fieldname1: string): Extended;
begin
     Result := Mlb.GetFloat(fieldname1);
end;

function TMlbc.SetFloat(fieldname1: string; float1: Extended): Boolean;
begin
     Result := Mlb.SetFloat(fieldname1, float1);
end;

function TMlbc.GetFloatByIndex(index1: LongInt): Extended;
begin
     Result := Mlb.GetFloatByIndex(index1);
end;

function TMlbc.SetFloatByIndex(index1: LongInt; float1: Extended): Boolean;
begin
     Result := Mlb.SetFloatByIndex(index1, float1);
end;

function TMlbc.GetFieldName(index1: LongInt): string;
begin
     Result := Mlb.GetFieldName(index1);
end;

function TMlbc.GetFieldIndex(fieldname1: string): LongInt;
begin
     Result := Mlb.GetFieldIndex(fieldname1);
end;

function TMlbc.LoadFromFile(filename1: string): Boolean;
begin
     Result := Mlb.LoadFromFile(filename1);
end;

function TMlbc.LoadFromCSVFile(filename1: string): Boolean;
begin
     Result := Mlb.LoadFromCSVFile(filename1);
end;

function TMlbc.LoadFromISAMFile(filename1: string): Boolean;
begin
     Result := Mlb.LoadFromISAMFile(filename1);
end;

function TMlbc.LoadFromMLBFile(filename1: string): Boolean;
begin
     Result := Mlb.LoadFromMLBFile(filename1);
end;

function TMlbc.SaveToFile(FileName1: string): boolean;
begin
     Result := Mlb.SaveToFile(filename1);
end;

function TMlbc.SaveToCSVFile(filename1: string): Boolean;
begin
     Result := Mlb.SaveToCSVFile(filename1);
end;

function TMlbc.SaveToISAMFile(filename1: string): Boolean;
begin
     Result := Mlb.SaveToISAMFile(filename1);
end;

function TMlbc.SaveToMLBFile(filename1: string): Boolean;
begin
     Result := Mlb.SaveToMLBFile(filename1);
end;

function TMlbc.SaveToExcelFile(FileName1: string): boolean;
begin
     Result := Mlb.SaveToExcelFile(filename1);
end;


function TMlbc.RobustStrToFloat(s1: string): Extended;
begin
     Result := Mlb.RobustStrToFloat(s1);
end;

function TMlbc.RobustFloatToStr(v1: Extended): string;
begin
     Result := Mlb.RobustFloatToStr(v1);
end;

function TMlbc.SortByData(fieldname1: string; lowest2greatest1: boolean): boolean;
begin
     Result := Mlb.SortByData(fieldname1, lowest2greatest1);
end;

function TMlbc.SortByFloat(fieldname1: string; lowest2greatest1: boolean): boolean;
begin
     Result := Mlb.SortByFloat(fieldname1, lowest2greatest1);
end;

procedure TMlbc.RandomSort;
begin
     Mlb.RandomSort;
end;

procedure TMlbc.MakeDistinct;
begin
     Mlb.MakeDistinct;
end;

function TMlbc.AreSameRows(k, l: LongInt): boolean;
begin
     Result := Mlb.AreSameRows(k, l);
end;

function TMlbc.Fusion(var dest_mlb, source_mlb: TMlb2; a1: TMlbFusionArray): boolean;
begin
     Result := Mlb.Fusion(dest_mlb, source_mlb, a1);
end;

function TMlbc.SaveCurrentFile: boolean;
begin
     if _filename<>'' then begin
         Result := SaveToFile(_filename);
     end else begin
         Result := false;
     end;
end;

function TMlbc.RangeSortByData(fieldname1: string; lowest2greatest1: boolean; from1, to1: LongInt): boolean;
begin
     Result := Mlb.RangeSortByData(fieldname1, lowest2greatest1, from1, to1);
end;

function TMlbc.RangeSortByFloat(fieldname1: string; lowest2greatest1: boolean; from1, to1: LongInt): boolean;
begin
     Result := Mlb.RangeSortByFloat(fieldname1, lowest2greatest1, from1, to1);
end;

function TMlbc.AppendToCSVFile(filename1: string): Boolean;
begin
     Result := Mlb.AppendToCSVFile(filename1);
end;

procedure Register;
begin
  RegisterComponents('Mlb', [TMlbc]);
end;

end.

