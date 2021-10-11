unit SFXUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TDlgCreateSFX = class(TForm)
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    ArchiveEdit: TEdit;
    BtnOpenArch: TBitBtn;
    PEEdit: TEdit;
    BtnSavePE: TBitBtn;
    DlgSaveMAF: TSaveDialog;
    DlgOpenArch: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    procedure BtnOpenArchClick(Sender: TObject);
    procedure BtnSavePEClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DlgCreateSFX: TDlgCreateSFX;

implementation

{$R *.dfm}

procedure TDlgCreateSFX.BtnOpenArchClick(Sender: TObject);
begin
  if DlgOpenArch.Execute then
    begin
      ArchiveEdit.Text:=DlgOpenArch.FileName;
      PEEdit.Text:=ChangeFileExt(ArchiveEdit.Text,'.EXE');
    end;
end;

procedure TDlgCreateSFX.BtnSavePEClick(Sender: TObject);
begin
  if DlgSaveMAF.Execute then
    begin
      if UpperCase(ExtractFileExt(DlgSaveMAF.FileName))<>'.EXE' then
        DlgSaveMAF.FileName:=DlgSaveMAF.FileName+'.EXE';
      PEEdit.Text:=DlgSaveMAF.FileName;
    end;
end;

end.
