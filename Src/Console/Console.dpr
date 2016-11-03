program Console;

uses
  Forms,
  Windows,
  SysUtils,
  UMainform in 'UMainform.pas' {MainForm},
  UGameClientObj in 'UGameClientObj.pas',
  UWorkThread in 'UWorkThread.pas',
  UConsoleConfig in 'UConsoleConfig.pas',
  ULog in '..\Inc\Log\ULog.pas',
  GD_Utils in '..\Inc\GD_Utils.pas',
  MD5 in '..\Inc\MD5.pas',
  UCheckVersion in 'UCheckVersion.pas',
  superobject in '..\Inc\superobject.pas',
  UGameAddrManager in 'UGameAddrManager.pas',
  UConsoleProtocol in '..\Core\Engine\Console\UConsoleProtocol.pas',
  UGlobal in 'Customer\UGlobal.pas';

{$R *.res}
var
  Handle:Cardinal;

function LoadConfig(Handle:Cardinal;FileName:String):bool;
begin
  g_ConsoleConfig:=TConsoleConfig.Create(Handle,FileName);
  Result:=g_ConsoleConfig.Active;
  if not(g_ConsoleConfig.Active) then
    g_ConsoleConfig.Free;
end;

begin
  Handle:=CreateMutex(nil,True,PChar(Format('NGPlugIn_%d_%d',[ConsoleVersion,GameId])));
  if Handle <> 0 then
    begin
      if GetLastError <> ERROR_ALREADY_EXISTS then
        begin
          if CreateLog(HInstance) then
            begin
              LogPrintf('控制台版本:%d',[ConsoleVersion]);
              //读取配置
              if LoadConfig(HInstance,'Config.ini') then
                begin
                  LogPrintf('加载配置完成！',[]);
                  //验证版本更新;
                  case CheckVersion() of
                    0:begin
                        Application.Initialize;
                        Application.MainFormOnTaskbar := True;
                        Application.CreateForm(TMainForm, MainForm);
                        MainForm.Caption:=ConsoleTitle;
                        Application.Run;
                      end;
                    1:begin
                        if MessageBox(0,'有新版本需要更新','更新提示',MB_OKCANCEL) = ID_OK then
                          begin
                            WinExec(PChar(Format('.\Update.exe %d',[ConsoleVersion])),SW_NORMAL);
                          end;
                      end;
                    2:begin
                        MessageBox(0,'版本校验出错','错误',0);
                      end;
                  end;
                end;
            end
          else
            begin
              MessageBox(0,'创建日志失败','错误',0);
            end;
        end
      else
        MessageBox(0,'控制台已经运行,请勿重复运行','错误',0);
    end;
end.
