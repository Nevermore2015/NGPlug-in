unit UMainform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,idhttp, Menus;

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
    procedure SetAccountMeumItemClick(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.btn3Click(Sender: TObject);
begin
  mmo1.Clear;
end;

procedure TMainForm.SetAccountMeumItemClick(Sender: TObject);
var
  H:TIdHTTP;
  Str:TStringList;
begin
  Str:=TStringList.Create;
  H:=TIdHTTP.Create(nil);
  try
    mmo1.Lines.Add(H.Post('http://devincubator.stcsm.gov.cn/fhq-web/user/getUserInfo.json',Str));
  finally
    Str.Free;
    H.Free;
  end;

end;

end.
