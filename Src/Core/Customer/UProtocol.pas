unit UProtocol;
{
  Э���࣬����ȱ��
}
interface
uses
  windows;

type
  //������ݽṹ���û����Ը�����Ϸ�����ݽṹ���е���
  PPacketObject = ^TPacketObject;
  TPacketObject = packed record
    pBuffer:Pointer;
    BufferSize:Cardinal;
  end;
{************************��Ϸ�ڷ���ṹ*******************************}



{************************��Ϸ�ڷ��Э��*******************************}

//��ȡЭ��ID
Function GetProtocolId(pBuffer:Pointer):Integer;

implementation

Function GetProtocolId(pBuffer:Pointer):Integer;
begin
  Result:=pInteger(pBuffer)^;
end;
end.
