unit UMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gauges, UWorkProc;

type
  TForm1 = class(TForm)
    g1: TGauge;
    lbl1: TLabel;
    lbl2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  Work:TWorkProc;
begin
  g1.MaxValue:=1000;
  g1.Progress:=0;
  Work:=TWorkProc.Create(true);
  Work.Resume;
end;

end.
