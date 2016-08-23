unit UGameMain;

interface
uses
  windows;
const
  EngineVer = '2.0';

procedure GameMain();

implementation
uses
  GD_Utils,UDbgForm,ULuaEngine;

Procedure DoWork();
 // ScriptEngine:TGameScript;
begin
  //加载脚本引擎
//  ScriptEngine:=TGameScript.Create;
  //调试窗口
  LoadDbgForm();
  if LuaEngine.Active then
    begin
      LogPrintf('脚本命令数量[%d]',[LuaEngine.GetMethodCount()]);
      while True do
        begin
          LogPrintf('->%d',[LuaEngine.DoString('Talk("1111");')]);
          Sleep(2000);
        end;
    end;
end;

procedure GameMain();
var
  Lp:Cardinal;
begin
  LogPrintf('引擎版本号[%s]',[EngineVer]);

  CreateThread(nil,0,@DoWork,nil,0,Lp);
  LogPrintf('主线启动[%d]',[Lp]);
end;

end.
