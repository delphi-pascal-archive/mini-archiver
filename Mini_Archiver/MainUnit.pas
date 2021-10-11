unit MainUnit;

interface
                                                       
uses                                                     
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin,ZipCore, StdCtrls, ImgList, ExtCtrls,XpMan,
  Menus,SFX;

type                                                                 
  TMainForm = class(TForm)
    Bar: TCoolBar;
    Tool: TToolBar;
    BtnNew: TToolButton;
    BtnOpen: TToolButton;
    DlgOpenArch: TOpenDialog;
    BtnExtract: TToolButton;
    DlgSaveMAF: TSaveDialog;
    BigImg: TImageList;
    BtnEditComment: TToolButton;
    WndPanel: TPanel;
    FileList: TListView;
    StatusBar: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    ActionMenu: TPopupMenu;
    Selectall1: TMenuItem;
    N1: TMenuItem;
    Extractselected1: TMenuItem;
    BtnSFX: TToolButton;
    InfoLBL: TLabel;
    Bevel8: TBevel;
    GeneralProgress: TProgressBar;
    procedure BtnOpenClick(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure BtnExtractClick(Sender: TObject);
    procedure BtnEditCommentClick(Sender: TObject);              
    procedure FormCreate(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure BtnSFXClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Comment:String;
  OverWrite:Boolean;
implementation

uses AddingUnit, ExtractingUnit, EditCommentUnit,PassWordUnit, SFXUnit;
  
{$R *.dfm}

procedure TMainForm.BtnOpenClick(Sender: TObject);
var Author:String;
    Files,Sizes,PackSizes,ReadOnlys:TStringList;
    Count:LongInt;
begin                                                       
  if not DlgOpenArch.Execute then Exit;
  Wnd:=Handle;
  FileList.Clear;
  Files:=TStringList.Create;                                      
  Sizes:=TStringList.Create;
  PackSizes:=TStringList.Create;
  ReadOnlys:=TStringList.Create;
  ShowFiles(DlgOpenArch.FileName,Author,Comment,Files,Sizes,PackSizes,ReadOnlys);
  for Count:=0 to Files.Count-1 do
    begin
      FileList.Items.Add.Caption:=Files.Strings[Count];
      FileList.Items.Item[Count].SubItems.Add(PackSizes.Strings[Count]);
      FileList.Items.Item[Count].SubItems.Add(Sizes.Strings[Count]);
      FileList.Items.Item[Count].SubItems.Add(ReadOnlys.Strings[Count]);
    end;
  Files.Free;
  Sizes.Free;
  PackSizes.Free;
  ReadOnlys.Free;
end;

procedure TMainForm.BtnNewClick(Sender: TObject);
var FileList:TStringList;
    Index:LongInt;
    FileForCompress:String;
    PassWord:String;
    PassProtect:Boolean;
    Level:TCompLevel;
    ArchName:String;
    DominantDir:String;
begin              
  if not DlgSaveMAF.Execute then Exit;
  Wnd:=Handle;
  ArchiveProgress:=GeneralProgress;
  Application.CreateForm(TDlgAddFiles,DlgAddFiles);
  if DlgAddFiles.ShowModal=mrOk then
    begin
      Application.ProcessMessages;
      InfoLBL.Caption:='Precalculating data.';
      Application.ProcessMessages;
      PassWord:=DlgAddFiles.PasswordEdit.Text;
      PassProtect:=DlgAddFiles.cbUsePassword.Checked;
      FileList:=TStringList.Create;
      for index:=0 to DlgAddFiles.FileList.Items.Count-1 do
        begin
          FileForCompress:=DlgAddFiles.FileList.Items.Item[Index].SubItems.Strings[1]+
            '\'+DlgAddFiles.FileList.Items.Item[Index].Caption;
          FileList.Add(FileForCompress);
        end;
      case DlgAddFiles.cbCompression.ItemIndex of
      0:Level:=clNone;
      1:Level:=clFastest;
      2:Level:=clDefault;
      3:Level:=clMax;
      end;
      if (UpperCase(ExtractFileExt(DlgSaveMAF.FileName))<>'.MAF') then
        ArchName:=DlgSaveMAF.FileName+'.MAF';
      DominantDir:=GetDominateDir(FileList);
      Application.ProcessMessages;
      InfoLBL.Caption:='Creating archive, please wait.';
      Application.ProcessMessages;
      if CreateArchive(FileList,DominantDir,Level,Comment,PassWord,PassProtect,ArchName) then
        InfoLBL.Caption:='Ready.'
      else
        InfoLBL.Caption:='Coud not create archive.';
      FileList.Free;
    end;
  DlgAddFiles.Free;
end;

procedure TMainForm.BtnExtractClick(Sender: TObject);
var OutList:TStringList;
    Index:LongInt;
    PassWord:String;
    ExtractDir:String;
begin
  if FileList.SelCount=0 then Exit;
  Application.CreateForm(TDlgExtractFiles, DlgExtractFiles);
  if DlgExtractFiles.ShowModal=mrOk then
  begin
  Application.ProcessMessages;
  InfoLBL.Caption:='Precalculating data.';
  Application.ProcessMessages;
  Wnd:=Handle;
  PassWord:='';
  OverWrite:=True;
  ExtractDir:=DlgExtractFiles.ExtractDirEdit.Text;
  if DlgExtractFiles.OverWriteBox.ItemIndex=0 then
    OverWrite:=true
  else
    OverWrite:=False;
  if ExtractDir[Length(ExtractDir)]<>'\' then ExtractDir:=ExtractDir+'\';
  OutList:=TStringList.Create;
  for index:=0 to FileList.Items.Count-1 do
    begin
      if FileList.Items.Item[index].Selected then
        OutList.Add(FileList.Items.Item[Index].Caption);
    end;
  if IsPassword(DlgOpenArch.FileName) then
  if not GetPassword(Self,PassWord) then
    begin
      OutList.Free;
      Exit;
    end;
  Application.ProcessMessages;
  InfoLbl.Caption:='Extracting, please wait.';
  Application.ProcessMessages;
  if ExtractFiles(DlgOpenArch.FileName,OutList,PassWord,ExtractDir,OverWrite) then
    InfoLBL.Caption:='Ready.'
  else
    InfoLBL.Caption:='Coud not extract files.';
  OutList.Free;
  end;
  DlgExtractFiles.Free;
end;

procedure TMainForm.BtnEditCommentClick(Sender: TObject);
begin
  Application.CreateForm(TDlgEditComment, DlgEditComment);
  DlgEditComment.Comment.Text:=Comment;
  if DlgEditComment.ShowModal= mrOk then
    begin
      Comment:=DlgEditComment.Comment.Text;
    end;
  DlgEditComment.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Application.Title:=Caption;
end;

procedure TMainForm.Selectall1Click(Sender: TObject);
begin
  FileList.SelectAll;
end;

procedure TMainForm.BtnSFXClick(Sender: TObject);
begin
  Application.CreateForm(TDlgCreateSFX, DlgCreateSFX);
  if DlgCreateSFX.ShowModal=mrOk then
    begin
      Progressor:=GeneralProgress;
      Application.ProcessMessages;
      InfoLBL.Caption:='Creating SFX, please wait.';
      Application.ProcessMessages;
      if CreateSFXFromRes(DlgCreateSFX.ArchiveEdit.Text,DlgCreateSFX.PEEdit.Text)then
        InfoLBL.Caption:='Ready.'
      else
        InfoLBL.Caption:='Coud not create SFX.';
    end;
  DlgCreateSFX.Free;
end;

end.
