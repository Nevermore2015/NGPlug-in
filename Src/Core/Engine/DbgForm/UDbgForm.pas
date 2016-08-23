unit UDbgForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TDbgForm = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    pnl1: TPanel;
    mmo1: TMemo;
    btn1: TButton;
    mmo2: TMemo;
    chk1: TCheckBox;
    chk2: TCheckBox;
    btn2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    Procedure PrintBuffer(pBuffer:Pointer;Len:Cardinal);
  public
    Procedure Printf(Str:String;Args:array of const);
    Procedure OnSend(pBuffer:Pointer;Len:Cardinal);
    Procedure OnRecv(pBuffer:Pointer;Len:Cardinal);
  end;

var
  DbgForm: TDbgForm;

  procedure LoadDbgForm();
implementation
uses
  UPacketManager,GD_Utils;

{$R *.dfm}

Procedure FormThread();
begin
  Dbgprint('Create DbgForm',[]);
  DbgForm:= TDbgForm.Create(nil);
  DbgForm.ShowModal;
end;

procedure LoadDbgForm();
var
  Lp:Cardinal;
begin
  CreateThread(nil,0,@FormThread,nil,0,Lp);
end;


procedure TDbgForm.btn1Click(Sender: TObject);
begin
  mmo1.Clear;
end;

procedure TDbgForm.FormCreate(Sender: TObject);
begin
//
end;

procedure TDbgForm.OnRecv(pBuffer: Pointer; Len: Cardinal);
begin
  if chk2.Checked then
    begin
      Printf('-Recv Len:0x%X',[Len]);
      PrintBuffer(pBuffer,Len);
    end;
end;

procedure TDbgForm.OnSend(pBuffer: Pointer; Len: Cardinal);
begin
  if chk1.Checked then
    begin
      Printf('-Send Len:0x%X',[Len]);
      PrintBuffer(pBuffer,Len);
    end;
end;

procedure TDbgForm.PrintBuffer(pBuffer: Pointer; Len: Cardinal);
var
  I:Integer;
  p:Pchar;
  S:String;
begin
  p:=pBuffer;
  S:=IntToHex(Ord(p[0]),2);
  for i := 1 to Len - 1 do
    begin
      S:=S + ' ' + IntToHex(Ord(p[i]),2);
    end;
  Printf(S,[]);
end;

procedure TDbgForm.Printf(Str: String; Args: array of const);
begin
  mmo1.Lines.Add(Format(Str,Args));
end;

end.
