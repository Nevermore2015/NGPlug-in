unit LuaMain;

interface
uses
  windows,Classes,SysUtils,Lua,LuaLib,GD_Utils;


{$DEFINE LUA_DBG}

{$IFDEF LUA_DBG}
{$MESSAGE HINT '内部调试版本'}
{$ENDIF}
const
  ScriptCfg = 'Init.lua';


type
  _LuaCfg = Packed Record
    Lv:Byte;
    Account:String;
    Psw:String;
    LuaFile:String;
    SaveHp:Cardinal;   //保护血量
    ItemNum:Cardinal;  //物品数量
    ItemRes:Cardinal;  //物品资源ID
    IsRichang:BOOL;
    Token:String;
    AutoOpenBox:Bool;  //自动开箱子
    Mode:Integer;
  end;
  _MarkNode = Packed record
    Mark:String;
    Line:Cardinal;
  end;

  _MarkData = packed Record
    Count:Cardinal;
    MarkNode:array [0..200] of _MarkNode;
  End;

  _Exception = packed record
    Code:Integer;
    Str:String;
  end;

  FPrintf = Procedure (s: string; args: array of const);Stdcall;
{$M+}
type
  TScriptMain = class(TLua)
    private
       ScriptStr:TStringList;
       MarkData:_MarkData;

       procedure Printf(s: string; args: array of const);
       procedure WaitTime(n:Cardinal = 500);
       function GameMoveEx(x, y: Single;TryMax:Cardinal = 20): Bool;
    published     {脚本实现}
      {系统}
      function LoadCfg(L: lua_State):Integer;
      function LogOutput(L: lua_State):Integer;
      function GetLuaDir(L: lua_State):Integer;
      function Wait(L: lua_State):Integer;
      function GetSaveCfg(L: lua_State):Integer;

      function ReportState(L: lua_State):Integer;

      function GotoMark(L: lua_State): Integer;
      function SetMark(L: lua_State): Integer;
      {游戏功能}

       {保护}

      function SetProtect(L : lua_State):Integer;
    public
      LuaCfg:_LuaCfg;
      DoLine:Integer;  //当前执行行号
      //脚本执行结束标志
      RunOver:Bool;
      //脚本执行错误
      ErrorInfo:_Exception;
      constructor Create();

      //脚本引擎初始化
      Function InitScriptEngine(ScriptFile:String):Bool;

      Function DoScript():Integer;
  end;

{$M-}

 // Procedure ScriptThread();

implementation

{ TScriptMain }


procedure TScriptMain.Printf(s: string; args: array of const);
begin
  LogPrintf(S,Args);
end;

function TScriptMain.ReportState(L: lua_State): Integer;
begin
  {$i vmp_begin.inc}

  Result:=0;
  {$i vmp_end.inc}
end;



function TScriptMain.SetProtect(L: lua_State): Integer;
begin
  LuaCfg.SaveHp:=lua_tointeger(L,1);
  LuaCfg.ItemRes:=lua_tointeger(L,2);
  {$IFDEF LUA_DBG}
  Printf('设定保护->HP:%d RES:%X',[
  LuaCfg.SaveHp,LuaCfg.ItemRes
  ]);
  {$ENDIF}
  Result:=0;
end;

function TScriptMain.Wait(L: lua_State): Integer;
begin
  {$IFDEF LUA_DBG}
  Printf('等待:%d',[lua_tointeger(L,1)]);
  {$ENDIF}
 WaitTime(lua_tointeger(L,1));
 Result:=0;
end;


procedure TScriptMain.WaitTime(n:Cardinal = 500);
begin
  Sleep(n);
end;


constructor TScriptMain.Create;
begin
  inherited Create(False);
  {$i vmp_begin.inc}
  //*******************************************框架基本****************************//
  RegisterFunction('跳转标记','GotoMark');
  RegisterFunction('标记','SetMark');
  RegisterFunction('获取脚本目录', 'GetLuaDir');      //+
  RegisterFunction('日志', 'LogOutput');              //+
  RegisterFunction('等待', 'Wait');
  //*******************************************移动相关****************************//
  RegisterFunction('加载配置', 'LoadCfg');            //+  挂机过程中所有的配置
  RegisterFunction('设置保护', 'SetProtect');         //+

  //******************************************系统相关****************************//
  RegisterFunction('报告状态', 'ReportState');        //+  发送数据给控制台

  Dbgprint('Script Engine Load Over',[]);
  {$i vmp_end.inc}
end;



Function TScriptMain.GameMoveEx(x,y:Single;TryMax:Cardinal = 20):Bool;
var
  Long:Single;
  TryTime:Cardinal;
  TimeTick:Cardinal;
begin
  {$IFDEF LUA_DBG}
  Printf('移动 -> %.3f,%.3f',[x,y]);
  {$ENDIF}
 // game.GameMove(x,y);
  Sleep(2000);
//  Long:=A2B(Role.info.x,Role.info.y,x,y);
  TryTime:=0;
  Result:=True;
  TimeTick:=GetTickCount();
  while Long > 30 do
    begin
    
    {  if Role.MoveState = 0 then
        begin
          TimeTick:=GetTickCount();
          Inc(TryTime);
          game.GameMove(x,y);
          Sleep(2000);
          {$IFDEF LUA_DBG}
         // Printf('移动修正调用 重试:%d 距离目标:%.3f',[TryTime,Long]);     }
         // {$ENDIF}
       // end;
      if  TryTime > TryMax then
        begin
          Result:=False;
          Break;
        end;
      if (GetTickCount - TimeTick) > (60 * 1000) then
        begin
          TimeTick:=GetTickCount();
          Inc(TryTime);
          //game.GameMove(x,y);
          {$IFDEF LUA_DBG}
          Printf('移动超时调用 重试:%d 距离目标:%.3f',[TryTime,Long]);
          {$ENDIF}
        end;
      WaitTime(2000);
    //  Long:=A2B(Role.info.x,Role.info.y,x,y);
    end;
  {$IFDEF LUA_DBG}
  //Printf('移动结束 耗时:%d',[GetTickCount - CountTick]);
  {$ENDIF}
end;




function TScriptMain.LoadCfg(L: lua_State): Integer;
begin
  {$i vmp_begin.inc}
  lua_getglobal(L,'g_Hp');                 // 保护血量
  lua_getglobal(L,'g_Acc');                // 账号
  lua_getglobal(L,'g_Psw');                // 密码
  lua_getglobal(L,'g_Token');              // 令牌
  lua_getglobal(L,'g_Num');                // 血瓶数量
  lua_getglobal(L,'g_Res');                // 血瓶资源ID
  lua_getglobal(L,'g_Lv');                 // 需求等级
  lua_getglobal(L,'g_Lua');                // 脚本文件
  lua_getglobal(L,'g_IsRichang');          // 是否日常脚本

  LuaCfg.SaveHp:= lua_tointeger(L,1);
  LuaCfg.Account:= lua_tostring(L,2);
  LuaCfg.Psw:= lua_tostring(L,3);
  LuaCfg.Token:= lua_tostring(L,4);
  LuaCfg.ItemNum := lua_tointeger(L,5);
  LuaCfg.ItemRes := lua_tointeger(L,6);
  LuaCfg.Lv:= lua_tointeger(L,7);
  LuaCfg.IsRichang:= lua_toboolean(L,9);
  Result:=0;
  {$i vmp_end.inc}
end;

function TScriptMain.LogOutput(L: lua_State): Integer;
begin
  {$i vmp_begin.inc}
  LogPrintf('%s',[lua_tostring(L,1)]);
  Printf('%s',[lua_tostring(L,1)]);
  Result:=0;
  {$i vmp_end.inc}
end;


function TScriptMain.GetLuaDir(L: lua_State): Integer;
begin
  //lua_pushstring(L,PChar(g_LuaDir));
  Result:=1;
end;

function TScriptMain.GetSaveCfg(L: lua_State): Integer;
begin
  lua_pushinteger(L,LuaCfg.ItemRes);
  lua_pushinteger(L,LuaCfg.ItemNum);
  Result:=2;
end;

function TScriptMain.GotoMark(L: lua_State): Integer;
var
  i,Tmp:Integer;
  Str:String;
begin
  Str:=Lua_tostring(L,1);
  Tmp:=DoLine;
  if MarkData.Count > 0 then
    begin
      for i := 0 to MarkData.Count - 1 do
        begin
          if MarkData.MarkNode[i].Mark = Str then
            begin
              DoLine:=MarkData.MarkNode[i].Line;
              Break;
            end;
        end;
    end;

  if DoLine = Tmp then
    begin
      ErrorInfo.Code := -1;
      ErrorInfo.Str := '标签未找到';
    end;
  Result:=0;
end;

function TScriptMain.SetMark(L: lua_State): Integer;
var
  Str:String;
begin
  Str:=Lua_tostring(L,1);
  MarkData.MarkNode[MarkData.Count].Mark := Str;
  MarkData.MarkNode[MarkData.Count].Line := DoLine;
  inc(MarkData.Count);
  Result:=0;
end;


function TScriptMain.InitScriptEngine(ScriptFile:String): Bool;
begin
  try
    ZeroMemory(@MarkData,SizeOf(_MarkData));
    ScriptStr.LoadFromFile(ScriptFile);
    DoLine:=0;
    ErrorInfo.Code:=0;
    RunOver:=False;
    Result:=True;
  except
    Result:=False;
  end;
end;

function TScriptMain.DoScript: Integer;
var
  Str:string;
begin
  Str:=ScriptStr[DoLine];
  Inc(DoLine);
  if Length(Trim(Str)) <> 0 then
    begin
      Result:=DoString(Str);
    end
  else
    Result:=0;
  if DoLine >= ScriptStr.Count  then RunOver:=True;
end;
end.
