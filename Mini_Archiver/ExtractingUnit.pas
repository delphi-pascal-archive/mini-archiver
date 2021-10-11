unit ExtractingUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ShellCtrls;

type
  TDlgExtractFiles = class(TForm)
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    ExtractDirEdit: TEdit;
    Bevel1: TBevel;
    Label1: TLabel;
    DirsTree: TShellTreeView;
    OverWriteBox: TRadioGroup;
    procedure DirsTreeChange(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DlgExtractFiles: TDlgExtractFiles;

implementation

{$R *.dfm}

procedure TDlgExtractFiles.DirsTreeChange(Sender: TObject;
  Node: TTreeNode);
begin
  ExtractDirEdit.Text:=DirsTree.Path;
end;

end.
