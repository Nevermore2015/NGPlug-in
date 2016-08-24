unit UCheckVersion;

interface
uses
  Windows,IdHTTP,SysUtils,UGlobal,UConfig,GD_Utils;

Function CheckVersion():Integer;


implementation


Function CheckVersion():Integer;
var
  Http:TIdHTTP;
  RepValue:String;
begin
  Result:=1;
  Http:=TIdHTTP.Create(nil);
  try
    try
      Http.ReadTimeout:= 5000;
      LogPrintf('http://%s%d',[Config.CheckUrl , GameId]);
      RepValue:=Http.Get(Format('%s%d',[Config.CheckUrl,GameId]));
      if Strtoint(RepValue) = ConsoleVersion then
        begin
          Result:=0;
        end;
    except
      Result:=2;
      
    end;
  finally
    Http.Free;
  end;
end;
end.
