unit UConsoleProtocol;
{
  控制台通讯协议
}
interface
  uses
     Windows;

const
  c_Req_Token = 1;
  c_Res_Token = 2;
  c_Req_Game_Address = 3;
  c_Res_Game_Address = 4;

type
   PNG_HEAD = ^_Ng_Head;
   _Ng_Head = packed record
     Cmd:Word;
     Size:Word;
     Pid:Cardinal;
     ErrorCode:Cardinal;
     Tick:Cardinal;
   end;

   PReqToken = ^_req_token;
   _Req_Token = packed record
      Head:_Ng_Head;
      Ng_ver:Integer;
   end;

   PResToken = ^_res_token;
   _res_token = packed record
     Head:_Ng_Head;
     Token:Int64;
     GameVer:Integer;
   end;

   PReqGameAddress = ^_req_game_address;
   _req_game_address = packed record
     Head:_Ng_Head;
     TagId:Cardinal;
   end;
   PResGameAddress = ^_res_game_address;
   _res_game_address = packed record
     Head:_Ng_Head;
     TagId:Integer;
     ModuleName:Array [0..254] of char;
     Offset:Cardinal;
   end;

   PRep_Game_Info = ^_Rep_Game_Info;
   _Rep_Game_Info = packed record

   end;
implementation

end.
