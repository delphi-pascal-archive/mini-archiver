program MiniZIP;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  AddingUnit in 'AddingUnit.pas' {DlgAddFiles},
  ExtractingUnit in 'ExtractingUnit.pas' {DlgExtractFiles},
  EditCommentUnit in 'EditCommentUnit.pas' {DlgEditComment},
  PasswordUnit in 'PasswordUnit.pas' {DlgPassword},
  SFXUnit in 'SFXUnit.pas' {DlgCreateSFX};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'M.A.D.M.A.N. Mini Archiver';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
