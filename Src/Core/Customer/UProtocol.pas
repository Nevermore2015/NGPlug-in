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

implementation


end.
