unit Lua;

interface

uses
  Classes,Windows,LuaLib,GD_Utils;

type
  TLuaState = Lua_State;

  TLua = class(TObject)
  private
    fAutoRegister: Boolean;
    CallbackList: TList;

  public
    LuaInstance: TLuaState;  // Lua instance
    constructor Create(AutoRegister: Boolean = True); overload; virtual;
    destructor Destroy; override;
    function DoString(Scripts: String): Integer;
    function DoFile(Filename: String): Integer; virtual;// load file and execute

    function ScriptError():string; //执行出错输出
    Procedure Stop();

    procedure RegisterFunction(FuncName: AnsiString; MethodName: AnsiString = ''; Obj: TObject = NIL); virtual; //register function
    procedure AutoRegisterFunctions(Obj: TObject);  // register all published functions
    procedure UnregisterFunctions(Obj: TObject); // unregister all object functions
  end;

implementation

type
  TProc = function(L: TLuaState): Integer of object; // Lua Function

  TCallback = class
    FuncName:string;
    Routine: TMethod;  // Code and Data for the method
    Exec: TProc;       // Resulting execution function
  end;

//
// This function is called by Lua, it extracts the object by
// pointer to the objects method by name, which is then called.
//
// @param       Lua_State   L   Pointer to Lua instance
// @return      Integer         Number of result arguments on stack
//
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

{ TLua }

//
// Create a new Lua instance and optionally create Lua functions
//
// @param       Boolean      AutoRegister       (optional)
// @return      TLua                            Lua Instance
//
constructor TLua.Create(AutoRegister: Boolean = True);
begin
  inherited Create;

  if LoadLuaLib_Mem <> 0 then
    begin
     // if (not LuaLibLoaded) then
     //   LoadLuaLib;

      LuaInstance := Lua_Open();
      luaopen_base(LuaInstance);

      fAutoRegister := AutoRegister;

      CallBackList := TList.Create;

      if (AutoRegister) then
        AutoRegisterFunctions(self);
      LogPrintf('脚本引擎加载完毕!',[]);
    end;
end;

destructor TLua.Destroy;
begin
  // Unregister all functions if previously autoregistered
  if (fAutoRegister) then
    UnregisterFunctions(Self);

  // dispose Object List on finalization
  CallBackList.Free;

  // Close instance
  Lua_Close(LuaInstance);
  inherited;
end;

//
// Wrapper for Lua File load and Execution
//
// @param       String  Filename        Lua Script file name
// @return      Integer
//
function TLua.DoFile(Filename: String): Integer;
begin
  try
    Result := lual_dofile(LuaInstance, PAnsiChar(AnsiString(Filename)));
  except
    Result:=-1;
  end;
end;


function TLua.DoString(Scripts: String): Integer;
begin
  try
    Result := luaL_dostring(LuaInstance, PAnsiChar(AnsiString(Scripts)));
  except
    Result:=-1;
  end;
end;
//
// Register a new Lua Function and map it to the Objects method name
//
// @param       AnsiString      FuncName        Lua Function Name
// @param       AnsiString      MethodName      (optional) Objects Method name
//
procedure TLua.RegisterFunction(FuncName: AnsiString; MethodName: AnsiString = ''; Obj: TObject = NIL);
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

end;

function TLua.ScriptError: string;
begin
  Result := lua_tostring(LuaInstance, -1);
end;

procedure TLua.Stop;
begin
  lua_close(LuaInstance);
end;

//
// UnRegister all new Lua Function
//
// @param       TObject     Object      Object with prev registered lua functions
//
procedure TLua.UnregisterFunctions(Obj: TObject);
var
  I: Integer;
  CallBack: TCallBack;
begin
  // remove obj from object list
  for I := CallBackList.Count downto 1 do
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

//
// Register all published methods as Lua Functions
//
procedure TLua.AutoRegisterFunctions(Obj: TObject);
type
  PPointer = ^Pointer;
  PMethodRec = ^TMethodRec;

  TMethodRec = packed record
    wSize: Word;
    pCode: Pointer;
    sName: ShortString;
  end;
var
  MethodTable: PAnsiChar;
  MethodRec: PMethodRec;
  wCount: Word;
  nMethod: Integer;
begin
  // Get a pointer to the class's published method table
  MethodTable := PAnsiChar(Pointer(PAnsiChar(Obj.ClassType) + vmtMethodTable)^);

  if (MethodTable <> Nil) then
  begin
    // Get the count of the methods in the table
    Move(MethodTable^, wCount, 2);

    // Position the MethodRec pointer at the first method in the table
    // (skip over the 2-byte method count)
    MethodRec := PMethodRec(MethodTable + 2);

    // Iterate through all the published methods of this class
    for nMethod := 0 to wCount - 1 do
    begin
      // Add the method name to the lua functions
      RegisterFunction(MethodRec.sName, MethodRec.sName, Obj);
      // Skip to the next method
      MethodRec := PMethodRec(PAnsiChar(MethodRec) + MethodRec.wSize);
    end;
  end;
end;


end.