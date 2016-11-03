unit UDemoScript;

interface
uses
  UGameScriptBase,GD_Utils;

type
{$M+}
  TDemoScript = class(TGameScriptBase)
    published
      Function NpcTalk(L:TLuaState):Integer;
    public
      constructor Create();
  end;
{$M-}


var
  g_DemoScript:TDemoScript;
implementation

{ TDemoScript }

constructor TDemoScript.Create;
begin
  inherited Create('Demo Script');

  RegisterMethod('Talk','NpcTalk');
end;

function TDemoScript.NpcTalk(L: TLuaState): Integer;
begin
  Dbgprint(ToString(1),[]);
  Result:=0;
end;

initialization
  g_DemoScript:=TDemoScript.Create;
end.
