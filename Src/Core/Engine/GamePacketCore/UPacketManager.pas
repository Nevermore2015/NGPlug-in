unit UPacketManager;

interface
uses
  Windows, Classes, SyncObjs ,GD_Utils,UProtocol;

const
  C_SEND_PACKET     =     1000;
  C_RECV_PACKET     =     1001;

  C_PACKET_HANDLE_BREAK = -1;
type


  FPacketProc = Procedure (_PacketObject:PPacketObject) of object;

  TPacketNode = Class
    HandleName:String;
    PacketType:Cardinal;
    Proc:FPacketProc;
  End;

  TPacketManager = class
    private
      Cri:TCriticalSection;
      List:TList;
      Procedure OnPacketHandle(PacketType:Cardinal;_PacketObject:PPacketObject);
      function GetListCount: Cardinal;
    public
      constructor Create();

      Function AddItem(PacketType:Cardinal;HandleName:string; Proc:FPacketProc):Bool;

      Procedure OnSendHandle(_PacketObject:PPacketObject);
      Procedure OnRecvHandle(_PacketObject:PPacketObject);

      property HandleCount:Cardinal read GetListCount;
  end;

var
  Packet:TPacketManager;
implementation

{ TPacketManager }

function TPacketManager.AddItem(PacketType: Cardinal; HandleName:string; Proc: FPacketProc): Bool;
var
  pNode:TPacketNode;
begin
  try
    pNode:=TPacketNode.Create;
    pNode.HandleName := HandleName;
    pNode.PacketType := PacketType;
    pNode.Proc := Proc;

    Dbgprint('Add Packet Handle[Name:%s Proc:0x%X]',[HandleName,Cardinal(@Proc)]);
    Cri.Enter;
    List.Add(pNode);
    Cri.Leave;
    Result:=True;
  Except
    Result:=False;
  end;
end;

constructor TPacketManager.Create;
begin
  List:=TList.Create;
  Cri:=TCriticalSection.Create;
  
end;

function TPacketManager.GetListCount: Cardinal;
begin
  Result:=List.Count;
end;

procedure TPacketManager.OnPacketHandle(PacketType:Cardinal;_PacketObject:PPacketObject);
var
  i:Integer;
  pNode:TPacketNode;
begin
  Cri.Enter;
  for i := 0 to List.Count - 1 do
    begin
      pNode := List[i];
      if pNode.PacketType = PacketType then
        begin
          if Assigned(pNode.Proc) then
           begin
            // Dbgprint('OnPacket[%s] - %X',[pNode.HandleName,Cardinal(@pNode.Proc)]);
             pNode.Proc(_PacketObject);
           end;
        end;
    end;
  Cri.Leave;
end;

procedure TPacketManager.OnRecvHandle(_PacketObject:PPacketObject);
begin
  OnPacketHandle(C_RECV_PACKET,_PacketObject);
end;

procedure TPacketManager.OnSendHandle(_PacketObject:PPacketObject);
begin
  OnPacketHandle(C_SEND_PACKET,_PacketObject);
end;



initialization
  Packet:=TPacketManager.Create;
end.
