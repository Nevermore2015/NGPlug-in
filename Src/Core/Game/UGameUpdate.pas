unit UGameUpdate;
{
    游戏更新单元
    支持云更新
}
interface
uses
  Windows,Classes,SysUtils,IdHTTP,IniFiles;


type
  PGameAddress = ^_GameAddress;
  _GameAddress = packed Record
    Name:array [0..100] of Char;
    Address:Cardinal;
  End;

  TGameUpdate = class
    private
      mHttp:TIdHTTP;
      mUpdateUrl:String;
      mAddressList:TStringHash;
      procedure LoadAddress();
      procedure OnUpdate();
      procedure AddAddress(Args:String);
    public
      constructor Create();
      destructor Destroy; override;

      function GetAddressByName(Name:String):Cardinal;
  end;
var
  Update:TGameUpdate;
implementation
uses
   uConfig,GD_Utils;
{ TGameUpdate }

procedure TGameUpdate.AddAddress(Args: String);
var
  Str:TStringlist;
begin
  Str:=TStringList.Create;
  try
    Str.Delimiter:='|';
    Str.DelimitedText:=Args;
    if Str.Count > 1 then
      begin
        mAddressList.Add(Str[0],Strtoint(Str[1]));
      end;
  finally
    Str.Free;
  end;
end;

constructor TGameUpdate.Create;
begin
  mAddressList:=TStringHash.Create;
  mHttp:=TIdHTTP.Create(nil);
  mHttp.ReadTimeout:=5000;
  mUpdateUrl:= Config.UpdateUrl;
  OnUpdate();
end;

destructor TGameUpdate.Destroy;
begin
  mHttp.Free;
end;

function TGameUpdate.GetAddressByName(Name: String): Cardinal;
begin
  Result:= mAddressList.ValueOf(Name);
end;

procedure TGameUpdate.LoadAddress;
begin
  AddAddress('0|0');
end;

procedure TGameUpdate.OnUpdate;
var
  ResString:String;
  i:Integer;
  Str:TStringList;
begin
  LogPrintf('Load Address:%s',[mUpdateUrl]);
  if mUpdateUrl = '' then
    begin
      LoadAddress();
    end
  else
    begin
      ResString:=mHttp.Get(mUpdateUrl);
      if Length(ResString) > 10 then
        begin
          //解密

          //解析
          Str:=TStringList.Create;
          try
            Str.Delimiter:=',';
            Str.DelimitedText:=ResString;
            for i := 0 to Str.Count - 1 do
              begin
                AddAddress(Str[i]);
              end;
          finally
            Str.Free
          end;
        end;
    end;
end;

end.
