(*******************************************************************
MY LITTLE BASE 2.0.0 Experimantal mono-table little sql delphi source code
CopyRights owned by S.A.R.L ANIROM Multimedia Marseille FRANCE
http://www.anirom.com
MLB official website is http://www.mylittlebase.org

This source code is Freeware
You can copy it and use it freely for any purpose (even commercial)
but you must add in the about box of your program that it uses
MyLittleBase source code (http://www.mylittlebase.org)
You can freely distribute this unmodified source code containing
this copyright notice
You can modify it for your own purposes, but you cannot distribute
the modified code as mylittlebase without the written consent from ANIROM
You can write external modules using this unmodified source code
and distribute them

ANIROM Multimedia assumes no liability of any kind
use this code at your own risks or do not use it
*******************************************************************)
unit mlb2sql;

interface

uses mlb2;

type
  TMlb2Sql = class(TObject)
  private
         base: TMlb2;
         dynaset: TMlb2;
         complement: TMlb2;
         sql_string: string;
         sql_index: integer;
         concorde: TConcordances;
         
         function ReadToken: string;
         function ReadOperator: string;
         function IsOperator(c: char): boolean;
         function IsSeparator(c: char): boolean;
         procedure Recalage;
         function CharAt(k: integer): char;
         function ReachedEnd: boolean;
	 function IsString(v1: String): boolean;
	 function sansel(s1: String): string;
         function FloatValue(v1: String): Extended;
         function expression: boolean;
         function terme: boolean;
         function facteur: boolean;
  public
        constructor Create(m: TMlb2);
        destructor Destroy; override;
        function MySubString(source1: string; bindex, eindex: integer): string;
        function Execute(sql1: String): boolean;
        function GetDynaset: TMlb2;
        function GetComplement: TMlb2;
  end;

implementation

function TMlb2Sql.GetDynaset: TMlb2;
begin
     Result := Dynaset;
end;

function TMlb2Sql.GetComplement: TMlb2;
begin
     Result := Complement;
end;

function TMlb2Sql.expression: boolean;
var b1, b2: boolean;
    op: String;
begin
    b1 := false;
    b2 := false;
    if (ReachedEnd) then begin
    end else begin
            b1 := terme;
            Recalage;
            op := ReadToken;
            if (op= 'OR') then begin
                    b2 := expression;
            end else if (op=')') then begin
                    b2 := false;
            end else begin
                    b2 := false;
            end;
    end;
    Result := b1 or b2;
end;

function TMlb2Sql.terme: boolean;
var k: integer;
    b1, b2: boolean;
    op: String;
begin
    b1 := false;
    b2 := false;
    if (ReachedEnd) then begin
       Result := True;
       Exit;
    end else begin
            b1 := facteur;
            Recalage;
            k := sql_index;
            op := ReadToken;
            if (op = 'AND') then begin
                b2 := terme;
            end else begin
                sql_index := k;
                b2 := true;
            end;
    end;
    Result := (b1 and b2);
end;

function TMlb2Sql.facteur: boolean;
var SAtom, VAtom, myatom, myvalue, myop: String;
    myfatom, myfvalue: Extended;
    b: boolean;
begin
    b := false;
    myatom := ReadToken;
    Recalage;
    if (myatom='(') then begin
            b := expression;
    end else begin
            myop := ReadOperator;
            Recalage;
            myvalue := ReadToken;
            Recalage;
            if (IsString(myvalue)) then begin
                    SAtom := base.GetData(myatom);
                    VAtom := sansel(myvalue);
                    if (myop='=') then begin
                            b := SAtom = VAtom;
                    end else if (myop ='<=') then begin
                            b := SAtom <= VAtom;
                    end else if (myop ='>=') then begin
                            b := SAtom >= VAtom;
                    end else if (myop ='<') then begin
                            b := SAtom < VAtom;
                    end else if (myop ='>') then begin
                            b := SAtom > VAtom;
                    end else if (myop ='<>') then begin
                            b := SAtom <> VAtom;
                    end else if (myop ='~=') then begin
                            concorde.case_matching := False;
                            concorde.space_matching := False;
                            concorde.like_matching := True;
                            b := concorde.SI_VERIFICATION(VAtom, SAtom);
                    end else begin
                    end;
            end else begin
                    myfvalue := FloatValue(myvalue);
                    myfatom := FloatValue(base.GetData(myatom));
                    if (myop='=') then begin
                            b := (myfatom = myfvalue);
                    end else if (myop ='<=') then begin
                            b := (myfatom <= myfvalue);
                    end else if (myop ='>=') then begin
                            b := (myfatom >= myfvalue);
                    end else if (myop ='<') then begin
                            b := (myfatom < myfvalue);
                    end else if (myop ='>') then begin
                            b := (myfatom > myfvalue);
                    end else if (myop ='<>') then begin
                            b := (myfatom <> myfvalue);
                    end else if (myop ='~=') then begin
                    end else begin
                    end;
            end;
    end;
    Result := b;
end;

function TMlb2Sql.Execute(sql1: String): boolean;
var i: integer;
    fois: integer;
    tfois: integer;
    Sselect: String;
    Sdistinct: String;
    Sfields: String;
    Swhere: String;
    b: boolean;
begin
    fois := 0;
    tfois := 0;
    b := false;
    sql_string := sql1;
    sql_index := 0;
    Sselect := ReadToken;
    if (Sselect = 'SELECT') then begin
            Recalage;
            Dynaset.Init;
            Complement.Init;
            Sdistinct := ReadToken;
            Recalage;
            if (Sdistinct = 'DISTINCT') then begin
                    Dynaset.Distinct := true;
                    Complement.Distinct := true;
                    Sfields := ReadToken;
                    Recalage;
            end else begin
                    base.Distinct := false;
                    Sfields := Sdistinct;
            end;
            if (Sfields = '*') then begin
                    for i:=1 to base.FieldCount do begin
                            Dynaset.AddField(base.FieldName[i]);
                            Complement.AddField(base.FieldName[i]);
                    end;
                    Swhere := ReadToken;
                    Recalage;
            end else begin
                    while (not ReachedEnd) and (Sfields <> 'WHERE') do begin
                            Dynaset.AddField(Sfields);
                            Complement.AddField(Sfields);
                            Sfields := ReadToken;
                            Recalage;
                    end;
                    Swhere := Sfields;
            end;
            if (Swhere = 'WHERE') then begin
                    b := true;
                    sql_string := MySubString(sql1, sql_index, length(sql1));
                    sql_index := 0;
                    Recalage;
                    if (base.GoFirst) then begin
                            repeat
                                    Inc(tfois, 1);
                                    sql_index := 0;
                                    if (expression) then begin
                                            Inc(fois, 1);
                                            Dynaset.AddRow;
                                            for i:=1 to Dynaset.FieldCount do begin
                                                    Dynaset.SetDataByIndex(i, base.GetData(Dynaset.FieldName[i]));
                                            end;
                                    end else begin
                                            Complement.AddRow;
                                            for i:=1 to Complement.FieldCount do begin
                                                    Complement.SetDataByIndex(i, base.GetData(Complement.FieldName[i]));
                                            end;
                                    end;
                            until not base.GoNext;
                            if (Dynaset.Distinct) then begin
                                    Dynaset.MakeDistinct;
                            end;
                            if (Complement.Distinct) then begin
                                    Complement.MakeDistinct;
                            end;
                    end else begin
                    end;
            end else begin
            end;
    end else begin
    end;
    Result := b and (tfois >= 0) and (fois >= 0);
end;

constructor TMlb2Sql.Create(m: TMlb2);
begin
     inherited Create;
     base := m;
     dynaset := TMlb2.Create;
     complement := TMlb2.Create;
     concorde := TConcordances.Create;
end;

destructor TMlb2Sql.Destroy;
begin
     concorde.Free;
     complement.Free;
     dynaset.Free;
     inherited Destroy;
end;

function TMlb2Sql.FloatValue(v1: String): Extended;
begin
     Result := base.RobustStrToFloat(v1);
end;

function TMlb2Sql.IsString(v1: String): boolean;
begin
      Result := v1[1] = '''';
end;

function TMlb2Sql.sansel(s1: String): String;
var   i: integer;
      sr: String;
      source: String;
begin
      sr := '';
      source := MySubString(s1, 1, length(s1)-1);
      i := 0;
      while (i<length(source)) do begin
              if (source[i+1] = '''') then begin
                      if (i<length(source)) then begin
                              if (source[i+1+1] = '''') then begin
                                      Inc(i, 1);
                                      sr := sr + '''';
                              end else begin
                              end;
                      end;
              end else begin
                      sr := sr + source[i+1];
              end;
              Inc(i, 1);
      end;
      Result := sr;
end;

function TMlb2Sql.MySubString(source1: string; bindex, eindex: integer): string;
begin
    if (bindex<0) then bindex := 0;
    if (bindex>=length(source1)) then bindex := length(source1);
    if (eindex>=length(source1)) then eindex := length(source1);
    try
            Result := Copy(source1, bindex+1, eindex-bindex);
    except
            Result := source1;
    end;
end;

function TMlb2Sql.IsOperator(c: char): boolean;
begin
     Result := (c in ['=', '<', '>', '~']);
end;

function TMlb2Sql.IsSeparator(c: char): boolean;
begin
     Result := (c in [' ', ',']);
end;

function TMlb2Sql.CharAt(k: integer): char;
begin
     Result := sql_string[k+1];
end;

procedure TMlb2Sql.Recalage;
begin
    while (sql_index<length(sql_string)) and IsSeparator(CharAt(sql_index)) do begin
          Inc(sql_index, 1);
    end;
end;

function TMlb2Sql.ReadToken: string;
var tbegin: integer;
    fin: boolean;
begin
    fin := false;
    Recalage;
    tbegin := sql_index;
    if (MySubString(sql_string, tbegin, tbegin+1) = '''')  then begin
       Inc(sql_index, 1);
       while (sql_index<length(sql_string)) and  not fin do begin
             fin := charAt(sql_index)='''';
             if (sql_index<(length(sql_string)-1)) then begin
                if fin and (charAt(sql_index+1)='''') then begin
                   fin := false;
                   Inc(sql_index, 1);
                end else begin
                end;
             end;
             Inc(sql_index, 1);
       end;
       Result := MySubString(sql_string, tbegin, sql_index);
       Exit;
    end else if (MySubString(sql_string, tbegin, tbegin+1) = '(') then begin
        Inc(sql_index, 1);
        Result := '(';
        Exit;
    end else if (MySubString(sql_string, tbegin, tbegin+1) = ')') then begin
        Inc(sql_index, 1);
        Result := ')';
        Exit;
    end else begin
        while (sql_index<length(sql_string)) do begin
              if IsOperator(charAt(sql_index)) then begin
                  Result := MySubString(sql_string, tbegin, sql_index);
                  Exit;
              end else if IsSeparator(charAt(sql_index)) then begin
                  Result := MySubString(sql_string, tbegin, sql_index);
                  Exit;
              end else if (charAt(sql_index) = ')') or (charAt(sql_index) = '(') then begin
                  Result := MySubString(sql_string, tbegin, sql_index);
                  Exit;
              end else begin
              end;
              Inc(sql_index, 1);
        end;
    end;
    Result := MySubString(sql_string, tbegin, sql_index);
    Exit;
end;

function TMlb2Sql.ReadOperator: string;
var tbegin: integer;
begin
    Recalage;
    tbegin := sql_index;
    while (sql_index<length(sql_string)) and IsOperator(charAt(sql_index)) do begin
            Inc(sql_index, 1);
    end;
    Result := MySubString(sql_string, tbegin, sql_index);
end;

function TMlb2Sql.ReachedEnd: boolean;
begin
     Result := sql_index>=length(sql_string);
end;

end.
