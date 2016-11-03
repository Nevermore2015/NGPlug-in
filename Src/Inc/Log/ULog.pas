unit ULog;

interface
uses
  windows,SysUtils;

type
  TLog = class
    private
      mFile:TextFile;
    public
      constructor Create(FileName:String);
      destructor Destroy(); override;

      procedure WriteLog(S: String);
  end;

var
  Log:TLog;
  
implementation

{ TLog }

constructor TLog.Create(FileName: String);
begin
  AssignFile(mFile, FileName);
  if FileExists(FileName) then
  begin
    Append(mFile);
  end
  else
  begin
    Rewrite(mFile);
  end;
end;

destructor TLog.Destroy;
begin
  CloseFile(mFile);
end;


procedure TLog.WriteLog(S: String);
begin
   Writeln(mFile,TimeToStr(Now)+' ' + S);
   Flush(mFile);
end;

end.
