unit UGameMain;

interface
uses
  windows,UNgPlugConfig,GD_Utils,ULuaEngine;

procedure GameMain();

implementation

Procedure DoWork();
begin
  if NgPlugDebugMode then
    begin
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
end;

procedure GameMain();
var
  Lp:Cardinal;
begin
  NgPlugConfigLoad();

  LogPrintf('����汾��[%s]',[NG_EngineVer]);

  CreateThread(nil,0,@DoWork,nil,0,Lp);
  LogPrintf('��������[%d]',[Lp]);
end;

end.
