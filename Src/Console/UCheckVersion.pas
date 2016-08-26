unit UCheckVersion;

interface
uses
  Windows,IdHTTP,Classes,SysUtils,UGlobal,UConfig,GD_Utils;


Function CheckVersion():Integer;


implementation


Function CheckVersion():Integer;
var
  Http:TIdHTTP;
  RepValue:String;
  Rs:TStringList;
begin
  Result:=1;
  Rs:=TStringList.Create;
  Http:=TIdHTTP.Create(nil);
  try
    try
      Http.ReadTimeout:= 5000;
      Rs.add('Id=' + inttostr(GameId));
      RepValue:=Http.Post(Config.AuthUrl + C_VERSION_CHECK,Rs);
      if Strtoint(RepValue) = ConsoleVersion then
        begin
          Result:=0;
        end;
    except
      Result:=2;
    end;
  finally
    Rs.Free;
    Http.Free;
  end;
end;
end.
