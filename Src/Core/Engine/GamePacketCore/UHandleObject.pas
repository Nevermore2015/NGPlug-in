unit UHandleObject;

interface
uses
  Windows,Classes,SyncObjs,UPacketManager,UProtocol;

type

  THandleObjct = class
    private
      mHandleName:String;
    public
      constructor Create(_HandleName:String);

      Procedure OnRecv(_PacketObject:PPacketObject);virtual;
      Procedure OnSend(_PacketObject:PPacketObject);virtual;

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

procedure THandleObjct.OnRecv(_PacketObject: PPacketObject);
begin
  //
end;

procedure THandleObjct.OnSend(_PacketObject: PPacketObject);
begin
  //
end;

end.
