program Update;

uses
  Forms,SysUtils,
  Windows,
  UMainForm in 'UMainForm.pas' {Form1},
  UWorkProc in 'UWorkProc.pas';

{$R *.res}

begin
  if ParamCount = 2 then
    begin
      Application.Initialize;
      Application.MainFormOnTaskbar := True;
      Application.CreateForm(TForm1, Form1);
      Form1.lbl1.Caption:= '当前版本:' + ParamStr(1);
      Form1.lbl2.Caption:= ParamStr(2);
      Application.Run;
    end
  else
    MessageBox(0,PChar('更新程序参数不正确! ' + inttostr(ParamCount)),'错误',0);

end.
