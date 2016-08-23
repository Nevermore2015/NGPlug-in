unit GD_Utils;

interface
uses
   Windows,SysUtils;

const
   DBG_MARK = 'GD::';             //���Ա�ǩ����������

//�������
procedure Dbgprint(const Str:String;Args:Array of const);
//�����ַ���MD5
function HashString(Str:String):String;
//�����ļ�MD5
function HashFile(FileName:String):String;
//������־
function CreateLog(Handle:Cardinal):bool;
//д��־
procedure LogPrintf(const Str:String;Args:Array of const);
//��������
function LoadConfig(Handle:Cardinal;FileName:String):bool;




implementation
uses
  MD5,ULog,UConfig;

procedure Dbgprint(const Str:String;Args:Array of const);
begin
  OutputDebugString(PChar(DBG_MARK + Format(Str,Args)));
end;

function HashString(Str:String):String;
begin
  Result:=MD5Print(MD5String(Str));
end;

function HashFile(FileName:String):String;
begin
  if FileExists(FileName) then
    Result:=MD5Print(MD5File(FileName))
  else
    Result:='';
end;

function CreateLog(Handle:Cardinal):bool;
var
  FileName,ModuleDir:String;
  ModuleName:Array [0..MAX_PATH] of Char;
begin
  Result:=False;
  try
    if GetModuleFileName(Handle,ModuleName,MAX_PATH) > 0 then
      begin
        ModuleDir:=ExtractFileDir(ModuleName);
        CreateDir(ModuleDir + '\Log\');
        FileName :=Format('%s\Log\%s.Log',[ModuleDir,FormatDateTime('yyyy-mm-dd_hhmmss',Now)]);
        Log:=TLog.Create(FileName);
        Result:=True;
      end;
  Except
    Result:=False;
  end;
end;

procedure LogPrintf(const Str:String;Args:Array of const);
begin
  Dbgprint(Str,Args);
  if Assigned(Log) then
    begin
      Log.WriteLog(Format(Str,Args));
    end;
end;

function LoadConfig(Handle:Cardinal;FileName:String):bool;
begin
  Config:=TConfig.Create(Handle,FileName);
  Result:=Config.Active;
  if not(Config.Active) then
    Config.Free;
end;

end.
