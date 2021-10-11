unit AddingUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons;

type
  TDlgAddFiles = class(TForm)
    FileList: TListView;
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    BtnAdd: TBitBtn;
    BtnDelete: TBitBtn;
    BtnClear: TBitBtn;
    Bevel1: TBevel;
    DlgAddingFiles: TOpenDialog;
    cbUsePassword: TCheckBox;
    PasswordEdit: TEdit;
    cbCompression: TComboBox;
    Label1: TLabel;
    BtnComment: TBitBtn;
    procedure BtnAddClick(Sender: TObject);
    procedure cbUsePasswordClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCommentClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DlgAddFiles: TDlgAddFiles;

implementation

uses EditCommentUnit,MainUnit;

{$R *.dfm}

procedure TDlgAddFiles.BtnAddClick(Sender: TObject);
var index:integer;
    SizeMeter:TFileStream;
    Size:LongInt;
    fName:string;
    ItemIndex:LongInt;
begin
  if not DlgAddingFiles.Execute then Exit;
  ItemIndex:=FileList.Items.Count;
  for index:=0 to DlgAddingFiles.Files.Count-1 do
    begin
      SizeMeter:=TFileStream.Create(DlgAddingFiles.Files.Strings[Index],fmOpenRead);
      Size:=SizeMeter.Size;
      SizeMeter.Free;
      fName:=DlgAddingFiles.Files.Strings[Index];
      FileList.Items.Add.Caption:=ExtractFileName(fName);
      FileList.Items.Item[ItemIndex].SubItems.Add(IntToStr(size));
      FileList.Items.Item[ItemIndex].SubItems.Add(ExtractFileDir(fName));
      inc(ItemIndex);
    end;
end;

procedure TDlgAddFiles.cbUsePasswordClick(Sender: TObject);
begin
  PasswordEdit.Enabled:=cbUsePassword.Checked;
  PasswordEdit.Clear;
end;

procedure TDlgAddFiles.BtnDeleteClick(Sender: TObject);
begin
  FileList.DeleteSelected;
end;

procedure TDlgAddFiles.BtnClearClick(Sender: TObject);
begin
  FileList.Clear;
end;

procedure TDlgAddFiles.BtnOkClick(Sender: TObject);
begin
  if (PasswordEdit.Text='') and (cbUsePassword.Checked)
    then begin
      MessageBox(Handle,'Password is empty, please insert password or disable!!!',
                  nil,mb_ok+mb_iconstop);
      exit;
    end else modalresult:=mrOk;
end;

procedure TDlgAddFiles.BtnCommentClick(Sender: TObject);
begin
  Application.CreateForm(TDlgEditComment, DlgEditComment);
  DlgEditComment.Comment.Text:=MainUnit.Comment;
  if DlgEditComment.ShowModal= mrOk then
    begin
      Comment:=DlgEditComment.Comment.Text;
    end;
  DlgEditComment.Free;
end;

end.
