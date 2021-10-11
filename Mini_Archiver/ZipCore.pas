unit ZipCore;

interface

uses ZLib,Classes,Windows,SysUtils,Controls,ComCtrls,forms,ZipMessages;

type TCompLevel = (clNone, clFastest, clDefault, clMax);

Function CreateArchive(Files:TStringList;DominantDir:String;Level:TCompLevel;Comment:String;
                        PassWord:String;PassProtect:Boolean;ArchiveName:String):Boolean;
Function ExtractFiles(FileName:string;Files:TStringList;
                      PassWord:String;ExtractDir:String;
                      OverWrite:Boolean):Boolean;
Procedure ShowFiles(ArchiveFileName:String;Var Author,Comment:string;FileList,SizeList,PSizeList,ReadOnlyList:TStringList);
Function IsPassword(FileName:string):boolean;
procedure MakeDir(Path:string);
Function GetDominateDir(FileList:TStringList):string;

var
  ArchiveProgress:TProgressBar;
  Wnd:hWnd;
implementation

const
  signature='MAF';
  Author='M.A.D.M.A.N.';
  Version='1.3';

type
  TArchiveHead=packed record
    Signature:array[0..2] of char;
    Version:String[4];
    Author:array[0..11] of char;
    Comment:String;
    CountFiles:longint;
    PasswordProtect:Boolean;
  end;

type
  TFileHeader=packed record
    FileName:ShortString;
    Pach:ShortString;
    ReadOnly:Boolean;
    FileSize:longint;
    PackedSize:LongInt;
  end;

function SubStr(original,minus:string):string;
var i:integer;
    HalfResult:String;
begin
  HalfResult:=copy(original,length(minus)+1,length(original));
  if Length(HalfResult)>=1 then
    result:=HalfResult;
end;

function GetOldDir(Dir1,Dir2:string):string;
var Index,aPos,PosIndex:integer;
    Dir:string;
begin
  if length(Dir1)>length(Dir2) then PosIndex:= length(Dir1) else
  PosIndex:=length(Dir2);
  for Index:=1 to PosIndex do
  if Dir1[Index]<>Dir2[Index] then begin
  Dir:=copy(Dir1,1,Index);
  for aPos:=length(Dir)-1 downto 1 do
  if Dir[aPos]='\' then
  begin
  result:=copy(Dir,1,aPos);
  exit;
  end;
  end;
end;

Function GetDominateDir(FileList:TStringList):string;
var i:integer;
    l,aaa:integer;
    HalfResult:string;
    TempList:TStringList;
begin
  TempList:=TStringList.Create;
  For i:=0 to FileList.Count-1 do
    TempList.Add(ExtractFileDir(FileList.Strings[i]));
    
  aaa:=length(TempList.Strings[0]);
  for i:=0 to TempList.Count-1 do
  begin
    l:=length(TempList.Strings[i]);
    if (l<=aaa) then
    begin
      aaa:=l;
      HalfResult:=TempList.Strings[i];
    end;
  end;
  Result:=HalfResult;
  TempList.Free;
end;

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
  application.ProcessMessages;
end;

Procedure MakeDir(Path:string);
var i,x:integer;
    cur_dir:string;
    RootDir:String;
begin
  RootDir:=Path[1]+Path[2]+Path[3];
  SetCurrentDirectory(pchar(RootDir));
  x:=1;
  cur_dir:='';
  if (Path[1]='\') then x:=2;
  for i:=x to Length(Path) do
   begin
    if not (Path[i]='\')then
      cur_dir:=cur_dir+Path[i];
    if (Path[i]='\')or (i=length(Path)) then
     begin
      if not DirectoryExists(cur_dir) then
       CreateDirectory(pchar(cur_dir),0);
      SetCurrentDirectory(pchar(cur_dir));
      cur_dir:='';
     end;
   end;
end;

Function IsNameInList(Name:String;List:TStringList):Boolean;
Var Index:Integer;
begin
  For Index:= 0 to List.Count-1 do
    if List.Strings[Index]=Name then
      begin
        Result:=True;
        Exit;
      end;
end;

Function CryptStream(InStream,OutStream:TStream;Password:string;isCrypt:boolean):Boolean;
var Index:LongInt;
    PassLength:Byte;
    PassIndex:Byte;
    Data:Byte;
begin
  InStream.Seek(0,soFromBeginning);
  OutStream.Seek(0,soFromBeginning);
  index:=0;
  passindex:=1;
  PassLength:=Length(Password);
  if (PassLength=0)then
    begin
      OutStream.CopyFrom(InStream,InStream.Size);
      OutStream.Seek(0,soFromBeginning);
      Result:=false;
      Exit;
    end;
  if not isCrypt then
    begin
      OutStream.CopyFrom(InStream,InStream.Size);
      OutStream.Seek(0,soFromBeginning);
      Result:=true;
      Exit;
    end;
  While index<>instream.Size do
    begin
      InStream.Seek(Index,soFromBeginning);
      InStream.Read(Data,1);
      Data:=Data xor (Byte(Password[Passindex])xor
                     (255-(Passlength-Passindex)))shl
                     ((InStream.Size-Index) mod 255);
      Inc(PassIndex);
      if PassIndex>PassLength then PassIndex:=1;
      OutStream.Write(Data,1);
      Inc(Index);
    end;
  Result:=True;
  OutStream.Seek(0,soFromBeginning);
end;

function CompressStream(inStream, outStream :TStream; const Level : TCompLevel = clDefault):boolean;
begin
  inStream.Seek(0,soFromBeginning);
  outStream.Seek(0,soFromBeginning);
  with TCompressionStream.Create(TCompressionLevel(Level), outStream) do
    try
      CopyFrom(inStream, inStream.Size);
      Free;
      result:=true;
    except
      result:=false;
    end;
end;

function ExpandStream(inStream, outStream :TStream):boolean;
var Count: integer;
    ZStream: TDecompressionStream;
    Buffer: Byte;
begin
  inStream.Seek(0,soFromBeginning);
  outStream.Seek(0,soFromBeginning);
  ZStream:=TDecompressionStream.Create(InStream);
  try
   while true do
    begin
     Count:=ZStream.Read(Buffer, sizeof(buffer));
     if Count<>0
     then OutStream.WriteBuffer(Buffer, Count)
     else Break;
    end;
    Result:=True;
  Except
    Result:=False;
    ZStream.Free;
  end;
  ZStream.Free;
end;

Function CreateArchive(Files:TStringList;DominantDir:String;Level:TCompLevel;Comment:String;
                        PassWord:String;PassProtect:Boolean;ArchiveName:String):Boolean;
var ArcHead:TArchiveHead;
    FileHead:TFileHeader;
    Archive:TMemoryStream;
    FileStream:TFileStream;
    CryptFile:TMemoryStream;
    Count:longint;
    CompressedFile:TMemoryStream;
begin
  Archive:=TMemoryStream.Create;
  ArcHead.Signature:=signature;
  ArcHead.Author:=author;
  ArcHead.Version:=Version;
  ArcHead.Comment:=Comment;
  ArcHead.PasswordProtect:=PassProtect;
  ArcHead.CountFiles:=Files.Count-1;
  Archive.Write(ArcHead,SizeOf(TArchiveHead));
  for Count:=0 to ArcHead.CountFiles do
    begin
      FileStream:=TFileStream.Create(Files.Strings[count],fmOpenRead);
      CompressedFile:=TMemoryStream.Create;
      CryptFile:=TMemoryStream.Create;
      CryptFile.Seek(0,soFromBeginning);

      if not CompressStream(FileStream,cryptfile,Level) then
        begin
          Result:=False;
          Archive.Free;
          FileStream.Free;
          CompressedFile.Free;
          CryptFile.Free;
          exit;
        end;
      CryptStream(cryptfile,compressedfile,PassWord,ArcHead.PasswordProtect);
      FileHead.FileName:=extractfilename(Files.Strings[count]); //Warning here!!!
      //FileHead.Pach:=DominantDir;//SubString(DominantDir,ExtractFileDir(Files.Strings[count]));
      FileHead.Pach:=SubStr(ExtractFileDir(Files.Strings[Count]),DominantDir);
      FileHead.ReadOnly:=FileIsReadOnly(FileHead.FileName);
      FileHead.PackedSize:=CompressedFile.Size;
      FileHead.FileSize:=FileStream.Size;

      CompressedFile.Seek(0,soFromBeginning);
      Archive.Write(FileHead,SizeOf(TFileHeader));
      Archive.CopyFrom(CompressedFile,CompressedFile.Size);
      
      FileStream.Free;
      CompressedFile.Free;
      CryptFile.Free;
      ShowProgress(ArchiveProgress,Count,0,ArcHead.CountFiles);
    end;
  Archive.SaveToFile(ArchiveName);
  Archive.Free;
  ShowProgress(ArchiveProgress,0,0,0);
end;

Function ExtractFiles(FileName:string;Files:TStringList;
                      PassWord:String;ExtractDir:String;
                      OverWrite:Boolean):Boolean;
var ArcHead:TArchiveHead;
    FileHead:TFileHeader;
    Archive:TFileStream;
    CryptFile:TMemoryStream;
    Count:longint;
    SaveStream:TMemoryStream;
    b:byte;
    p:longint;
    FilePos:LongInt;
    compressfile:tmemorystream;
begin
  Archive:=TFileStream.Create(FileName,fmOpenRead);
  archive.Seek(0,soFromBeginning);
  Archive.Read(ArcHead,sizeof(TArchiveHead));
  for count:=0 to archead.CountFiles do
    begin
      archive.Read(FileHead,sizeof(TFileHeader));
      if (ArcHead.Signature<>Signature) then
        begin
          Archive.Free;
          ShowMsg('This is not MAF archive!!!',Wnd);
          Exit;
        end;
      if (ArcHead.Version<>Version) then
        begin
          Archive.Free;
          ShowMsg('UnKnow version of MAF archive!!!',Wnd);
          Exit;
        end;
        if IsNameInList(FileHead.FileName,Files) then
          begin
          savestream:=TMemoryStream.Create;
          for p:=0 to filehead.PackedSize-1 do
            begin
              archive.Read(b,1);
              savestream.Write(b,1);
              //ShowProgress(ArchiveProgress,p,0,filehead.PackedSize);
            end;
          compressfile:=TMemorystream.Create;
          CryptFile:=TMemoryStream.Create;
          CryptFile.Seek(0,soFromBeginning);
          CryptStream(SaveStream,CryptFile,PassWord,ArcHead.PasswordProtect);
          if not expandstream(cryptfile,compressfile) then
            begin
              ShowMsg('Decompression error (File failure or wrong password)!!!',Wnd);
              archive.Free;
              savestream.Free;
              compressfile.Free;
              CryptFile.Free;
              exit;
            end;
          //if ExtractDir[length(ExtractDir)]<>'\' then ExtractDir:=ExtractDir+'\';
          MakeDir(ExtractDir+'\'+FileHead.Pach);
          if (FileExists(ExtractDir+'\'+FileHead.Pach+'\'+filehead.FileName))and(not OverWrite) then
            CompressFile.SaveToFile(ExtractDir+'\'+FileHead.Pach+'\'+filehead.FileName);
          if Not FileExists(ExtractDir+'\'+FileHead.Pach+'\'+filehead.FileName) then
            CompressFile.SaveToFile(ExtractDir+'\'+FileHead.Pach+'\'+filehead.FileName);
          filesetreadonly(ExtractDir+filehead.FileName,filehead.ReadOnly);
          savestream.Free;
          compressfile.Free;
          CryptFile.Free;
          ShowProgress(ArchiveProgress,Count,0,archead.CountFiles);
        end else begin
          archive.Seek(filehead.PackedSize,soFromCurrent);
          ShowProgress(ArchiveProgress,Count,0,archead.CountFiles);
        end;
    end;
  archive.Free;
  ShowProgress(ArchiveProgress,0,0,0);
  Result:=true;
end;

Procedure ShowFiles(ArchiveFileName:String;Var Author,Comment:string;FileList,SizeList,PSizeList,ReadOnlyList:TStringList);
var ArcHead:TArchiveHead;
    FileHead:TFileHeader;
    Archive:TFileStream;
    Count:longint;
begin
  FileList.Clear;
  SizeList.Clear;
  PSizeList.Clear;
  ReadOnlyList.Clear;
  Archive:=TFileStream.Create(ArchiveFileName,fmOpenRead);
  Archive.Read(ArcHead,SizeOf(TArchiveHead));
  if (ArcHead.Signature<>Signature) then
    begin
      ShowMsg('This is not MAF archive!!!',Wnd);
      Archive.Free;
      Exit;
    end;
  if (ArcHead.Version<>Version) then
    begin
      ShowMsg('UnKnow version of MAF archive!!!',Wnd);
      Archive.Free;
      Exit;
    end;
  Author:=archead.Author;
  Comment:=archead.Comment;
  for Count:=0 to ArcHead.CountFiles do
    begin
      Archive.Read(FileHead,sizeof(TFileHeader));
      Archive.Seek(FileHead.PackedSize,soFromCurrent);
      FileList.Add(filehead.FileName);
      SizeList.Add(IntTostr(FileHead.FileSize));
      PSizeList.Add(IntTostr(FileHead.PackedSize));
      ReadOnlyList.Add(BoolToStr(FileHead.ReadOnly,True));
      ShowProgress(ArchiveProgress,Count,0,ArcHead.CountFiles);
    end;
  Archive.Free;
  ShowProgress(ArchiveProgress,0,0,0);
end;

Function GetFileInfo(ArchiveFileName,FileName:String):TFileHeader;
var ArcHead:TArchiveHead;
    FileHead:TFileHeader;
    Archive:TFileStream;
    Count:longint;
begin
  Archive:=TFileStream.Create(ArchiveFileName,fmOpenRead);
  Archive.Read(ArcHead,SizeOf(TArchiveHead));
  if ArcHead.Signature<>Signature then
    begin
      ShowMsg('This is not MAF archive!!!',Wnd);
      Archive.Free;
      Exit;
    end;
  for Count:=0 to ArcHead.CountFiles do
    begin
      Archive.Read(FileHead,sizeof(TFileHeader));
      Archive.Seek(FileHead.PackedSize,soFromCurrent);
      if FileHead.FileName=FileName then
        begin
          Result:=FileHead;
          Archive.Free;
          Exit;
        end;
    end;
  Archive.Free;
end;

Function IsPassword(FileName:string):boolean;
var Archive:TFileStream;
    ArcHead:TArchiveHead;
begin
  Result:=False;
  Archive:=TFileStream.Create(FileName,fmOpenRead);
  Archive.Read(ArcHead,SizeOf(TArchiveHead));
  if ArcHead.Signature<>Signature then
    begin
      ShowMsg('There is not MAF file!!!',Wnd);
      Archive.Free;
      Exit;
    end;
  Result:=ArcHead.PasswordProtect;
  Archive.Free;
end;

end.
 