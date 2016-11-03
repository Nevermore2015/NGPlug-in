unit UWorkThread;

interface

uses
  Windows,Classes,WinSock,UConsoleConfig,GD_Utils,UConsoleProtocol;

type
  TWorkThread = class(TThread)
  private
    mCurrentIp:String;
    mCurrentSocket:Cardinal;
    mPid:Cardinal;
    function OnTokenBuffer(_Socket:Cardinal):bool;
    procedure UpdateGUI;
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation
uses
  UMainform,UGameAddrManager;

function TWorkThread.OnTokenBuffer(_Socket: Cardinal): bool;
var
  ReqBuffer:_Req_Token;
  ResBuffer:_res_token;
begin
  Result:=False;
  if recv(mCurrentSocket,ReqBuffer,SizeOf(_Req_Token),0) > 0 then
    begin
      //Dbgprint('Console Recv-> %d',[ReqBuffer.Head.Pid]);
      mPid:=ReqBuffer.Head.Pid;
      ResBuffer.Head.Cmd:= c_Res_Token;
      ResBuffer.Head.Size:= SizeOf(_res_token);
      ResBuffer.Head.Pid:=mPid;
      ResBuffer.Head.ErrorCode:=0;
      ResBuffer.Head.Tick:=GetTickCount;
      ResBuffer.Token:=$CCCCCCCC;
      ResBuffer.GameVer:= g_GameAddr.Version;
      //Dbgprint('Console Send->%d',[send(mCurrentSocket,ResBuffer,ResBuffer.Head.Size,0)]);
      Result:=True;
    end;
end;

procedure TWorkThread.UpdateGUI;
begin
  MainForm.UpdateClientByPid(mPid,mCurrentSocket,mCurrentIp);
end;

procedure TWorkThread.Execute;
var
  Wsstatus:integer;
  Rece:TWSAData;
  SocketObj,ClientObj:TSocket;
  Ser:TSockAddr;
  NewClient:PSOCKADDR;
  NameLen:PInteger;
  iMode:Integer;
begin
   iMode:=1;
   Wsstatus:=WSAStartup($202,Rece);
   try
     if Wsstatus = 0 then
       begin
         SocketObj:=socket(AF_INET,SOCK_STREAM,0);
         if SocketObj >= 0 then
           begin
             ioctlsocket(SocketObj,FIONBIO,iMode);
             Ser.sa_family:= AF_INET;
             Ser.sin_port:=htons(g_consoleConfig.ConsolePort);
             Ser.sin_addr.S_addr:=INADDR_ANY;
             Wsstatus := bind(SocketObj,Ser,SizeOf(Ser));
             if Wsstatus = 0 then
               begin
                 Wsstatus := listen(SocketObj,256);
                 if Wsstatus = 0 then
                    begin
                     //Dbgprint('Listen:%d',[Config.ConsolePort]);
                     new(NewClient);
                     new(Namelen);
                     Namelen^:=sizeof(NewClient^);
                     while True do
                       begin
                         ClientObj := accept(SocketObj,NewClient,NameLen);
                         if ClientObj > 0  then
                           begin
                             //Dbgprint('Ip:%s Ask Connect...',[inet_ntoa(NewClient.sin_addr)]);
                             mCurrentIp:=inet_ntoa(NewClient.sin_addr);
                             mCurrentSocket:=ClientObj;
                             Sleep(100);
                             if OnTokenBuffer(ClientObj) then
                               Synchronize(UpdateGUI);
                           end;
                         Sleep(1);
                       end;   {while}
                    end;
               end;
           end;
       end;
   finally
     WSACleanup();
   end;
end;

end.
