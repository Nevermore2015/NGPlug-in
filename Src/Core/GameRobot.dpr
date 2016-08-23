library GameRobot;

{$R 'Script\Lua.res' 'Script\Lua.rc'}

uses
  SysUtils,
  Classes,
  GD_Utils in '..\Inc\GD_Utils.pas',
  MD5 in '..\Inc\MD5.pas',
  UHideSelf in '..\Inc\UHideSelf.pas',
  UHookLib in '..\Inc\UHookLib.pas',
  UMemLoad in '..\Inc\UMemLoad.pas',
  UPacketManager in 'Comm\UPacketManager.pas',
  UGamePacket in 'Comm\UGamePacket.pas',
  UGameObjBase in 'Game\UGameObjBase.pas',
  ULog in '..\Inc\Log\ULog.pas',
  LuaLib in 'Script\LuaLib.pas',
  UGameMain in 'Game\UGameMain.pas',
  UConfig in 'Config\UConfig.pas',
  UDbgForm in 'DbgForm\UDbgForm.pas' {DbgForm},
  UGameDbgForm in 'DbgForm\UGameDbgForm.pas',
  UGameTest in 'Customer\GamePacket\UGameTest.pas',
  UScriptThread in 'Script\UScriptThread.pas',
  ULuaEngine in 'Script\ULuaEngine.pas',
  UDemoScript in 'Customer\Script\UDemoScript.pas',
  UGameScriptBase in 'Script\UGameScriptBase.pas',
  UGameHook in 'Customer\Hook\UGameHook.pas',
  UGameUpdate in 'Game\UGameUpdate.pas';

{$R *.res}

begin
  //创建日志
  CreateLog(HInstance);
  //读取配置
  if LoadConfig(HInstance,'Config.ini') then
    begin
      Update:=TGameUpdate.Create;
    end;
  //HOOK
  StartHook();
  //隐藏模块
  HideSelf();
  //引擎入口
  GameMain();
end.
