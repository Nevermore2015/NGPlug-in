program Update;

uses
  Forms,SysUtils,
  Windows,
  UMainForm in 'UMainForm.pas' {Form1},
  UWorkProc in 'UWorkProc.pas';

{$R *.res}

begin
  if ParamCount = 2 then
    begin
      Application.Initialize;
      Application.MainFormOnTaskbar := True;
      Application.CreateForm(TForm1, Form1);
      Form1.lbl1.Caption:= '��ǰ�汾:' + ParamStr(1);
      Form1.lbl2.Caption:= ParamStr(2);
      Application.Run;
    end
  else
    MessageBox(0,PChar('���³����������ȷ! ' + inttostr(ParamCount)),'����',0);

end.
