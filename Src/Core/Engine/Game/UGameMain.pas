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
  //���ؽű�����
//  ScriptEngine:=TGameScript.Create;
  //���Դ���
  LoadDbgForm();
  if LuaEngine.Active then
    begin
      LogPrintf('�ű���������[%d]',[LuaEngine.GetMethodCount()]);
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
  LogPrintf('����汾��[%s]',[EngineVer]);

  CreateThread(nil,0,@DoWork,nil,0,Lp);
  LogPrintf('��������[%d]',[Lp]);
end;

end.
