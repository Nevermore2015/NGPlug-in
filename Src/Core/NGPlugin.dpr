library NGPlugin;



{$R 'Engine\Script\Lua.res' 'Engine\Script\Lua.rc'}

uses
  SysUtils,
  Classes,
  GD_Utils in '..\Inc\GD_Utils.pas',
  MD5 in '..\Inc\MD5.pas',
  UHideSelf in '..\Inc\UHideSelf.pas',
  UHookLib in '..\Inc\UHookLib.pas',
  UMemLoad in '..\Inc\UMemLoad.pas',
  ULog in '..\Inc\Log\ULog.pas',
  UGameTest in 'Customer\GamePacket\UGameTest.pas',
  UDemoScript in 'Customer\Script\UDemoScript.pas',
  UGameHook in 'Customer\Hook\UGameHook.pas',
  UGamePacket in 'Engine\Comm\UGamePacket.pas',
  UPacketManager in 'Engine\Comm\UPacketManager.pas',
  UDbgForm in 'Engine\DbgForm\UDbgForm.pas' {DbgForm},
  UGameDbgForm in 'Engine\DbgForm\UGameDbgForm.pas',
  UConfig in 'Engine\Config\UConfig.pas',
  UGameMain in 'Engine\Game\UGameMain.pas',
  UGameObjBase in 'Engine\Game\UGameObjBase.pas',
  UGameUpdate in 'Engine\Game\UGameUpdate.pas',
  Lua in 'Engine\Script\Lua.pas',
  LuaLib in 'Engine\Script\LuaLib.pas',
  LuaMain in 'Engine\Script\LuaMain.pas',
  UGameScriptBase in 'Engine\Script\UGameScriptBase.pas',
  ULuaEngine in 'Engine\Script\ULuaEngine.pas',
  UScriptThread in 'Engine\Script\UScriptThread.pas';

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
