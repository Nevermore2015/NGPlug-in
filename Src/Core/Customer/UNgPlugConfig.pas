unit UNgPlugConfig;
{
  �����ڲ� �趨
}


{$DEFINE _DBG_MODE}

{$IFDEF _DBG_MODE}
{$MESSAGE HINT '���԰汾'}
{$ENDIF}

interface
   uses
     UDbgForm;
const
   {��Ȩ��}
   NG_SN = 'abcdef124879654';
   {����汾}
   NG_EngineVer = '3.0';
   {����汾��}
   NgPlugin_ver = 20160920;

   {����ģʽ�µ�����}
   {$IFDEF _DBG_MODE}
   NG_DEBUG_MODE = 1;
   {$ELSE}
   NG_DEBUG_MODE = 0;
   {$ENDIF}

   {����̨ͨѶЭ��}
   NG_DoCommand_Tag                       = 1;
   NG_UiManagerBase_Tag                   = 2;
   NG_CGameStartup_InitFramework_Tag      = 3;
   NG_Recv_Tag                            = 4;
   NG_Send_Tag                            = 5;
   NG_GetAttrBase_Tag                     = 6;

//��������
Procedure NgPlugConfigLoad();
//�ж��Ƿ����ģʽ
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
