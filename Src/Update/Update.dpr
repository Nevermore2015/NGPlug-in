program Update;

uses
  Forms,
  SysUtils,
  Windows,
  UMainForm in 'UMainForm.pas' {Form1},
  UWorkProc in 'UWorkProc.pas',
  MD5 in '..\Inc\MD5.pas',
  superobject in '..\Inc\superobject.pas',
  GD_Utils in '..\Inc\GD_Utils.pas',
  ULog in '..\Inc\Log\ULog.pas',
  UConfig in 'UConfig.pas';

{$R *.res}

begin
  if ParamCount = 1 then
    begin
      if LoadConfig(HInstance,'config.ini') then
        begin
          Application.Initialize;
          Application.MainFormOnTaskbar := True;
          Application.CreateForm(TForm1, Form1);
          Form1.lbl1.Caption:= '��ǰ�汾:' + ParamStr(1);
         
          Application.Run;
        end;
    end
  else
    MessageBox(0,PChar('���³����������ȷ! ' + inttostr(ParamCount)),'����',0);

end.
