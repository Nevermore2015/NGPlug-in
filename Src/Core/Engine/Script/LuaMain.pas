unit LuaMain;

interface
uses
  windows,Classes,SysUtils,Lua,LuaLib,GD_Utils;


{$DEFINE LUA_DBG}

{$IFDEF LUA_DBG}
{$MESSAGE HINT '�ڲ����԰汾'}
{$ENDIF}
const
  ScriptCfg = 'Init.lua';


type
  _LuaCfg = Packed Record
    Lv:Byte;
    Account:String;
    Psw:String;
    LuaFile:String;
    SaveHp:Cardinal;   //����Ѫ��
    ItemNum:Cardinal;  //��Ʒ����
    ItemRes:Cardinal;  //��Ʒ��ԴID
    IsRichang:BOOL;
    Token:String;
    AutoOpenBox:Bool;  //�Զ�������
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
    published     {�ű�ʵ��}
      {ϵͳ}
      function LoadCfg(L: lua_State):Integer;
      function LogOutput(L: lua_State):Integer;
      function GetLuaDir(L: lua_State):Integer;
      function Wait(L: lua_State):Integer;
      function GetSaveCfg(L: lua_State):Integer;

      function ReportState(L: lua_State):Integer;

      function GotoMark(L: lua_State): Integer;
      function SetMark(L: lua_State): Integer;
      {��Ϸ����}

       {����}

      function SetProtect(L : lua_State):Integer;
    public
      LuaCfg:_LuaCfg;
      DoLine:Integer;  //��ǰִ���к�
      //�ű�ִ�н�����־
      RunOver:Bool;
      //�ű�ִ�д���
      ErrorInfo:_Exception;
      constructor Create();

      //�ű������ʼ��
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
  Printf('�趨����->HP:%d RES:%X',[
  LuaCfg.SaveHp,LuaCfg.ItemRes
  ]);
  {$ENDIF}
  Result:=0;
end;

function TScriptMain.Wait(L: lua_State): Integer;
begin
  {$IFDEF LUA_DBG}
  Printf('�ȴ�:%d',[lua_tointeger(L,1)]);
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
  //*******************************************��ܻ���****************************//
  RegisterFunction('��ת���','GotoMark');
  RegisterFunction('���','SetMark');
  RegisterFunction('��ȡ�ű�Ŀ¼', 'GetLuaDir');      //+
  RegisterFunction('��־', 'LogOutput');              //+
  RegisterFunction('�ȴ�', 'Wait');
  //*******************************************�ƶ����****************************//
  RegisterFunction('��������', 'LoadCfg');            //+  �һ����������е�����
  RegisterFunction('���ñ���', 'SetProtect');         //+

  //******************************************ϵͳ���****************************//
  RegisterFunction('����״̬', 'ReportState');        //+  �������ݸ�����̨

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
  Printf('�ƶ� -> %.3f,%.3f',[x,y]);
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
         // Printf('�ƶ��������� ����:%d ����Ŀ��:%.3f',[TryTime,Long]);     }
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
          Printf('�ƶ���ʱ���� ����:%d ����Ŀ��:%.3f',[TryTime,Long]);
          {$ENDIF}
        end;
      WaitTime(2000);
    //  Long:=A2B(Role.info.x,Role.info.y,x,y);
    end;
  {$IFDEF LUA_DBG}
  //Printf('�ƶ����� ��ʱ:%d',[GetTickCount - CountTick]);
  {$ENDIF}
end;




function TScriptMain.LoadCfg(L: lua_State): Integer;
begin
  {$i vmp_begin.inc}
  lua_getglobal(L,'g_Hp');                 // ����Ѫ��
  lua_getglobal(L,'g_Acc');                // �˺�
  lua_getglobal(L,'g_Psw');                // ����
  lua_getglobal(L,'g_Token');              // ����
  lua_getglobal(L,'g_Num');                // Ѫƿ����
  lua_getglobal(L,'g_Res');                // Ѫƿ��ԴID
  lua_getglobal(L,'g_Lv');                 // ����ȼ�
  lua_getglobal(L,'g_Lua');                // �ű��ļ�
  lua_getglobal(L,'g_IsRichang');          // �Ƿ��ճ��ű�

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
      ErrorInfo.Str := '��ǩδ�ҵ�';
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
