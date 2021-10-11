unit ZipMessages;

interface

uses Windows;

Procedure ShowMsg(Msg:String;Wnd:hWnd);

implementation

Procedure ShowMsg(Msg:String;Wnd:hWnd);
begin
  MessageBox(Wnd,PChar(Msg),'Error',MB_OK+MB_ICONSTOP);
end;

end.
