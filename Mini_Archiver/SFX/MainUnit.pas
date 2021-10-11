unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls,ZLib,PasswordUnit,
  ExtractingUnit,XPman;

type
  TDlgMain = class(TForm)
    BtnExtract: TBitBtn;
    BtnCancel: TBitBtn;
    EndDirEdit: TEdit;
    BtnBrows: TBitBtn;
    Bevel1: TBevel;
    Splash: TImage;
    Log: TMemo;
    GeneralProgress: TProgressBar;
    Bevel2: TBevel;
    procedure BtnExtractClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnBrowsClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

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

var
  DlgMain: TDlgMain;
  GeneralStream:TMemoryStream;
  Start:LongInt;
  PassProtect:Boolean;
  OverWrite:Boolean;
implementation

{$R *.dfm}

function SolveForY(X, Z: Longint): Byte;
begin
  if Z = 0 then Result := 0
  else Result := Byte(Trunc( (X * 100.0) / Z ));
end;

function GetPercentDone(FCurValue,FMinValue,FMaxValue:LongInt): Byte;
begin
  Result := SolveForY(FCurValue - FMinValue, FMaxValue - FMinValue);
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

function ExpandStream(inStream, outStream :TStream):boolean;
var Count: integer;
    ZStream: TDecompressionStream;
    Buffer: {array[0..BufferSize-1] of} Byte;
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
    //ZStream.Free;
  end;
  ZStream.Free;
end;

Function ExtractFiles(PassWord:String;ExtractDir:String):Boolean;
var ArcHead:TArchiveHead;
    FileHead:TFileHeader;
    CryptFile:TMemoryStream;
    Count:longint;
    SaveStream:TMemoryStream;
    b:byte;
    p:longint;
    FilePos:LongInt;
    compressfile:tmemorystream;
begin
  GeneralStream.Seek(Start,soFromBeginning);
  GeneralStream.Read(ArcHead,sizeof(TArchiveHead));
  for count:=0 to archead.CountFiles do
    begin
      GeneralStream.Read(FileHead,sizeof(TFileHeader));
      if ArcHead.Signature<>Signature then
        begin
          GeneralStream.Free;
          DlgMain.Log.Font.Color:=clRed;
          DlgMain.Log.Font.Style:=[fsBold];
          DlgMain.Log.Lines.Add('Error!!!  Invalid Archive!!!');
          Exit;
        end;
          DlgMain.Log.Lines.Add('Extracting '+FileHead.FileName);
          savestream:=TMemoryStream.Create;
          for p:=0 to filehead.PackedSize-1 do
            begin
              GeneralStream.Read(b,1);
              savestream.Write(b,1);
              //ShowProgress(ArchiveProgress,p,0,filehead.PackedSize);
            end;
          compressfile:=TMemorystream.Create;
          CryptFile:=TMemoryStream.Create;
          CryptFile.Seek(0,soFromBeginning);
          CryptStream(SaveStream,CryptFile,PassWord,ArcHead.PasswordProtect);
          if not expandstream(cryptfile,compressfile) then
            begin
              DlgMain.Log.Font.Color:=clRed;
              DlgMain.Log.Font.Style:=[fsBold];
              DlgMain.Log.Lines.add('Decompression error (File failure or wrong password)!!!');
              GeneralStream.Free;
              savestream.Free;
              compressfile.Free;
              CryptFile.Free;
              exit;
            end;
          if ExtractDir[length(ExtractDir)]<>'\' then ExtractDir:=ExtractDir+'\';
          MakeDir(ExtractDir+'\'+FileHead.Pach);
          if (FileExists(ExtractDir+'\'+FileHead.Pach+'\'+filehead.FileName))and(not OverWrite)then
            compressfile.SaveToFile(ExtractDir+'\'+FileHead.Pach+'\'+filehead.FileName);
          if not FileExists(ExtractDir+'\'+FileHead.Pach+'\'+filehead.FileName) then
            compressfile.SaveToFile(ExtractDir+'\'+FileHead.Pach+'\'+filehead.FileName);
          filesetreadonly(ExtractDir+filehead.FileName,filehead.ReadOnly);
          savestream.Free;
          compressfile.Free;
          CryptFile.Free;
          DlgMain.GeneralProgress.Position:=GetPercentDone(Count,0,ArcHead.CountFiles);
          Result:=true;
    end;
  GeneralStream.Free;
end;

procedure TDlgMain.BtnExtractClick(Sender: TObject);
var PassWord:String;
begin
  if BtnExtract.Tag<>0 then
    begin
      Halt;
    end;
  BtnExtract.Enabled:=false;
  Log.Clear;
  If PassProtect then
    if not GetPassword(Self,PassWord) then
      Halt;
  if not ExtractFiles(PassWord,EndDirEdit.Text) then
    begin
      Log.Font.Color:=clRed;
      Log.Font.Style:=[fsBold];
      Log.Lines.Add('Extracting error, press "Finish" to exit!!!');
      BtnExtract.Glyph:=nil;
      BtnExtract.Caption:='Finish';
      BtnExtract.Tag:=1;
    end;
  Close;
end;

procedure TDlgMain.FormCreate(Sender: TObject);
var Head:TArchiveHead;
    Pos:LongInt;
begin
  OverWrite:=true;
  EndDirEdit.Text:=ExtractFileDir(Application.ExeName);
  GeneralStream:=TMemoryStream.Create;
  GeneralStream.LoadFromFile(Application.ExeName);
  GeneralStream.Seek(0,soFromBeginning);
  Pos:=0;
  while Pos<>GeneralStream.Size do
    begin
      GeneralStream.Seek(Pos,soFromBeginning);
      GeneralStream.Read(Head,SizeOf(TArchiveHead));
      if (Head.Signature=Signature)
            and(Head.Author=Author)
            and(Head.Version=Version)then
        begin
          Start:=GeneralStream.Position-SizeOf(TArchiveHead);
          if Head.Comment<>'' then
            Log.Text:=Head.Comment;
          PassProtect:=Head.PasswordProtect;
          Exit;
        end;
      Inc(pos,1);
    end;
  if Start=0 then
    begin
      Log.Font.Color:=clRed;
      Log.Font.Style:=[fsBold];
      Log.Clear;
      Log.Lines.Add('Invalid archive, press "Finish" to exit!!!');
      BtnExtract.Glyph:=nil;
      BtnExtract.Caption:='Finish';
      BtnExtract.Tag:=1;
    end;   
end;

procedure TDlgMain.BtnBrowsClick(Sender: TObject);
begin
  Application.CreateForm(TDlgExtractFiles,DlgExtractFiles);
  if DlgExtractFiles.ShowModal=mrOk then
    begin
      EndDirEdit.Text:=DlgExtractFiles.ExtractDirEdit.Text;
      if DlgExtractFiles.OverWriteBox.ItemIndex=0 then
        OverWrite:=true
      else
        OverWrite:=False;
    end;
  DlgExtractFiles.Free;
end;

procedure TDlgMain.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
 