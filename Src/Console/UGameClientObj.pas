unit UGameClientObj;

interface
 uses
    Windows;

type
    TGameClientObj = class
      private
        mAccount:String;
        mPassWord:String;
        mServer:Integer;
      public
         constructor Create(_Account,_PassWord:String;_Server:Integer);
    end;
implementation

{ TGameClientObj }

constructor TGameClientObj.Create(_Account, _PassWord: String;
  _Server: Integer);
begin

end;

end.
