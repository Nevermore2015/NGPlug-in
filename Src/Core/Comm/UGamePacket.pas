unit UGamePacket;

interface
uses
  windows;

type
  TGamePacket = class
    public
       constructor Create(HandleName:String);

       Procedure OnSend(pBuffer:Pointer;Len:Cardinal);virtual;abstract;
       Procedure OnRecv(pBuffer:Pointer;Len:Cardinal);virtual;abstract;
  end;
implementation
uses
  UPacketManager,GD_Utils;


{ TGamePacket }

constructor TGamePacket.Create(HandleName: String);
begin
  Packet.AddItem(C_SEND_PACKET,'s_' + HandleName,OnSend);
  Packet.AddItem(C_RECV_PACKET,'r_' +HandleName,OnRecv);
end;

end.
