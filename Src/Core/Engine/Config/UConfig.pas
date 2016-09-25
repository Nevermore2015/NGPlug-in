unit UConfig;

interface
uses
  windows,IniFiles,SysUtils;
const
  C_ROOT = 'NgPlugin';
type
  TConfig = class
    private
      mActive:BOOL;
      mDir:String;              //模块所在目录
      mCfgPath:String;          //配置文件完整路径
      mFileName:String;
      mIni:TIniFile;
      function GetIp: String;
      function GetPort: Integer;
    public
      constructor Create(Handle:Cardinal;FileName:String);
      destructor Destroy;override;
      //是否加载成功
      property Active:Bool read mActive;
      //模块目录
      property ModuleDir:String read mDir;
      //控制台IP,端口
      property ConsoleIp:String read GetIp;
      property ConsolePort:Integer read GetPort;
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

function TConfig.GetIp: String;
begin
  Result:=mIni.ReadString(C_ROOT,'Ip','');
end;

function TConfig.GetPort: Integer;
begin
  Result:=mIni.ReadInteger(C_ROOT,'Port',0);
end;

end.
