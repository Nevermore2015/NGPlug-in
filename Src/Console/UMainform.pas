unit UMainform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus,UGlobal,UCheckVersion,UGameClientObj,
  UGameAddrManager, UWorkthread,SyncObjs;
type
  TClientNode = class
    private
      mIp:String;
      mItem:TListItem;

      function GetPid: Cardinal;
    public
      mClientObject:TGameClientObj;

      constructor Create(LvItem:TListItem;pNode:TGameClientObj);

      Procedure AddSocket(_Socket:Cardinal;_Ip:String);

      Procedure UpdataGui(Idx:Integer = -1;Value:string = '');

      property Pid:Cardinal read GetPid;
      property Ip:String read mIp;
  end;

  TMainForm = class(TForm)
    stat1: TStatusBar;
    lv1: TListView;
    pnl1: TPanel;
    spl1: TSplitter;
    pgc1: TPageControl;
    ts1: TTabSheet;
    mmo1: TMemo;
    mm1: TMainMenu;
    N1: TMenuItem;
    SetAccountMeumItem: TMenuItem;
    grp1: TGroupBox;
    btn1: TButton;
    lbledt1: TLabeledEdit;
    lbledt2: TLabeledEdit;
    btn2: TButton;
    lbledt3: TLabeledEdit;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    chk1: TCheckBox;
    Socket1: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    btn3: TButton;
    procedure btn3Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    mCri:TCriticalSection;
    Net:TWorkThread;
  public
    ClientList:TList;
    procedure Printf(Str:String;Args:Array of const);

    procedure AddNode(pNode:TGameClientObj);

    Function UpdateClientByPid(Pid:Cardinal;_Socket:Cardinal;_Ip:String):Bool;

    property Cri:TCriticalSection read mCri;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

Procedure UpdateUiThread;
var
  i:Integer;
  Node:TClientNode;
begin
  while True do
    begin
        if MainForm.ClientList.Count > 0 then
          begin
            for i := 0 to MainForm.ClientList.Count - 1 do
              begin
                MainForm.Cri.Enter;
                Node:=Mainform.ClientList[i];
                MainForm.Cri.Leave;
                if Assigned(Node) then
                  begin
                    //收取返回包
                   if Node.mClientObject.OnRecvProc() > 0 then
                     begin
                       //同步UI
                       Node.UpdataGui();
                     end;
                  end;
                Sleep(10);
              end;
          end;
          Sleep(10);
    end;
end;

procedure TMainForm.AddNode(pNode: TGameClientObj);
var
  Client:TClientNode;
begin

  Client:=TClientNode.Create(lv1.Items.Add,pNode);
  mCri.Enter;
  ClientList.Add(Client);
  mCri.Leave;
end;

procedure TMainForm.btn2Click(Sender: TObject);
var
  ClientNode:TGameClientObj;
begin
  ClientNode:=TGameClientObj.Create(
    lbledt1.Text,
    lbledt2.Text,
    StrToInt(lbledt3.Text)
  );
  AddNode(ClientNode);
  Printf('启动完毕:%d',[ClientNode.StartGame]);
end;

procedure TMainForm.btn3Click(Sender: TObject);
begin
  mmo1.Clear;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Res:Integer;
  Lp:Cardinal;
begin
  mCri:=TCriticalSection.Create;
  CreateThread(nil,0,@UpdateUiThread,nil,0,Lp);
  Net:=TWorkThread.Create(False);

  //auth check
  ClientList:=TList.Create;
  Printf('欢迎使用 %s 控制台程序,当前版本号:%d',[ConsoleTitle,ConsoleVersion]);

  Res:=g_GameAddr.LoadRemoteData();
  if Res > 0 then
    begin
      Printf('适用游戏版本号:%d',[Res]);
    end
  else
    begin
      Printf('游戏数据错误,Code:%d',[Res]);
    end;
end;

procedure TMainForm.N11Click(Sender: TObject);
begin
case CheckVersion() of
  0:begin
      MessageBox(0,'当前版本为最新!','信息',0);
    end;
  1:begin
      if MessageBox(0,'有新版本需要更新,是否立即更新?','更新提示',MB_OKCANCEL) = ID_OK then
        begin
          WinExec(PChar(Format('.\Update.exe %d',[ConsoleVersion])),SW_NORMAL);
          self.Close;
        end;
    end;
  2:begin
      MessageBox(0,'版本校验出错','信息',0);
    end;
end;

end;

procedure TMainForm.N12Click(Sender: TObject);
begin
  MessageBox(0,Pchar(Format('当前版本号:%d',[ConsoleVersion])),'版本',0);
end;

procedure TMainForm.Printf(Str: String; Args: array of const);
begin
  mmo1.Lines.Add(Format(Str,Args));
end;

Function TMainForm.UpdateClientByPid(Pid:Cardinal;_Socket:Cardinal;_Ip:String):Bool;
var
 i:Integer;
 Node:TClientNode;
begin
  Result:=False;
  if ClientList.Count > 0 then
    begin
      for i := 0 to ClientList.Count - 1 do
        begin
          Node:=ClientList[i];
          if Node.Pid = Pid then
            begin
              Node.AddSocket(_Socket,_Ip);
              Result:=True;

              Break;
            end;
        end;
    end;
end;

{ TClientNode }

procedure TClientNode.AddSocket(_Socket: Cardinal; _Ip: String);
begin
  mClientObject.CreateSocket(_Socket);
  mIp:=_Ip;
  UpdataGui(8,'登录中...');
end;

constructor TClientNode.Create(LvItem: TListItem; pNode: TGameClientObj);
begin
  mItem:=LvItem;
  mClientObject:=pNode;
  mItem.Caption:= '0';
  mItem.SubItems.Add(pNode.Account);
  mItem.SubItems.Add(IntToStr(pNode.Server));
  mItem.SubItems.Add('');
  mItem.SubItems.Add('');
  mItem.SubItems.Add('');
  mItem.SubItems.Add('');
  mItem.SubItems.Add('');
  mItem.SubItems.Add('');
  mItem.SubItems.Add('等待指令');
end;

function TClientNode.GetPid: Cardinal;
begin
  Result:= mClientObject.Pid;
end;



procedure TClientNode.UpdataGui(Idx:Integer = -1;Value:string = '');
begin
  mItem.Caption:=IntToStr(mClientObject.Pid);
  if Idx = -1 then
     begin
        mItem.SubItems.Strings[2]:=mClientObject.PlayerName;
        mItem.SubItems.Strings[3]:=IntToStr(mClientObject.PlayerLv);
        mItem.SubItems.Strings[4]:=IntToStr(mClientObject.PlayerExp);
        mItem.SubItems.Strings[5]:=Format('%d/%d',[mClientObject.PlayerBagNow,mClientObject.PlayerBagMax]);
        mItem.SubItems.Strings[6]:=IntToStr(mClientObject.PlayerMoney);
        mItem.SubItems.Strings[7]:=mClientObject.SciprtState;
     end
  else
    mItem.SubItems.Strings[Idx]:=Value;
  mItem.Update
end;

end.
