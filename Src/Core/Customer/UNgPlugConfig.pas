unit UNgPlugConfig;
{
  引擎内部 设定
}


{$DEFINE _DBG_MODE}

{$IFDEF _DBG_MODE}
{$MESSAGE HINT '调试版本'}
{$ENDIF}

interface
   uses
     UDbgForm;
const
   {授权码}
   NG_SN = 'abcdef124879654';
   {引擎版本}
   NG_EngineVer = '3.0';
   {插件版本号}
   NgPlugin_ver = 20160920;

   {调试模式下的配置}
   {$IFDEF _DBG_MODE}
   NG_DEBUG_MODE = 1;
   {$ELSE}
   NG_DEBUG_MODE = 0;
   {$ENDIF}

   {控制台通讯协议}
   NG_DoCommand_Tag                       = 1;
   NG_UiManagerBase_Tag                   = 2;
   NG_CGameStartup_InitFramework_Tag      = 3;
   NG_Recv_Tag                            = 4;
   NG_Send_Tag                            = 5;
   NG_GetAttrBase_Tag                     = 6;

//加载配置
Procedure NgPlugConfigLoad();
//判断是否调试模式
function NgPlugDebugMode():Boolean;

implementation

Procedure NgPlugConfigLoad();
begin
  LoadDbgForm();
end;

function NgPlugDebugMode():Boolean;
begin
  Result:= NG_DEBUG_MODE = 1;
end;
end.
