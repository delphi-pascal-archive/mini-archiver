program MiniZIP;

uses
  Forms,windows,
  MainUnit in 'MainUnit.pas' {DlgMain};

{$E SFX}

{$R *.res}

begin
  Application.Initialize;
  SetWindowLong(Application.Handle, GWL_EXSTYLE,WS_EX_TOOLWINDOW);
  Application.CreateForm(TDlgMain, DlgMain);
  Application.Run;
end.
