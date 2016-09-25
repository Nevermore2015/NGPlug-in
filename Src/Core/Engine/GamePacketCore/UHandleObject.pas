unit UHandleObject;
{
  封包分发对象基类
  用户继承后可以扩展为对单一协议的解析
}
interface
uses
  Windows,UPacketManager,UProtocol;

type

  THandleObjct = class
    private
      mHandleName:String;
    protected
      Function GetProtocol(pBuffer:Pointer):Integer;
    public
      constructor Create(_HandleName:String);

      Procedure OnRecv(_PacketObject:PPacketObject);virtual;abstract;
      Procedure OnSend(_PacketObject:PPacketObject);virtual;abstract;

      property HandleName:String read mHandleName;
  end;

implementation

{ TGameBaseObj }

constructor THandleObjct.Create(_HandleName: String);
begin
  Packet.AddItem(C_SEND_PACKET,'s_' + HandleName,OnSend);
  Packet.AddItem(C_RECV_PACKET,'r_' +HandleName,OnRecv);
  mHandleName:=_HandleName;
end;

function THandleObjct.GetProtocol(pBuffer: Pointer): Integer;
begin
  Result:=GetProtocolId(pBuffer);
end;

end.
