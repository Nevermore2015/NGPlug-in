unit UConsoleSDK;

interface
uses
  windows,WinSock,GD_Utils,UNgPlugConfig,UConsoleProtocol;

type
  TConsoleNet = class
    private
      mToken:INT64;
      mActive:Bool;
      mPid:Cardinal;
      mIp:String;
      mPort:Integer;
      mSocket:Cardinal;
      mGameVersion:Integer;
      Function ConnConsole():Bool;
      function GetToken:Cardinal;
    public
      constructor Create(_Ip:string;_Port:Integer;_Pid:Cardinal);

      Function RequestGameAddress(_TagId:Integer):Cardinal;

      property Active:Bool read mActive;
      property Token:Int64 read mToken;
      property GameVersion:Integer read mGameVersion;
  end;

var
  g_ConsoleNet:TConsoleNet;

implementation

{ TConsoleNet }

function TConsoleNet.ConnConsole: Bool;
var
  Wsstatus:integer;
  Rece:TWSAData;
  SocketObj:TSocket;
  Ser:TSockAddr;
begin
  Result:= False;
  Wsstatus:=WSAStartup($202,Rece);
   try
     if Wsstatus = 0 then
       begin
         SocketObj:=socket(AF_INET,SOCK_STREAM,0);
         if SocketObj >= 0 then
           begin
             Ser.sa_family:= AF_INET;
             Ser.sin_port:=htons(mPort);
             Ser.sin_addr.S_addr:=inet_addr(PChar(mIp));
             if Wsstatus = 0 then
               begin
                 Wsstatus := Connect(SocketObj,Ser,SizeOf(Ser));
                 if Wsstatus = 0 then
                   begin
                     mSocket:= SocketObj;
                     mToken:=GetToken();
                     Result:=mToken <> 0;
                   end;
               end;
           end;
       end;
   finally
     //WSACleanup();
   end;
end;

constructor TConsoleNet.Create(_Ip: string; _Port: Integer;_Pid:Cardinal);
begin
  mToken:=0;
  mGameVersion:=0;
  mIp:=_Ip;
  mPort:=_Port;
  mPid:=_Pid;
  mActive:=ConnConsole();
end;

function TConsoleNet.GetToken: Cardinal;
var
  Buffer:_Req_Token;
  RepBuffer:_Res_Token;
begin
  Result:= 0;
  Buffer.Head.Cmd := c_Req_Token;
  Buffer.Head.Pid:=mPid;
  Buffer.Head.Size:= SizeOf(_Req_Token);
  Buffer.Head.ErrorCode:=0;
  Buffer.Head.Tick:=GetTickCount;
  if send(mSocket,Buffer,Buffer.Head.Size,0) = Buffer.Head.Size then
    begin
      if recv(mSocket,RepBuffer,SizeOf(_Res_Token),0) > 0 then
        begin
         // Dbgprint('<-Console-> %d Token = 0x%X',[RepBuffer.GameVer,
         // RepBuffer.Token]);
          if RepBuffer.Head.ErrorCode = 0 then
            begin
              Result:= RepBuffer.Token;
              mGameVersion:=RepBuffer.GameVer;
            end;
        end;
    end;
end;

function TConsoleNet.RequestGameAddress(_TagId: Integer): Cardinal;
var
  Buffer:_req_game_address;
  RepBuffer:_res_game_address;
  Module:Cardinal;
begin
  Result:=0;
  Buffer.Head.Cmd := c_Req_Game_Address;
  Buffer.Head.Pid:=mPid;
  Buffer.Head.Size:= SizeOf(_req_game_address);
  Buffer.Head.ErrorCode:=0;
  Buffer.Head.Tick:=GetTickCount;
  Buffer.TagId:=_TagId;
  if send(mSocket,Buffer,Buffer.Head.Size,0) = Buffer.Head.Size then
    begin
      if recv(mSocket,RepBuffer,SizeOf(_res_game_address),0) > 0 then
        begin
          if RepBuffer.Head.ErrorCode = 0 then
            begin
              if RepBuffer.TagId = _TagId then
                begin
                  Module:=GetModuleHandle(RepBuffer.ModuleName);
                 // Dbgprint('GetModule:%s [%X]',[RepBuffer.ModuleName,Module]);
                  if Module <> 0 then
                     Result:= Module + RepBuffer.Offset;
                end;
            end;
        end;
    end;
end;

end.
