unit UConfig;

interface
uses
  windows,IniFiles,SysUtils;
const
  C_ROOT = 'system';
  C_GAME = 'game';
  C_NGPLUGS = 'NgPlugin';
type
  TConfig = class
    private
      mActive:BOOL;
      mDir:String;              //ģ������Ŀ¼
      mCfgPath:String;          //�����ļ�����·��
      mFileName:String;
      mIni:TIniFile;
      function GetAuthUrl: String;
      function GetGameBin: string;
      function GetGameId: Integer;
    function GetPort: Integer;
    public
      constructor Create(Handle:Cardinal;FileName:String);
      destructor Destroy;override;
      //�Ƿ���سɹ�
      property Active:Bool read mActive;
      //ģ��Ŀ¼
      property ModuleDir:String read mDir;
      //�汾��֤��ַ
      property AuthUrl:String read GetAuthUrl;
      //
      property GameBin:string read GetGameBin;

      property GameId:Integer read GetGameId;

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

function TConfig.GetAuthUrl: String;
begin
 Result:= mIni.ReadString(C_ROOT,'ServerUrl','');
end;

function TConfig.GetGameBin: string;
begin
 Result:= mIni.ReadString(C_GAME,'GameBin','');
end;

function TConfig.GetGameId: Integer;
begin
 Result:= mIni.ReadInteger(C_GAME,'GameId',0);
end;

function TConfig.GetPort: Integer;
begin
 Result:= mIni.ReadInteger(C_NGPLUGS,'Port',0);
end;

end.
