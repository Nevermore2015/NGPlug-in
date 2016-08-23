unit UGameObjBase;

interface
uses
  Windows,Classes,SyncObjs,UGamePacket;

type

  TGameObjNode = class
     private
       mId:Int64;
       mName:String;
     public
       constructor Create(_Id:Int64;_Name:String);

       property Id:Int64 read mId;
       property Name:String read mName;
  end;

  TGameObjBase = class(TGamePacket)
    private
      List:TList;
      Cri:TCriticalSection;

    protected
      Function AddItem(p:Pointer):Integer;
      Function DelItem(p:Pointer):Integer;

    public
      constructor Create(HandleName:String);

      Procedure Clear();
      Function GetObjById(Id:Int64):TGameObjNode;
      Function GetObjByName(Name:String):TGameObjNode;
      Function GetObjByIndex(Idx:Integer):TGameObjNode;
      
      Procedure OnRecv(pBuffer:Pointer;Len:Cardinal);override;
      Procedure OnSend(pBuffer:Pointer;Len:Cardinal);override;
  end;

implementation

{ TGameBaseObj }

function TGameObjBase.AddItem(p:Pointer): Integer;
begin
  Cri.Enter;
  List.Add(p);
  Result:=List.Count;
  Cri.Leave;
end;

procedure TGameObjBase.Clear;
var
  i:Integer;
begin
  Cri.Enter;
  for i := 0 to List.Count - 1 do
    begin
      TObject(List[i]).Free;
    end;
  List.Clear;
  Cri.Leave;
end;

constructor TGameObjBase.Create(HandleName: String);
begin
 inherited Create(HandleName);

 List:=TList.Create;
 Cri:=TCriticalSection.Create;
 
end;

function TGameObjBase.DelItem(p: Pointer): Integer;
begin
  Cri.Enter;
  TObject(p).Free;
  List.Remove(p);
  Result:=List.Count;
  Cri.Leave;
end;

function TGameObjBase.GetObjById(Id: Int64): TGameObjNode;
var
  i:Integer;
  pNode:TGameObjNode;
begin
  Result:=nil;
  Cri.Enter;
  for i := 0 to List.Count - 1 do
    begin
      pNode := List[i];
      if pNode.Id = Id then
        begin
          Result:= pNode;
          Break;
        end;
    end;
  Cri.Leave;
end;

function TGameObjBase.GetObjByIndex(Idx: Integer): TGameObjNode;
begin
  Result:=nil;
  Cri.Enter;
  if Idx < List.Count then
    Result:= List[Idx];
  Cri.Leave;
end;

function TGameObjBase.GetObjByName(Name: String): TGameObjNode;
var
  i:Integer;
  pNode:TGameObjNode;
begin
  Result:=nil;
  Cri.Enter;
  for i := 0 to List.Count - 1 do
    begin
      pNode := List[i];
      if pNode.Name = Name then
        begin
          Result:= pNode;
          Break;
        end;
    end;
  Cri.Leave;
end;

procedure TGameObjBase.OnRecv(pBuffer: Pointer; Len: Cardinal);
begin
  inherited;
end;

procedure TGameObjBase.OnSend(pBuffer: Pointer; Len: Cardinal);
begin
  inherited;
end;

{ TGameObjNode }

constructor TGameObjNode.Create(_Id: Int64; _Name: String);
begin
  mId:=_Id;
  mName:=_Name;
end;

end.
