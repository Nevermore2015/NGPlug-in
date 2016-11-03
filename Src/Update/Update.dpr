program Update;

uses
  Forms,
  SysUtils,
  Windows,
  UUpdateForm in 'UUpdateForm.pas' {Form1},
  UWorkProc in 'UWorkProc.pas',
  MD5 in '..\Inc\MD5.pas',
  superobject in '..\Inc\superobject.pas',
  GD_Utils in '..\Inc\GD_Utils.pas',
  ULog in '..\Inc\Log\ULog.pas',
  UConfig in 'UConfig.pas';

{$R *.res}
function LoadConfig(Handle:Cardinal;FileName:String):bool;
begin
  g_Config:=TConfig.Create(Handle,FileName);
  Result:=g_Config.Active;
  if not(g_Config.Active) then
    g_Config.Free;
end;

begin
  if ParamCount = 1 then
    begin
      if LoadConfig(HInstance,'config.ini') then
        begin
          Application.Initialize;
          Application.MainFormOnTaskbar := True;
          Application.CreateForm(TForm1, Form1);
          Form1.lbl1.Caption:= '当前版本:' + ParamStr(1);
          Application.Run;
        end;
    end
  else
    MessageBox(0,PChar('更新程序参数不正确! ' + inttostr(ParamCount)),'错误',0);

end.
