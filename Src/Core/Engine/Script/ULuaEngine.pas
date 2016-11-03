unit ULuaEngine;

interface
uses
  Windows,Classes,LuaLib,GD_Utils;



type
  TLuaState = Lua_State;
  TProc = function(L: TLuaState): Integer of object;
  
  TCallback = class
    FuncName:string;
    Routine: TMethod;  // Code and Data for the method
    Exec: TProc;       // Resulting execution function
  end;

  TLuaEngine = class(TObject)
    private
      CallbackList: TList;
      procedure CallBackClear(Obj: TObject);
    public
      Active:Bool;
      LuaInstance: TLuaState;
      constructor Create(); overload; virtual;
      destructor Destroy; override;
      //执行文件
      Function DoFile(Fs:String):Integer;
      //执行字符串
      Function DoString(Str:String):Integer;
      //注册脚本命令
      Function RegisterMethod(FuncName,MethodName:String;Obj: TObject = NIL):Integer;
      //获取脚本执行错误信息
      Function GetScriptError():String;
      //获取已经注册的脚本命令数量
      Function GetMethodCount():Integer;

      {**脚本内参数获取**}

      //获取数值型参数
      Function GetValueToInteger(n:Integer):Integer;
      //获取字符型参数
      function GetValueToString(n:Integer):String;
  end;

var
  LuaEngine:TLuaEngine;

implementation


{ TLuaEngine }

constructor TLuaEngine.Create;
begin
  Active:=False;
  inherited Create;
  if LoadLuaLib_Mem <> 0 then
  begin
    LuaInstance := Lua_Open();
    luaopen_base(LuaInstance);
    CallBackList := TList.Create;
    Active:=True;
    LogPrintf('脚本引擎加载完毕!',[]);
  end else
    LogPrintf('脚本引擎加载失败!',[]);
end;

destructor TLuaEngine.Destroy;
begin
  CallBackClear(Self);
  Lua_Close(LuaInstance);
  inherited;
end;


function TLuaEngine.DoFile(Fs: String): Integer;
begin
  try
    Result := lual_dofile(LuaInstance, Pchar(Fs));
  except
    Result:=-1;
  end;
end;

function TLuaEngine.DoString(Str: String): Integer;
begin
  try
    Result := luaL_dostring(LuaInstance, PChar(Str));
  except
    Result:=-1;
  end;
end;

function TLuaEngine.GetMethodCount: Integer;
begin
  Result:=CallbackList.Count;
end;

function TLuaEngine.GetScriptError: String;
begin
  Result := lua_tostring(LuaInstance, -1);
end;

function TLuaEngine.GetValueToInteger(n: Integer): Integer;
begin
  Result:=lua_tointeger(LuaInstance,n);
end;

function TLuaEngine.GetValueToString(n: Integer): String;
begin
  Result:=lua_tostring(LuaInstance,n);
end;

function LuaCallBack(L: Lua_State): Integer; cdecl;
var
  CallBack: TCallBack;       // The Object stored in the Object Table
begin
  // Retrieve first Closure Value (=Object Pointer)
  CallBack := lua_topointer(L, lua_upvalueindex(1));

  // Execute only if Object is valid
  if (assigned(CallBack) and assigned(CallBack.Exec)) then
    Result := CallBack.Exec(L)
  else
    Result := 0;
end;


function TLuaEngine.RegisterMethod(FuncName, MethodName: String;
  Obj: TObject): Integer;
var
  CallBack: TCallBack; // Callback Object
begin
  // if method name not specified use Lua function name
  if (MethodName = '') then
    MethodName := FuncName;

  // if not object specified use this object
  if (Obj = NIL) then
    Obj := Self;

  // Add Callback Object to the Object Index
  CallBack := TCallBack.Create;
  CallBack.FuncName:=FuncName;
  CallBack.Routine.Data := Obj;
  CallBack.Routine.Code := Obj.MethodAddress(String(MethodName));
  CallBack.Exec := TProc(CallBack.Routine);
  CallbackList.Add(CallBack);

  // prepare Closure value (Method Name)
  lua_pushstring(LuaInstance, PAnsiChar(FuncName));

  // prepare Closure value (CallBack Object Pointer)
  lua_pushlightuserdata(LuaInstance, CallBack);

  // set new Lua function with Closure value
  lua_pushcclosure(LuaInstance, LuaCallBack, 1);
  lua_settable(LuaInstance, LUA_GLOBALSINDEX);

  Result:=CallbackList.Count;
end;

procedure TLuaEngine.CallBackClear(Obj: TObject);
var
  I: Integer;
  CallBack: TCallBack;
begin
  if CallBackList.Count > 0 then
    begin
      for I := CallBackList.Count - 1 downto 0 do
        begin
          CallBack := CallBackList[I-1];
          if (assigned(CallBack)) and (CallBack.Routine.Data = Obj) then
          begin
            CallBack.Free;
            CallBackList.Items[I-1] := NIL;
            CallBackList.Delete(I-1);
          end;
        end;
    end;
  CallBackList.Free;
end;

initialization
  LuaEngine:=TLuaEngine.Create;
end.
