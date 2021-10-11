unit SFX;

interface

uses Windows,Classes,SysUtils,ComCtrls;

Function CreateSFXFromFile(ArchiveFileName,SFXName,EXEName:string):Boolean;
Function CreateSFXFromRes(ArchiveName,EXEName:string):Boolean;
                                                                               
var
  Progressor:TProgressBar;                             
implementation

{$R SFX.res}

function SolveForY(X, Z: Longint): Byte;
begin
  if Z = 0 then Result := 0
  else Result := Byte(Trunc( (X * 100.0) / Z ));
end;

function GetPercentDone(FCurValue,FMinValue,FMaxValue:LongInt): Byte;
begin
  Result := SolveForY(FCurValue - FMinValue, FMaxValue - FMinValue);
end;

Procedure ShowProgress(Bar:TProgressBar;Value,Min,Max:LongInt);
begin
  if Bar<>nil then
  Bar.Position:=GetPercentDone(Value,Min,Max);
end;

Function CreateSFXFromFile(ArchiveFileName,SFXName,EXEName:string):Boolean;
var SaveStream:TMemoryStream;
    SFXStream:TMemoryStream;
    ArchiveStream:TMemoryStream;
    Data:Byte;
begin
  if (not FileExists(ArchiveFileName)) or
     (not FileExists(SFXName))or
     (EXEName='') then
     begin
      Result:=False;
      Exit;
     end;
  SaveStream:=TMemoryStream.Create;
  SFXStream:=TMemoryStream.Create;
  ArchiveStream:=TMemoryStream.Create;
  SFXStream.LoadFromFile(SFXName);
  ArchiveStream.LoadFromFile(ArchiveFileName);
  SFXStream.Seek(0,soFromBeginning);
  SaveStream.CopyFrom(SFXStream,SFXStream.Size);
  {While SFXStream.Position<>SFXStream.Size do
    begin
      SFXStream.Read(Data,1);
      SaveStream.Write(Data,1);
    end; }
  ArchiveStream.Seek(0,soFromBeginning);
  SaveStream.CopyFrom(ArchiveStream,ArchiveStream.Size);
  { ArchiveStream.Position<>ArchiveStream.Size do
    begin
      ArchiveStream.Read(Data,1);
      SaveStream.Write(Data,1);
      //ShowProgress(Progressor,ArchiveStream.Position,0,ArchiveStream.Size);
    end;  }
  SaveStream.SaveToFile(EXEName);
  //ShowProgress(Progressor,0,0,0);
  SaveStream.Free;
  ArchiveStream.Free;
  SFXStream.Free;
  Result:=True;
end;

Function CreateSFXFromRes(ArchiveName,EXEName:string):Boolean;
var SaveStream:TMemoryStream;
    ArchiveStream:TMemoryStream;
    ResStream:TResourceStream;
    Index:LongInt;
    Data:Byte;
begin
  If (ArchiveName='')or(EXEName='')then
    begin
      Result:=False;
      Exit;
    end;
  ResStream:=TResourceStream.Create(hInstance,'MINIZIP','SFX');
  ArchiveStream:=TMemoryStream.Create;
  SaveStream:=TMemoryStream.Create;
  while ResStream.Position<>ResStream.Size do
    begin
      ResStream.Read(Data,1);
      SaveStream.Write(Data,1);
    end;
  ArchiveStream.LoadFromFile(ArchiveName);
  While ArchiveStream.Position<>ArchiveStream.Size do
    begin
      ArchiveStream.Read(Data,1);
      SaveStream.Write(Data,1);
      //ShowProgress(Progressor,ArchiveStream.Position,0,ArchiveStream.Size);
    end;
  SaveStream.SaveToFile(EXEName);
  Result:=True;
  //ShowProgress(Progressor,0,0,0);
  SaveStream.Free;
  ArchiveStream.Free;
  ResStream.Free;
end;

end.
