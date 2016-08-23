unit UGameDbgForm;

interface
uses
   UGameObjBase;

type
   TGameDbgForm = class(TGameObjBase)
     public
       constructor Create();

       Procedure OnRecv(pBuffer:Pointer;Len:Cardinal);override;
       Procedure OnSend(pBuffer:Pointer;Len:Cardinal);override;
   end;

var
   GameDbgForm:TGameDbgForm;
implementation
uses
  GD_Utils,UDbgForm;
{ TGameTest }

constructor TGameDbgForm.Create;
begin
  inherited Create('DbgForm');
end;

procedure TGameDbgForm.OnRecv(pBuffer: Pointer; Len: Cardinal);
begin
  DbgForm.OnRecv(pBuffer,Len);
end;



procedure TGameDbgForm.OnSend(pBuffer: Pointer; Len: Cardinal);
begin
  DbgForm.OnSend(pBuffer,Len);
end;

initialization
   GameDbgForm:=TGameDbgForm.Create;
end.
