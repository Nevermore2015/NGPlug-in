unit UGameDBManager;

{
  游戏数据管理类

  可使用 CreateNewDataType 创建一个数据集对象
    数据集对象内 可存放数据对象,对象的结构由用户自行定义

  可使用 QueryDataByTypeId 查询一个数据集对象
}
interface
uses
  Windows,Classes,SyncObjs,UGameDataBase;

type

  TGameDBManager = class
    private
      mList:TList;
      mCri:TCriticalSection;
    public
      constructor Create();
      //创建数据对象
      Function CreateNewDataType(_DataName:string;_DataType:Cardinal):TGameDataBase;
      //查询数据对象
      Function QueryDataByTypeId(_DataType:Cardinal):TGameDataBase;
  end;

var
  g_GameDB:TGameDBManager;
implementation


{ TGameDBManager }

constructor TGameDBManager.Create;
begin
  mList:=TList.Create;
  mCri:=TCriticalSection.Create;
end;

function TGameDBManager.CreateNewDataType(_DataName: string;
  _DataType: Cardinal): TGameDataBase;
var
  pNode:TGameDataBase;
begin
  pNode:=TGameDataBase.Create(_DataName,_DataType);
  mCri.Enter;
  mList.Add(pNode);
  mCri.Leave;
  Result:=pNode;
end;

function TGameDBManager.QueryDataByTypeId(_DataType: Cardinal): TGameDataBase;
var
  pNode:TGameDataBase;
  i:integer;
begin
  Result:= Nil;
  mCri.Enter;
  if mList.Count > 0 then
    begin
      for i := 0 to mList.Count - 1 do
        begin
          pNode:=mList[i];
          if pNode.DataType = _DataType then
            begin
              Result:= pNode;
              Break;
            end;
        end;
    end;
  mCri.Leave;
end;

initialization
  g_GameDB:=TGameDBManager.Create;

end.
