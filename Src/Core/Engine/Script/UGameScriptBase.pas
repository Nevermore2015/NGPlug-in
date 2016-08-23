unit UGameScriptBase;

interface
uses
  Windows,ULuaEngine,LuaLib,GD_Utils;

type
  TLuaState = Lua_State;

  TGameScriptBase = class
    private
      mTypeName:String;
    public
      constructor Create(TypeName:String);

      Function RegisterMethod(FuncName,MethodName:String):Integer;

      Function ToInteger(n:Integer):Integer;
      Function ToString(n:Integer):String;
  end;

implementation

{ TGameScript }

constructor TGameScriptBase.Create(TypeName:String);
begin
  mTypeName:= TypeName;

end;


function TGameScriptBase.RegisterMethod(FuncName, MethodName: String): Integer;
begin
  Dbgprint('Reg Script Method:%s',[FuncName]);
  Result:= LuaEngine.RegisterMethod(FuncName, MethodName,Self);
end;

function TGameScriptBase.ToInteger(n: Integer): Integer;
begin
  Result:=LuaEngine.GetValueToInteger(n);
end;

function TGameScriptBase.ToString(n: Integer): String;
begin
  Result:=LuaEngine.GetValueToString(n);
end;

end.
