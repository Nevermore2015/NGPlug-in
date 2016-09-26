unit UGameClientObj;

interface
 uses
    Windows,UConfig,SysUtils,WinSock,UConsoleProtocol,GD_Utils;

type
    TGameClientObj = class
      private
        mAccount:String;
        mPassWord:String;
        mServer:Integer;
        mStatus:Integer;
        mPid:Integer;
        mSocket:Cardinal;
        function GetPlayerBagMax: Integer;
        function GetPlayerBagNow: Integer;
        function GetPlayerExp: Int64;
        function GetPlayerLv: Integer;
        function GetPlayerMoney: Integer;
        function GetPlayerName: String;
        function GetScriptState: String;

      public
         constructor Create(_Account,_PassWord:String;_Server:Integer);
         //·µ»ØPid
         Function StartGame():Cardinal;
         //Ìí¼ÓSocket
         Procedure CreateSocket(_Socket:Cardinal);

         Function OnRecvProc():Integer;

         property Account:String read mAccount;
         property PassWord:String read mPassWord;
         property Server:Integer read mServer;

         property PlayerName:String read GetPlayerName;
         property PlayerLv:Integer read GetPlayerLv;
         property PlayerExp:Int64 read GetPlayerExp;
         property PlayerBagMax:Integer read GetPlayerBagMax;
         property PlayerBagNow:Integer read GetPlayerBagNow;
         property PlayerMoney:Integer read GetPlayerMoney;
         property SciprtState:String read GetScriptState;

         property Pid:Integer read mPid;
         property Status:Integer read mStatus;
    end;
implementation
  uses
    UGameAddrManager;
{ TGameClientObj }

constructor TGameClientObj.Create(_Account, _PassWord: String;
  _Server: Integer);
begin
  mAccount:=_Account;
  mPassWord:=_PassWord;
  mServer:=_Server;
  mSocket:=0;
end;

procedure TGameClientObj.CreateSocket(_Socket: Cardinal);
begin
  mSocket:=_Socket;
end;

function TGameClientObj.GetPlayerBagMax: Integer;
begin
  Result:=100;
end;

function TGameClientObj.GetPlayerBagNow: Integer;
begin
  Result:=0;
end;

function TGameClientObj.GetPlayerExp: Int64;
begin
  Result:=0;
end;

function TGameClientObj.GetPlayerLv: Integer;
begin
  Result:=0;
end;

function TGameClientObj.GetPlayerMoney: Integer;
begin
  Result:=0;
end;

function TGameClientObj.GetPlayerName: String;
begin
  Result:='';
end;

function TGameClientObj.GetScriptState: String;
begin
  Result:='';
end;


function TGameClientObj.OnRecvProc: Integer;
var
  pHead:PNG_HEAD;
  Buffer:Array [0..2048] of byte;
  Len:Integer;

  pAddr:PReqGameAddress;
  AddrRes:_res_game_address;
begin
  Result:=0;
  //Dbgprint('OnRecv :%d',[mPid]);
  Len:= recv(mSocket,Buffer,2048,0);
  if  Len > 0 then
    begin

      pHead:=@Buffer;
      Dbgprint('Console Client-> OnRecv :%d Cmd:%d',[mPid,pHead.Cmd]);
      case pHead.Cmd of
        c_Req_Game_Address:begin
            pAddr:=@Buffer;
            AddrRes.Head.Cmd:=c_Res_Game_Address;
            AddrRes.Head.Size:=SizeOf(_res_game_address);
            AddrRes.Head.Pid:=mPid;
            AddrRes.Head.ErrorCode:=0;
            AddrRes.Head.Tick:=GetTickCount;
            AddrRes.TagId:= pAddr.TagId;
            if Not(g_GameAddr.QueryAddressByTagId(pAddr.TagId,@AddrRes)) then
              begin
                AddrRes.Head.ErrorCode:= 100;
              end;
            send(mSocket,AddrRes,SizeOf(_res_game_address),0);
         end;
      end;
      Result:=Len;
    end;
end;

function TGameClientObj.StartGame: Cardinal;
var
  Handle,MapHandle:Cardinal;
  EventName,MapName:String;
  pBuf:pCardinal;
begin
  EventName:= Format('%s_%d',[mAccount,GetTickCount]);
  MapName:= Format('Map_%s_%d',[mAccount,GetTickCount]);
  Handle:=CreateEvent(nil,False,False,PChar(EventName));
  MapHandle:=CreateFileMapping(INVALID_HANDLE_VALUE,nil,PAGE_READWRITE,0,$100,PChar(MapName));
  if (Handle <> 0) and (MapHandle <> 0) then
    begin

      WinExec(PChar(Format('.\Jumper.exe %s %s %s',[EventName,MapName,config.GameBin])),SW_NORMAL);

      WaitForSingleObject(Handle,INFINITE);
      pBuf:=MapViewOfFile(MapHandle,FILE_MAP_READ,0,0,0);
      if pBuf<> nil then
        begin
          mPid:=pBuf^;
          UnmapViewOfFile(pBuf);
        end;
      CloseHandle(MapHandle);
      CloseHandle(Handle);
    end;
  Result:=mPid;
end;

end.
