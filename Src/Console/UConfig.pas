unit UConfig;

interface
uses
  windows,IniFiles,SysUtils;
const
  C_ROOT = 'system';
  C_VERSION_CHECK = 'VersionUrl';
  C_UPDATE_URL = 'UpdateUrl';
type
  TConfig = class
    private
      mActive:BOOL;
      mDir:String;              //ģ������Ŀ¼
      mCfgPath:String;          //�����ļ�����·��
      mFileName:String;
      mIni:TIniFile;
      function GetUpdateUrl: String;
    function GetCheckUrl: String;
    public
      constructor Create(Handle:Cardinal;FileName:String);
      destructor Destroy;override;
      //�Ƿ���سɹ�
      property Active:Bool read mActive;
      //ģ��Ŀ¼
      property ModuleDir:String read mDir;
      //�·����µ�ַ
      property UpdateUrl:String read GetUpdateUrl;
      //�汾��֤��ַ
      property CheckUrl:String read GetCheckUrl;
  end;
var
  Config:TConfig;

implementation
uses
  GD_Utils;
{ TConfig }

constructor TConfig.Create(Handle:Cardinal;FileName:String);
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

destructor TConfig.Destroy;
begin
  mIni.Free;
end;

function TConfig.GetCheckUrl: String;
begin
 Result:= mIni.ReadString(C_ROOT,C_VERSION_CHECK,'');
end;

function TConfig.GetUpdateUrl: String;
begin
 Result:= mIni.ReadString(C_ROOT,C_UPDATE_URL,'');
end;

end.
