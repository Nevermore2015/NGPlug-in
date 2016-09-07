unit UMainform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus,UGlobal,UCheckVersion,UInject;

type
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
    btn3: TButton;
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
    procedure btn3Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Printf(Str:String;Args:Array of const);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.btn3Click(Sender: TObject);
begin
  mmo1.Clear;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //auth check
  if EnableDebugPriv then
    begin
      Printf('启动成功!',[]);
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

end.
