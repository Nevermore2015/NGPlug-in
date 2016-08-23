unit UGameHook;

interface
uses
  Windows,UHookLib;

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


Function OnMySend(pBuffer:Pointer;Len:Integer):Integer;Stdcall;
begin
  asm
    Mov _GameSendEcx,Ecx
  end;
  Packet.OnSendHandle(pBuffer,Len);
  asm
    Mov Ecx,_GameSendEcx
  end;
  Result:=pOldGameSend(pBuffer,Len);
end;

Function OnMyRecv(pBuffer:Pointer;Len:Integer):Integer;Stdcall;
begin
  Result:=pOldGameRecv(pBuffer,Len);
  Packet.OnRecvHandle(pBuffer,Len);
end;


Function MyApiSend(SocketId:Cardinal;pBuffer:Pointer;Len:Cardinal;Flag:Cardinal):Integer;stdcall;
begin
  Packet.OnSendHandle(pBuffer,Len);
  Result:=pWs_Send(SocketId,pBuffer,Len,Flag);
end;

Procedure StartHook();
var
  Res:Bool;
begin
  Res:=HookApi('ws2_32.dll','send',@MyApiSend,@pWs_Send);


  if Res then
    LogPrintf('Execute Hook Proc Success',[]);
end;

end.
