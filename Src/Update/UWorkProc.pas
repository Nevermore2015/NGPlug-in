unit UWorkProc;

interface

uses
  Windows,Classes;

type
  TWorkProc = class(TThread)
  private
    iPorc:Integer;
    procedure UpdataUI;
  protected
    procedure Execute; override;
  end;

implementation
  uses
    UMainForm;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TWorkProc.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TWorkProc }

procedure TWorkProc.UpdataUI();
begin
  Form1.g1.Progress:=iPorc;
end;

procedure TWorkProc.Execute;
begin
  iPorc:=0;
  while True do
   begin
     Inc(iPorc);
     Synchronize(UpdataUI);
     Sleep(100);
   end;
end;

end.
