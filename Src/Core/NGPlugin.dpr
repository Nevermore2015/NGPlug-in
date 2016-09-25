library NGPlugin;

{$R 'Engine\Script\Lua.res' 'Engine\Script\Lua.rc'}

uses
  SysUtils,
  Windows,
  GD_Utils in '..\Inc\GD_Utils.pas',
  MD5 in '..\Inc\MD5.pas',
  UHideSelf in '..\Inc\UHideSelf.pas',
  UHookLib in '..\Inc\UHookLib.pas',
  UMemLoad in '..\Inc\UMemLoad.pas',
  ULog in '..\Inc\Log\ULog.pas',
  UGameTest in 'Customer\GamePacket\UGameTest.pas',
  UDemoScript in 'Customer\Script\UDemoScript.pas',
  UGameHook in 'Customer\Hook\UGameHook.pas',
  UDbgForm in 'Engine\DbgForm\UDbgForm.pas' {DbgForm},
  UGameDbgForm in 'Engine\DbgForm\UGameDbgForm.pas',
  Lua in 'Engine\Script\Lua.pas',
  LuaLib in 'Engine\Script\LuaLib.pas',
  LuaMain in 'Engine\Script\LuaMain.pas',
  UGameScriptBase in 'Engine\Script\UGameScriptBase.pas',
  ULuaEngine in 'Engine\Script\ULuaEngine.pas',
  UScriptThread in 'Engine\Script\UScriptThread.pas',
  UProtocol in 'Customer\UProtocol.pas',
  UHandleObject in 'Engine\GamePacketCore\UHandleObject.pas',
  UPacketManager in 'Engine\GamePacketCore\UPacketManager.pas',
  UConfig in 'Engine\Config\UConfig.pas',
  UConsoleProtocol in 'Engine\Console\UConsoleProtocol.pas',
  UConsoleSDK in 'Engine\Console\UConsoleSDK.pas',
  UNgPlugConfig in 'Customer\UNgPlugConfig.pas',
  UGameMain in 'Engine\UGameMain.pas',
  UGameDataBase in 'Engine\DataBase\UGameDataBase.pas',
  UGameDBManager in 'Engine\DataBase\UGameDBManager.pas';

{$R *.res}

begin
  //读取配置
  if LoadConfig(HInstance,'Config.ini') then
    begin
      //连接控制台
      g_ConsoleNet:=TConsoleNet.Create(Config.ConsoleIp,Config.ConsolePort,GetCurrentProcessId);
      if g_ConsoleNet.Active then
        begin
          Dbgprint('Token:%X GameVer:%d',[
            g_ConsoleNet.Token,
            g_ConsoleNet.GameVersion
          ]);
          GameMain();
        end;
      g_ConsoleNet.Free;
    end;
end.
