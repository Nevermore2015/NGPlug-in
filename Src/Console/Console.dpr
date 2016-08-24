program Console;

uses
  Forms,
  Windows,
  SysUtils,
  UMainform in 'UMainform.pas' {MainForm},
  UGameClientObj in 'UGameClientObj.pas',
  UWorkThread in 'UWorkThread.pas',
  UConfig in 'UConfig.pas',
  ULog in '..\Inc\Log\ULog.pas',
  GD_Utils in '..\Inc\GD_Utils.pas',
  MD5 in '..\Inc\MD5.pas',
  UGlobal in 'UGlobal.pas',
  UCheckVersion in 'UCheckVersion.pas';

{$R *.res}
var
  Handle:Cardinal;
begin
  Handle:=CreateMutex(nil,True,PChar(Format('NGPlugIn_%d_%d',[ConsoleVersion,GameId])));
  if Handle <> 0 then
    begin
      if GetLastError <> ERROR_ALREADY_EXISTS then
        begin
          if CreateLog(HInstance) then
            begin
              LogPrintf('����̨�汾:%d',[ConsoleVersion]);
              //��ȡ����
              if LoadConfig(HInstance,'Config.ini') then
                begin
                  LogPrintf('����������ɣ�',[]);
                  //��֤�汾����;
                  case CheckVersion() of
                    0:begin
                        Application.Initialize;
                        Application.MainFormOnTaskbar := True;
                        Application.CreateForm(TMainForm, MainForm);
                        MainForm.Caption:=ConsoleTitle;
                        Application.Run;
                      end;
                    1:begin
                        if MessageBox(0,'���°汾��Ҫ����','������ʾ',MB_OKCANCEL) = ID_OK then
                          begin
                            WinExec(PChar(Format('.\Update.exe %d %s',[ConsoleVersion,Config.UpdateUrl])),SW_NORMAL);
                          end;
                      end;
                    2:begin
                        WinExec(PChar(Format('.\Update.exe %d %s',[ConsoleVersion,Config.UpdateUrl])),SW_NORMAL);
                        MessageBox(0,'�汾У�����','����',0);
                      end;
                  end;
                end;
            end
          else
            begin
              MessageBox(0,'������־ʧ��','����',0);
            end;
        end
      else
        MessageBox(0,'����̨�Ѿ�����,�����ظ�����','����',0);
    end;
end.
