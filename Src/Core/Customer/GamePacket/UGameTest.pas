unit UGameTest;

interface
uses
   UGameObjBase,UDemoScript;

type
   TGameTest = class(TGameObjBase)
     private
       DemoScript:TDemoScript;
     public
       constructor Create();

       Procedure OnRecv(pBuffer:Pointer;Len:Cardinal);override;
       Procedure OnSend(pBuffer:Pointer;Len:Cardinal);override;
   end;

var
   GameTest:TGameTest;
implementation
uses
  GD_Utils;
{ TGameTest }

constructor TGameTest.Create;
begin
  inherited Create('Test Handle');
  DemoScript:=TDemoScript.Create;
end;

procedure TGameTest.OnRecv(pBuffer: Pointer; Len: Cardinal);
begin
  Dbgprint('rrrrr',[]);
end;



procedure TGameTest.OnSend(pBuffer: Pointer; Len: Cardinal);
begin
  Dbgprint('sssss',[]);

end;

initialization
   GameTest:=TGameTest.Create;
end.
