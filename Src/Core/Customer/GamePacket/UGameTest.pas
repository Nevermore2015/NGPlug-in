unit UGameTest;

interface
uses
   UHandleObject,UDemoScript,UProtocol;

type
   TGameTest = class(THandleObjct)
     private
       DemoScript:TDemoScript;
     public
       constructor Create();

       //Procedure OnRecv(_PacketObject:PPacketObject);override;
       //Procedure OnSend(_PacketObject:PPacketObject);override;
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
{
procedure TGameTest.OnRecv(_PacketObject:PPacketObject);
begin
  Dbgprint('rrrrr',[]);
end;



procedure TGameTest.OnSend(_PacketObject:PPacketObject);
begin
  Dbgprint('sssss',[]);

end;   }

initialization
   GameTest:=TGameTest.Create;
end.
