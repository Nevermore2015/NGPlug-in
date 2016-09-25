unit UProtocol;
{
  协议类，不可缺少
}
interface
uses
  windows;

type
  //封包数据结构，用户可以根据游戏的数据结构进行调整
  PPacketObject = ^TPacketObject;
  TPacketObject = packed record
    pBuffer:Pointer;
    BufferSize:Cardinal;
  end;
{************************游戏内封包结构*******************************}



{************************游戏内封包协议*******************************}

//获取协议ID
Function GetProtocolId(pBuffer:Pointer):Integer;

implementation

Function GetProtocolId(pBuffer:Pointer):Integer;
begin
  Result:=pInteger(pBuffer)^;
end;
end.
