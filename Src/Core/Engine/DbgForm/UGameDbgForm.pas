unit UGameDbgForm;

interface
uses
   UHandleObject,UProtocol;

type
   TGameDbgForm = class(THandleObjct)
     public
       constructor Create();

       Procedure OnRecv(_PacketObject:PPacketObject);override;
       Procedure OnSend(_PacketObject:PPacketObject);override;
   end;

var
   GameDbgForm:TGameDbgForm;
implementation
uses
  GD_Utils,UDbgForm;
{ TGameTest }

constructor TGameDbgForm.Create;
begin
  inherited Create('DbgForm');
end;

procedure TGameDbgForm.OnRecv(_PacketObject:PPacketObject);
begin
  DbgForm.OnRecv(_PacketObject.pBuffer,_PacketObject.BufferSize);
end;



procedure TGameDbgForm.OnSend(_PacketObject:PPacketObject);
begin
  DbgForm.OnSend(_PacketObject.pBuffer,_PacketObject.BufferSize);
end;

initialization
   GameDbgForm:=TGameDbgForm.Create;
end.
