unit PasswordUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TDlgPassword = class(TForm)
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    PassWordEdit: TEdit;
    Bevel1: TBevel;
    Label1: TLabel;
    cbShowChar: TCheckBox;
    procedure cbShowCharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function GetPassword(AOwner:TComponent;Var PassWord:string):Boolean;

var
  DlgPassword: TDlgPassword;

implementation

{$R *.dfm}

Function GetPassword(AOwner:TComponent;Var PassWord:string):Boolean;
begin
  DlgPassword:=TDlgPassword.Create(AOwner);
  if DlgPassword.ShowModal=mrOk then
    begin
      PassWord:=DlgPassword.PassWordEdit.Text;
      Result:=True;
    end else
      Result:=False;
  DlgPassword.Free;
end;

procedure TDlgPassword.cbShowCharClick(Sender: TObject);
begin
  if cbShowChar.Checked then
    PassWordEdit.PasswordChar:=#0
  else
    PassWordEdit.PasswordChar:='*';
end;

end.
