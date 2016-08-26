unit UGameAddrManager;

interface
uses
  windows,IniFiles,SysUtils,superobject;

type
  TGameAddrManager = class
    private
      AddrMap:TStringHash;
    public
      constructor Create(_Json:String);
  end;
implementation

{ TGameAddrManager }

constructor TGameAddrManager.Create(_Json: String);
begin
  AddrMap:=TStringHash.Create;
end;

end.
