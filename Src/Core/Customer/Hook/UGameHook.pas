unit UGameHook;

interface
uses
  Windows,UHookLib,UProtocol;

type
  FAPIPacketEx = Function (SocketId:Cardinal;pBuffer:Pointer;Len:Cardinal;Flag:Cardinal):Integer;stdcall;
  FGamePacketEx = Function (pBuffer:Pointer;Len:Integer):Integer;stdcall;

var
  pOldGameSend:FGamePacketEx;
  pOldGameRecv:FGamePacketEx;
  _GameSendEcx:Cardinal;


  pWs_Send:FAPIPacketEx;
Procedure StartHook();

implementation
uses
  UPacketManager,GD_Utils;

function MakePacketObject(PacketType:Cardinal;p:Pointer;Len:Cardinal):PPacketObject;
var
  PacketObject:TPacketObject;
begin
  PacketObject.pBuffer:=p;
  PacketObject.BufferSize:=Len;
  case PacketType of
     C_SEND_PACKET:
       Packet.OnSendHandle(@PacketObject);
     C_RECV_PACKET:
       Packet.OnRecvHandle(@PacketObject);
  end;
end;

Function OnMySend(pBuffer:Pointer;Len:Integer):Integer;Stdcall;
begin
  asm
    Mov _GameSendEcx,Ecx
  end;
  MakePacketObject(C_SEND_PACKET,pBuffer,Len);
  asm
    Mov Ecx,_GameSendEcx
  end;
  Result:=pOldGameSend(pBuffer,Len);
end;

Function OnMyRecv(pBuffer:Pointer;Len:Integer):Integer;Stdcall;
begin
  Result:=pOldGameRecv(pBuffer,Len);
  MakePacketObject(C_RECV_PACKET,pBuffer,Len);
end;



Procedure StartHook();
var
  Res:Bool;
begin
  LogPrintf('Execute Hook Proc Success',[]);
end;

end.
