unit UGameDataBase;

interface
uses
  Windows,Classes,SyncObjs;
const
  C_WORLD_DATA    =     2000;
  C_ITEM_DATA     =     2001;
  C_HERO_DATA     =     2002;

  C_ACT_DATA_DEL  =     10;
  C_ACT_DATA_SUCC =     20;
  C_ACT_DATA_ERR  =     30;
type
  FActionItemCallBack = function (ItemIndex:Integer;pNode:Pointer):Integer of object;

  TGameDataBase = class
    private
      mDataName:string;
      mDataType:Cardinal;
      mList:TList;
      mCri:TCriticalSection;
      function GetDataCount: Cardinal;
    public
      constructor Create(_DataName:string;_DataType:Cardinal);

      destructor Destroy; override;
      {��Ӷ���}
      function AddItem(P:Pointer):Integer;
      {��������,ʹ�ûص�����ʵ�֣����Ҫɾ��������ص�����C_ACT_DATA_DEL����}
      function ActionItem(ActionItemCallBack:FActionItemCallBack):Integer;
      {��ն����б�}
      procedure Clear();

      {��������}
      property DataType:Cardinal read mDataType;
      {��������}
      property DataCount:Cardinal read GetDataCount;
  end;
implementation

{ TGameDataBase }

function TGameDataBase.ActionItem(ActionItemCallBack: FActionItemCallBack): Integer;
var
  i:Integer;
  Res:Integer;
begin
  Result:= C_ACT_DATA_ERR;
  try
    try
      if mList.Count > 0 then
        begin
          for i := mList.Count - 1 downto 0 do
            begin
              if Assigned(ActionItemCallBack) then
                begin
                  Res:=ActionItemCallBack(i,mList[i]);
                  case Res of
                    C_ACT_DATA_DEL:begin
                                     TObject(mList[i]).Free;
                                     mList.Delete(i);
                                     Result:=C_ACT_DATA_SUCC;
                                   end;
                  else
                    Result:=C_ACT_DATA_SUCC;
                  end;
                end;
            end;
        end;
    except
      Result:=-1;
    end;
  finally
    mCri.Leave;
  end;
end;

function TGameDataBase.AddItem(P: Pointer): Integer;
begin
  mCri.Enter;
  Result:=mList.Add(p);
  mCri.Leave;
end;

procedure TGameDataBase.Clear;
var
  i:Integer;
begin
  mCri.Enter;
  if mList.Count > 0 then
    begin
      for I := 0 to mList.Count - 1 do
        begin
          TObject(mList[i]).Free;
        end;
      mList.Clear;
    end;
  mCri.Leave;
end;

constructor TGameDataBase.Create(_DataName:string;_DataType:Cardinal);
begin
  mDataType:=_DataType;
  mDataName:=_DataName;
  mList:=TList.Create;
  mCri:=TCriticalSection.Create;
end;

destructor TGameDataBase.Destroy;
begin
  inherited;
  Clear;
  mList.Free;
  mCri.Free;
end;

function TGameDataBase.GetDataCount: Cardinal;
begin
  Result:= mList.Count;
end;

end.
