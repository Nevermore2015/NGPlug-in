unit UEngineConfig;

interface
uses
  windows,IniFiles,SysUtils;
const
  C_ROOT = 'NgPlugin';
type
  TEngineConfig = class
    private
      mActive:BOOL;
      mDir:String;              //ģ������Ŀ¼
      mCfgPath:String;          //�����ļ�����·��
      mFileName:String;
      mIni:TIniFile;
      function GetIp: String;
      function GetPort: Integer;
    public
      constructor Create(Handle:Cardinal;FileName:String);
      destructor Destroy;override;
      //�Ƿ���سɹ�
      property Active:Bool read mActive;
      //ģ��Ŀ¼
      property ModuleDir:String read mDir;
      //����̨IP,�˿�
      property ConsoleIp:String read GetIp;
      property ConsolePort:Integer read GetPort;
  end;
var
  g_EngineConfig:TEngineConfig;

implementation
uses
  GD_Utils;
{ TConfig }

constructor TEngineConfig.Create(Handle:Cardinal;FileName:String);
var
  ModuleName:Array [0..MAX_PATH] of Char;
begin
  mActive:=False;
  try
    if GetModuleFileName(Handle,ModuleName,MAX_PATH) > 0 then
      begin
        mFileName:=FileName;
        mDir:=ExtractFileDir(ModuleName);
        mCfgPath:=Format('%s\%s',[mDir,FileName]);
        mActive:=FileExists(mCfgPath);
        if mActive then
          mIni:=TIniFile.Create(mCfgPath);
      end;
  except
    LogPrintf('Config Load Error',[]);
  end;
end;

destructor TEngineConfig.Destroy;
begin
  mIni.Free;
end;

function TEngineConfig.GetIp: String;
begin
  Result:=mIni.ReadString(C_ROOT,'Ip','');
end;

function TEngineConfig.GetPort: Integer;
begin
  Result:=mIni.ReadInteger(C_ROOT,'Port',0);
end;

end.
