unit UGameAddrManager;

interface
uses
  windows,Classes,SysUtils,superobject,UConfig,IdHTTP,UConsoleProtocol,GD_Utils;

type
  _Addr_Data = packed record
    ModuleName:Array [0..254] of Char;
    Offset:Integer;
  end;
  TGame_Addr_Node = class
    private
      mAddrData:_Addr_Data;
      mTagId:Integer;
      mName:String;
    public
      constructor Create(_TagId:Integer;_Module,_Name:String;_Offset:Integer);

      Function ReadData(P:Pointer):Integer;

      property TagId:Integer read mTagId;
      property Name:String read mName;
  end;

  TGameAddrManager = class
    private
      List:TList;
      mAddressVersion:Integer;
      mGameId:Cardinal;
      mDBid:Cardinal;
    public
      constructor Create();

      Function LoadRemoteData():Integer;

      Function QueryAddressByTagId(TagId:Integer;pBuffer:Pointer):Bool;

      property Version:Integer read mAddressVersion;
  end;
var
  g_GameAddr:TGameAddrManager;
implementation
  uses
    UGlobal;
{ TGameAddrManager }

constructor TGameAddrManager.Create();
begin
  List:=TList.Create;
end;

function TGameAddrManager.LoadRemoteData: Integer;
var
  Http:TIdHTTP;
  Rep:String;
  Jo:ISuperObject;
  ja: TSuperArray;
  i:integer;
  Node:TGame_Addr_Node;
begin
  Result:=0;
  Http:=TIdHTTP.Create(nil);
  try
    try
      Dbgprint('Auth = %s',[Config.AuthUrl]);
      Rep:=Http.Get(Format('%s',[Config.AuthUrl + C_AUTH_CHECK]));
      Jo:=SO(Rep);
      mGameId:= Jo['gameid'].AsInteger;
      mDBId:=Jo['id'].AsInteger;
      mAddressVersion:=Jo['gamever'].AsInteger;

      ja := jo['datas'].AsArray;
      if ja.Length > 0 then
        begin
          Dbgprint('Datas Count=%d',[ja.Length]);
          for i := 0 to ja.Length - 1 do
            begin
              Node:= TGame_Addr_Node.Create(
                ja[i]['tagid'].AsInteger,
                ja[i]['module'].AsString,
                ja[i]['name'].AsString,
                strtoint('$' +ja[i]['value'].AsString)
              );
              List.Add(Node);
            end;
        end;
      Result:=mAddressVersion;
    except
      Dbgprint('Remote Data Get Error',[]);
    end;
  finally
    Http.Free;
  end;
end;

function TGameAddrManager.QueryAddressByTagId(TagId: Integer;
  pBuffer: Pointer): Bool;
var
  pAddr:PResGameAddress;
  i:integer;
  Node:TGame_Addr_Node;
begin
  Result:=False;
  pAddr:=pBuffer;
  if Assigned(pAddr) then
    begin
      if List.Count > 0 then
        begin
          for i := 0 to List.Count - 1 do
            begin
              Node:=List[i];
              if Node.TagId = TagId then
                begin
                  Result:= Node.ReadData(@pAddr.ModuleName) > 0;
                  Break;
                end;
            end;
        end;
    end;
end;

{ TGame_Addr_Node }

constructor TGame_Addr_Node.Create(_TagId: Integer; _Module, _Name: String;
  _Offset: Integer);
begin
  ZeroMemory(@mAddrData,SizeOf(_Addr_Data));
  CopyMemory(@mAddrData.ModuleName,PChar(_Module),Length(_Module));
  mAddrData.Offset:=_Offset;
  mTagId:=_TagId;
  mName:=_Name;

  Dbgprint('TagId:%d Name:%s Module:%s Offset:0x%X',[
    mTagId,
    mName,
    mAddrData.ModuleName,
    mAddrData.Offset
  ]);
end;

function TGame_Addr_Node.ReadData(P: Pointer): Integer;
begin
  Result:=0;
  if P <> nil then
    begin
      CopyMemory(p,@mAddrData,SizeOf(_Addr_Data));
      Result:=SizeOf(_Addr_Data);
    end;
end;

initialization
  g_GameAddr:=TGameAddrManager.Create;
end.
