unit EditCommentUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TDlgEditComment = class(TForm)
    Comment: TMemo;
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    Bevel1: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DlgEditComment: TDlgEditComment;

implementation

{$R *.dfm}

end.
